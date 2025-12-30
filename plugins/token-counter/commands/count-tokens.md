---
name: count-tokens
description: Count exact tokens for text, files, PDFs, or images using Anthropic's Token Counting API
allowed-tools:
  - Bash
  - Read
---

# Count Tokens

Count exact tokens for text or files using Anthropic's Token Counting API.

## Parameters

- `$ARGUMENTS` - Text to count tokens for, OR a file path (e.g., `"Hello world"` or `/path/to/file.txt`)

## Workflow

1. **Determine input type**
   - If `$ARGUMENTS` looks like a file path (starts with `/`, `./`, `~`, or contains common file extensions), treat it as a file
   - Otherwise, treat it as literal text to count

2. **Run the token counting script**
   - Use the `counting-tokens` skill's script at `${CLAUDE_PLUGIN_ROOT}/skills/counting-tokens/scripts/count-tokens.sh`
   - Pass `--file` for file inputs or `--text` for text inputs
   - Always include `--model` with your current model ID for accurate counts

3. **Report results**
   - Display the token count
   - For files, show the file path and detected type

## Examples

```
/count-tokens "Hello, how many tokens is this?"
```

Counts tokens for the provided text.

```
/count-tokens /path/to/document.pdf
```

Counts tokens for the PDF file.

```
/count-tokens ./src/main.ts
```

Counts tokens for the TypeScript file.
