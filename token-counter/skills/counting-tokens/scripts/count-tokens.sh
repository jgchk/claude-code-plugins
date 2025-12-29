#!/usr/bin/env bash
#
# Token Counter using Anthropic's Token Counting API
#
# Counts exact tokens for text or files without generating a response.
#
# Requirements:
#   - ANTHROPIC_API_KEY environment variable
#   - curl, base64, jq (optional, for pretty output)
#
# Usage:
#   count-tokens.sh --text "Hello, Claude!"
#   count-tokens.sh --file document.txt
#   count-tokens.sh --file document.pdf
#   count-tokens.sh --text "Hello" --system "You are helpful"
#   count-tokens.sh --file image.png --model claude-opus-4-5

set -euo pipefail

API_URL="https://api.anthropic.com/v1/messages/count_tokens"
MODEL="claude-sonnet-4-5"
TEXT=""
FILE=""
SYSTEM_PROMPT=""
JSON_OUTPUT=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Count tokens using Anthropic's Token Counting API.

Options:
  -t, --text TEXT       Text content to count tokens for
  -f, --file FILE       File path (text, PDF, or image)
  -s, --system PROMPT   System prompt to include in count
  -m, --model MODEL     Model for tokenization (default: claude-sonnet-4-5)
  -j, --json            Output raw JSON response
  -h, --help            Show this help message

Examples:
  $(basename "$0") --text "Hello, Claude!"
  $(basename "$0") --file document.pdf
  $(basename "$0") --file code.py --system "You are a code reviewer"
  $(basename "$0") --text "Hello" --model claude-opus-4-5
EOF
    exit 0
}

error() {
    echo "Error: $1" >&2
    exit 1
}

get_media_type() {
    local file="$1"
    local ext="${file##*.}"
    ext="${ext,,}"  # lowercase

    case "$ext" in
        pdf) echo "application/pdf" ;;
        jpg|jpeg) echo "image/jpeg" ;;
        png) echo "image/png" ;;
        gif) echo "image/gif" ;;
        webp) echo "image/webp" ;;
        *) echo "text/plain" ;;
    esac
}

build_content_block() {
    local file="$1"
    local media_type
    media_type=$(get_media_type "$file")

    if [[ "$media_type" == "application/pdf" ]]; then
        local data
        data=$(base64 < "$file" | tr -d '\n')
        cat <<EOF
{"type": "document", "source": {"type": "base64", "media_type": "application/pdf", "data": "$data"}}
EOF
    elif [[ "$media_type" == image/* ]]; then
        local data
        data=$(base64 < "$file" | tr -d '\n')
        cat <<EOF
{"type": "image", "source": {"type": "base64", "media_type": "$media_type", "data": "$data"}}
EOF
    else
        # Text file - read and escape for JSON
        local content
        content=$(cat "$file")
        # Escape JSON special characters
        content=$(printf '%s' "$content" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '%s' "$content" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g; s/\r/\\r/g' | awk '{printf "%s\\n", $0}' | sed 's/\\n$//')
        # Remove surrounding quotes if python added them
        content="${content#\"}"
        content="${content%\"}"
        cat <<EOF
{"type": "text", "text": "$content"}
EOF
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--text)
            TEXT="$2"
            shift 2
            ;;
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -s|--system)
            SYSTEM_PROMPT="$2"
            shift 2
            ;;
        -m|--model)
            MODEL="$2"
            shift 2
            ;;
        -j|--json)
            JSON_OUTPUT=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Validate
[[ -z "${ANTHROPIC_API_KEY:-}" ]] && error "ANTHROPIC_API_KEY environment variable not set"
[[ -z "$TEXT" && -z "$FILE" ]] && error "At least one of --text or --file is required"
[[ -n "$FILE" && ! -f "$FILE" ]] && error "File not found: $FILE"

# Build content array
CONTENT_BLOCKS=""

if [[ -n "$FILE" ]]; then
    CONTENT_BLOCKS=$(build_content_block "$FILE")
fi

if [[ -n "$TEXT" ]]; then
    # Escape text for JSON
    ESCAPED_TEXT=$(printf '%s' "$TEXT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '%s' "$TEXT" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g; s/\r/\\r/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//')
    ESCAPED_TEXT="${ESCAPED_TEXT#\"}"
    ESCAPED_TEXT="${ESCAPED_TEXT%\"}"

    if [[ -n "$CONTENT_BLOCKS" ]]; then
        CONTENT_BLOCKS="$CONTENT_BLOCKS, {\"type\": \"text\", \"text\": \"$ESCAPED_TEXT\"}"
    else
        CONTENT_BLOCKS="{\"type\": \"text\", \"text\": \"$ESCAPED_TEXT\"}"
    fi
fi

# Build request body
if [[ -n "$SYSTEM_PROMPT" ]]; then
    ESCAPED_SYSTEM=$(printf '%s' "$SYSTEM_PROMPT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '%s' "$SYSTEM_PROMPT" | sed 's/\\/\\\\/g; s/"/\\"/g')
    ESCAPED_SYSTEM="${ESCAPED_SYSTEM#\"}"
    ESCAPED_SYSTEM="${ESCAPED_SYSTEM%\"}"
    REQUEST_BODY=$(cat <<EOF
{
  "model": "$MODEL",
  "system": "$ESCAPED_SYSTEM",
  "messages": [{"role": "user", "content": [$CONTENT_BLOCKS]}]
}
EOF
)
else
    REQUEST_BODY=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [{"role": "user", "content": [$CONTENT_BLOCKS]}]
}
EOF
)
fi

# Make API request
# anthropic-version: 2023-06-01 is the stable API version for token counting
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL" \
    -H "Content-Type: application/json" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d "$REQUEST_BODY")

# Extract HTTP status code (last line) and body (everything else)
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# Check for errors
if [[ "$HTTP_CODE" != "200" ]]; then
    echo "API Error (HTTP $HTTP_CODE):" >&2
    echo "$BODY" >&2
    exit 1
fi

# Output results
if [[ "$JSON_OUTPUT" == true ]]; then
    echo "$BODY"
else
    # Try to use jq for pretty output, fall back to grep
    if command -v jq &>/dev/null; then
        TOKEN_COUNT=$(echo "$BODY" | jq -r '.input_tokens')
    else
        TOKEN_COUNT=$(echo "$BODY" | grep -o '"input_tokens":[0-9]*' | grep -o '[0-9]*')
    fi

    echo "Token Count: $TOKEN_COUNT"
    echo "Model: $MODEL"
    [[ -n "$SYSTEM_PROMPT" ]] && echo "System prompt: included"
    [[ -n "$FILE" ]] && echo "File: $FILE ($(get_media_type "$FILE"))"
    [[ -n "$TEXT" ]] && echo "Text content: included"
fi
