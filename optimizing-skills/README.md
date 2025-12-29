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
- Using the `/optimize-skill` command

### Command

```bash
/optimize-skill <path-to-skill>
```

Audits and optimizes the skill at the specified path. The path can point to either a skill directory or directly to a SKILL.md file.

Examples:
```bash
/optimize-skill ~/.claude/skills/my-skill
/optimize-skill ./skills/pdf-processor
/optimize-skill ~/Projects/my-plugin/skills/my-skill/SKILL.md
```

### Natural Language

You can also trigger the skill with prompts like:
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
