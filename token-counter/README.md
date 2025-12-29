# Token Counter Plugin

A Claude Code plugin for counting exact tokens using Anthropic's Token Counting API.

## Installation

```bash
# Clone or copy this plugin to your Claude Code plugins directory
cp -r token-counter ~/.claude/plugins/
```

## Features

- Exact token counts using Anthropic's official API
- Supports text, PDFs, and images
- System prompt inclusion
- JSON output for scripting
- Minimal dependencies (curl, python3)

## Usage

The plugin adds a `counting-tokens` skill that Claude automatically triggers when you need token counts.

**Examples:**
- "How many tokens is this prompt?"
- "Count the tokens in my-document.pdf"
- "What's the token count for this file?"

## Requirements

- `ANTHROPIC_API_KEY` environment variable
- `curl`, `python3` (standard on macOS/Linux)
- `jq` (optional, for prettier output)

## API Reference

The plugin uses the `/v1/messages/count_tokens` endpoint which:
- Is free to use (no token charges)
- Has rate limits based on your tier (100-8000 RPM)
- Provides exact tokenization for the specified model

## License

MIT
