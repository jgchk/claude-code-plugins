---
name: counting-tokens
description: Counting exact tokens for text or documents using Anthropic's Token Counting API. Use when the user needs accurate token counts for prompts, files, PDFs, or images.
allowed-tools: Read, Bash
---

# Token Counting

Get exact token counts using Anthropic's official Token Counting API.

## When to Use

- User asks "how many tokens is this?"
- Planning prompt optimization and need exact counts
- Checking if content fits within context limits
- Comparing token costs between different approaches

## Usage

Run `scripts/count-tokens.sh` from this skill's directory:

```bash
# Count tokens for text
scripts/count-tokens.sh --text "Your text here"

# Count tokens for a file
scripts/count-tokens.sh --file /path/to/document.pdf

# Include system prompt in count
scripts/count-tokens.sh --text "Hello" --system "You are helpful"

# JSON output for programmatic use
scripts/count-tokens.sh --file document.txt --json
```

## Supported Content Types

| Type | Extensions | Notes |
|------|------------|-------|
| Text | .txt, .md, .py, .js, etc. | Any UTF-8 text file |
| PDF | .pdf | Extracts and counts all text |
| Images | .jpg, .png, .gif, .webp | Counts visual tokens |

## Requirements

- `ANTHROPIC_API_KEY` environment variable set
- `curl`, `python3` (standard on macOS/Linux)
- `jq` optional (for prettier output)

## Model Selection

Default model is `claude-sonnet-4-5`. Override with `--model`:

```bash
scripts/count-tokens.sh --text "Hello" --model claude-opus-4-5
```

## Important Notes

- Token counts are estimates; actual usage may vary slightly
- The API is free but has rate limits (100-8000 RPM based on tier)
- Token counts include any system-added formatting tokens
