# SKILL.md Schema

## Required Frontmatter

```yaml
---
name: skill-name
description: What it does. Use when [trigger conditions].
---
```

| Field | Constraints |
|-------|-------------|
| `name` | kebab-case, matches directory name, max 64 chars |
| `description` | Max 1024 chars, must include "Use when..." |

## Optional Frontmatter

| Field | Purpose | Example |
|-------|---------|---------|
| `allowed-tools` | Restrict available tools | `Read, Grep, Glob` |
| `model` | Override model | `claude-sonnet-4-20250514` |

### allowed-tools Patterns

- `Read, Grep, Glob` - Specific tools only
- `Bash(python:*)` - Only python commands
- `Bash(npm:*, yarn:*)` - Only npm and yarn
- `Bash(git:status, git:diff)` - Specific subcommands

## Description Best Practices

**Required elements:**
1. Action verbs: "extracts", "reviews", "generates"
2. Domain terms: "PDF", "security", "deployment"
3. "Use when..." clause

**Good example:**
```yaml
description: Reviews code for security vulnerabilities and best practices. Use when reviewing PRs, checking for OWASP issues, or assessing code quality.
```

**Bad example:**
```yaml
description: Helps with code
```

## Body Best Practices

- Keep under 500 lines total
- Put detailed reference material in separate files
- Link to reference files rather than inline content
- Put scripts in `scripts/` subdirectory
- Tell Claude to RUN scripts, not READ them
