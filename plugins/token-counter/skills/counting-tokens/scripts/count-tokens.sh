#!/usr/bin/env bash
#
# Token Counter using Anthropic's Token Counting API
#
# Counts exact tokens for text or files without generating a response.
#
# Requirements:
#   - ANTHROPIC_API_KEY environment variable
#   - curl, python3, jq (optional, for pretty output)
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
    ext=$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')  # lowercase (POSIX compatible)

    case "$ext" in
        pdf) echo "application/pdf" ;;
        jpg|jpeg) echo "image/jpeg" ;;
        png) echo "image/png" ;;
        gif) echo "image/gif" ;;
        webp) echo "image/webp" ;;
        *) echo "text/plain" ;;
    esac
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

# Create temp file for request body
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

# Use Python to build JSON payload (handles large files without shell variable limits)
python3 << PYTHON_SCRIPT
import json
import base64
import sys
import os

model = "$MODEL"
text = """$TEXT"""
file_path = """$FILE"""
system_prompt = """$SYSTEM_PROMPT"""
output_file = "$TEMP_FILE"

def get_media_type(filepath):
    ext = filepath.rsplit('.', 1)[-1].lower() if '.' in filepath else ''
    media_types = {
        'pdf': 'application/pdf',
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
        'gif': 'image/gif',
        'webp': 'image/webp',
    }
    return media_types.get(ext, 'text/plain')

content_blocks = []

if file_path:
    media_type = get_media_type(file_path)

    if media_type == 'application/pdf':
        with open(file_path, 'rb') as f:
            data = base64.b64encode(f.read()).decode('utf-8')
        content_blocks.append({
            "type": "document",
            "source": {"type": "base64", "media_type": "application/pdf", "data": data}
        })
    elif media_type.startswith('image/'):
        with open(file_path, 'rb') as f:
            data = base64.b64encode(f.read()).decode('utf-8')
        content_blocks.append({
            "type": "image",
            "source": {"type": "base64", "media_type": media_type, "data": data}
        })
    else:
        # Text file
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            file_content = f.read()
        content_blocks.append({"type": "text", "text": file_content})

if text:
    content_blocks.append({"type": "text", "text": text})

payload = {
    "model": model,
    "messages": [{"role": "user", "content": content_blocks}]
}

if system_prompt:
    payload["system"] = system_prompt

with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(payload, f)
PYTHON_SCRIPT

# Make API request
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL" \
    -H "Content-Type: application/json" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d @"$TEMP_FILE")

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
    [[ -n "$SYSTEM_PROMPT" ]] && echo "System prompt: included" || true
    [[ -n "$FILE" ]] && echo "File: $FILE ($(get_media_type "$FILE"))" || true
    [[ -n "$TEXT" ]] && echo "Text content: included" || true
fi
