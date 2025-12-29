# git-commits

A Claude Code plugin for writing high-quality Git commit messages following Conventional Commits.

## Skills

- **writing-git-commits** - Writes commit messages with proper structure, types, scopes, and bodies. Automatically detects commitlint configuration and project conventions.

## Installation

```bash
claude plugins:add /path/to/git-commits
```

## Usage

The skill activates when creating commits, reviewing commit messages, or committing changes. It follows:

- Conventional Commits format
- Project-specific commitlint rules (if configured)
- Best practices from community guides

## Reference Material

Includes curated guides on commit message writing from:
- Chris Beams
- Tim Pope
- Linux Kernel guidelines
- Pro Git book
- Conventional Commits specification
