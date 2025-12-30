# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a monorepo containing Claude Code plugins. Plugins are located in the `plugins/` directory, each with its own `.claude-plugin/plugin.json` manifest.

## Current Plugins

- **ddd-expert**: Domain-Driven Design guidance (skills + `/ddd-audit` command)
- **git-commits**: Conventional commit writing (skill + `/commit` command)
- **token-counter**: Token counting via Anthropic API (skill + `/count-tokens` command)

## Development Setup

```bash
./setup.sh  # Configures git hooks (run once after clone)
```

## Plugin Structure

Each plugin follows this structure:
```
plugins/plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Manifest with name, description, version
├── skills/
│   └── skill-name/
│       └── SKILL.md     # Skill definition
├── commands/
│   └── command.md       # Slash command definitions
├── reference/           # Optional: curated reference material
└── README.md
```

## Automation

### Version Bumping

Versions are automatically bumped on commit based on Conventional Commits:
- `feat`: minor bump
- `fix`, `perf`, `refactor`, `docs`, `style`, `test`, `build`, `ci`, `chore`: patch bump
- `BREAKING CHANGE` or `!` suffix: major bump

The commit-msg hook (`scripts/bump-versions.sh`) handles this locally. GitHub Actions handles CI.

### Marketplace Generation

`.claude-plugin/marketplace.json` is auto-generated from all plugins by `scripts/generate-marketplace.sh`. This runs on every commit via the commit-msg hook.

## Creating a New Plugin

1. Create a new directory in `plugins/`
2. Add `.claude-plugin/plugin.json` with name, description, version
3. Add skills in `skills/skill-name/SKILL.md`
4. Add commands in `commands/command-name.md`
5. Commit—marketplace.json will update automatically
