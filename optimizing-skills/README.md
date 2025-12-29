# Optimizing Skills

A Claude Code plugin that applies Anthropic's best practices for creating and optimizing Claude Code skills.

## Installation

```bash
claude plugins:install /path/to/optimizing-skills
```

## Usage

The skill triggers automatically when:
- Creating a new skill
- Reviewing existing skills
- Using `/optimize-skill` command

Example prompts:
- "Help me create a new skill for code review"
- "Review my PDF processing skill"
- "Optimize the commit skill"

## What It Does

- Evaluates skills against a comprehensive checklist
- Reports issues by severity (critical, high, medium, low)
- Provides concrete fixes for common problems
- Offers to rewrite skills with optimizations applied

## License

MIT
