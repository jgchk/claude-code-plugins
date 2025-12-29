# Minimal Plugin Example

The simplest valid Claude Code plugin structure.

## Directory Structure

```
my-minimal-plugin/
├── .claude-plugin/
│   └── plugin.json
└── commands/
    └── hello.md
```

## Files

### .claude-plugin/plugin.json

```json
{
  "name": "my-minimal-plugin",
  "description": "A minimal example plugin",
  "version": "1.0.0"
}
```

### commands/hello.md

```markdown
---
name: hello
description: A simple greeting command
---

# Hello Command

Respond with a friendly greeting to the user.
```

## Key Points

- `.claude-plugin/` contains ONLY `plugin.json`
- `commands/` is at the root level, NOT inside `.claude-plugin/`
- All required fields present in plugin.json
- Command has valid frontmatter
