# git-commits

A Claude Code plugin for writing high-quality Git commit messages following Conventional Commits.

## Commands

- **`/commit`** - Create a conventional commit with staged changes. Analyzes your staged diff and creates an appropriate commit message. Accepts optional hints (e.g., `/commit fix the auth bug`).

## Skills

- **writing-git-commits** - Writes commit messages with proper structure, types, scopes, and bodies. Automatically detects commitlint configuration and project conventions.

## Installation

```bash
claude plugins:add /path/to/claude-code-plugins/plugins/git-commits
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
