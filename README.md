# Claude Code Plugins

A collection of plugins for [Claude Code](https://claude.ai/code).

## Plugins

### ddd-expert

Domain-Driven Design guidance grounded in Eric Evans' "Blue Book".

**Commands:**
- `/ddd-audit [path]` - Audit domain model for DDD patterns and anti-patterns

**Skills:** Activates when designing domain models, defining bounded contexts, or structuring aggregates.

### git-commits

High-quality Git commit messages following Conventional Commits.

**Commands:**
- `/commit [hint]` - Create a conventional commit with staged changes

**Skills:** Activates when creating commits. Detects commitlint configuration and adapts to project conventions.

### token-counter

Exact token counts using Anthropic's Token Counting API.

**Commands:**
- `/count-tokens <text|file>` - Count tokens for text, files, PDFs, or images

**Skills:** Activates when you ask about token counts.

**Requirements:** `ANTHROPIC_API_KEY` environment variable

## Installation

First, add the marketplace:

```bash
/plugin marketplace add jgchk/claude-code-plugins
```

Then install individual plugins:

```bash
/plugin install ddd-expert@jake-claude-code-plugins
/plugin install git-commits@jake-claude-code-plugins
/plugin install token-counter@jake-claude-code-plugins
```

Or install directly from a local path:

```bash
/plugin install /path/to/claude-code-plugins/plugins/<plugin-name>
```

## Development

```bash
# Clone the repository
git clone https://github.com/your-username/claude-code-plugins.git
cd claude-code-plugins

# Set up git hooks (handles version bumping and marketplace generation)
./setup.sh
```

### Creating a Plugin

1. Create a directory in `plugins/`
2. Add `.claude-plugin/plugin.json`:
   ```json
   {
     "name": "my-plugin",
     "description": "What the plugin does",
     "version": "1.0.0"
   }
   ```
3. Add skills in `skills/<skill-name>/SKILL.md`
4. Add commands in `commands/<command-name>.md`
5. Commit—versions bump automatically based on Conventional Commits

### Version Bumping

Versions are bumped automatically based on commit type:
- `feat:` → minor version
- `fix:`, `refactor:`, `docs:`, etc. → patch version
- `BREAKING CHANGE` or `!` → major version

## License

MIT
