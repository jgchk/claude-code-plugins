---
name: optimizing-plugins
description: Creates, audits, and optimizes Claude Code plugins and skills. Use when creating new plugins, improving existing ones, reviewing plugin structure, or troubleshooting plugin issues.
allowed-tools: Read, Glob, Grep, Edit, Write
---

# Optimizing Plugins

## Routing

**Creating a new plugin?** → Follow [workflows/create-plugin.md](workflows/create-plugin.md)

**Auditing/optimizing an existing plugin?** → Follow [workflows/audit-plugin.md](workflows/audit-plugin.md)

## Critical Rules

These rules cause plugins to fail if violated:

1. `.claude-plugin/` contains ONLY `plugin.json` - nothing else
2. All component directories (`commands/`, `skills/`, `agents/`) at plugin root, NOT inside `.claude-plugin/`
3. All paths in plugin.json are relative, starting with `./`
4. Skills require `SKILL.md` with valid YAML frontmatter (`name` and `description`)

## Plugin Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # ONLY file here
├── commands/            # Slash commands
├── skills/              # Domain skills
├── agents/              # Parallel workers
├── hooks/               # Event hooks
└── README.md
```

## Naming Conventions

- Plugin names: `kebab-case`, max 64 chars
- Skill names: `kebab-case`, prefer gerunds (`reviewing-code` not `code-reviewer`)
- All directory and file names: `kebab-case`

## Description Quality

Good descriptions answer: **What does it do? When should it trigger?**

```yaml
# Good - specific, triggerable
description: Extracts text from PDFs and fills forms. Use when working with PDF documents.

# Bad - vague
description: Helps with documents
```

Always include action verbs and domain terms. Use "Use when..." pattern.

## Severity Levels

When auditing, classify issues by impact:

| Level | Meaning | Examples |
|-------|---------|----------|
| **CRITICAL** | Plugin won't work | Missing plugin.json, files in .claude-plugin/, invalid frontmatter |
| **HIGH** | Major functionality issues | Vague descriptions, oversized SKILL.md (500+ lines), wrong paths |
| **MEDIUM** | Best practice violations | Missing metadata, poor organization, no TOC in long files |
| **LOW** | Style/documentation | Missing README, inconsistent naming |

## Reference

- [context/plugin-schema.md](context/plugin-schema.md) - plugin.json fields
- [context/skill-schema.md](context/skill-schema.md) - SKILL.md frontmatter
- [templates/](templates/) - Scaffolding templates
- [examples/](examples/) - Example structures
