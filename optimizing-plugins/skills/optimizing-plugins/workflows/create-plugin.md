# Creating a New Plugin

## Step 1: Gather Requirements

Ask the user:
1. What is the plugin's main purpose?
2. What components are needed?
   - Commands (slash commands like `/deploy`)
   - Skills (domain expertise like code review)
   - Agents (parallel workers)
   - Hooks (event triggers)
   - MCP servers (external integrations)
3. What scope? (user `~/.claude/plugins/`, project `.claude/plugins/`, or local)

## Step 2: Generate Structure

Use templates from [../templates/](../templates/) to create:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # ONLY file here - use plugin.json.template
├── commands/            # If needed - use command.md.template
├── skills/              # If needed - use SKILL.md.template
│   └── skill-name/
│       └── SKILL.md
├── agents/              # If needed
├── hooks/               # If needed
│   └── hooks.json
└── README.md            # Use README.md.template
```

## Step 3: Create plugin.json

Minimum required:
```json
{
  "name": "plugin-name",
  "description": "What it does",
  "version": "1.0.0"
}
```

See [../context/plugin-schema.md](../context/plugin-schema.md) for optional fields.

## Step 4: Create Components

For each skill:
1. Create directory: `skills/skill-name/`
2. Create `SKILL.md` with frontmatter (see [../context/skill-schema.md](../context/skill-schema.md))
3. Keep SKILL.md under 500 lines - use reference files for details

For each command:
1. Create `commands/command-name.md`
2. Include frontmatter with `name` and `description`

## Step 5: Validate

Run through the critical rules:
- [ ] `.claude-plugin/` contains ONLY `plugin.json`
- [ ] All component directories at plugin root
- [ ] All paths relative with `./`
- [ ] All names kebab-case
- [ ] Skills have valid frontmatter with "Use when..." in description
