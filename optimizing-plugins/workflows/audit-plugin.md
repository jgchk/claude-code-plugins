# Auditing an Existing Plugin

## Step 1: Read the Plugin

1. Find and read `.claude-plugin/plugin.json`
2. List all files in the plugin directory
3. Read each `SKILL.md`, command file, and agent file

## Step 2: Check Critical Issues

These cause the plugin to fail:

- [ ] `.claude-plugin/plugin.json` exists and is valid JSON
- [ ] `.claude-plugin/` contains ONLY `plugin.json`
- [ ] `plugin.json` has required `name` field
- [ ] Component directories (`commands/`, `skills/`, `agents/`) are at plugin ROOT
- [ ] Each skill has `SKILL.md` with valid YAML frontmatter
- [ ] Each skill frontmatter has `name` and `description`

## Step 3: Check High Priority Issues

These cause major problems:

- [ ] `name` is kebab-case, max 64 characters
- [ ] `description` exists and explains purpose
- [ ] `version` follows semantic versioning
- [ ] All paths are relative (start with `./`)
- [ ] Skill descriptions include trigger keywords and "Use when..."
- [ ] Skill descriptions under 1024 characters
- [ ] `SKILL.md` bodies under 500 lines
- [ ] No overlapping skill descriptions

## Step 4: Check Medium Priority Issues

- [ ] Large reference material in separate files, not inline
- [ ] Scripts in `scripts/` subdirectory
- [ ] Long files (100+ lines) have table of contents
- [ ] Directory names use kebab-case
- [ ] No hardcoded credentials or secrets

## Step 5: Check Low Priority Issues

- [ ] README.md exists
- [ ] LICENSE file exists
- [ ] Author information in plugin.json
- [ ] Consistent formatting throughout

## Step 6: Report Findings

Use this format:

```markdown
## Plugin Audit: [plugin-name]

### Critical Issues
- [Issue] → [Specific fix]

### High Priority
- [Issue] → [Specific fix]

### Medium Priority
- [Issue] → [Specific fix]

### Low Priority
- [Issue] → [Specific fix]

### Summary
X issues (X critical, X high, X medium, X low)
```

## Step 7: Offer Fixes

After reporting, ask if the user wants you to:
1. Fix all issues automatically
2. Fix only critical/high issues
3. Provide detailed instructions for manual fixes
