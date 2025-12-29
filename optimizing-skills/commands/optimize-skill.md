---
name: optimize-skill
description: Audits and optimizes a skill at the specified path. Use when you want to review a specific skill for best practices.
---

# Optimize Skill

Audit and optimize an existing Claude Code skill.

## Parameters

- `$ARGUMENTS` - Path to the skill directory (required)

## Workflow

1. **Validate the path**
   - Confirm the directory exists
   - Look for `SKILL.md` in the target directory
   - If not found, check if `$ARGUMENTS` points directly to a SKILL.md file

2. **Load skill files**
   - Read the main `SKILL.md`
   - Identify and read any referenced files in `workflows/` or `context/` subdirectories
   - Note the total file count and approximate size

3. **Run the evaluation checklist**
   Apply the full checklist from the optimizing-skills skill:
   - Metadata validation (name, description, allowed-tools)
   - Conciseness check (line count, token efficiency)
   - Structure review (nesting depth, file organization)
   - Degrees of freedom analysis
   - Content quality assessment
   - Workflow/script review (if applicable)

4. **Report findings**
   Present issues organized by severity:
   - Critical: Skill may fail to trigger or function
   - High: Significant quality/efficiency impact
   - Medium: Suboptimal but functional
   - Low: Minor improvements

5. **Offer to rewrite**
   Ask if the user wants an optimized version. If yes:
   - Fix all critical and high priority issues
   - Address medium priority where straightforward
   - Split into subdirectories if over 300 lines
   - Present the rewritten skill for review before saving

## Examples

```
/optimize-skill ~/.claude/skills/my-skill
```

Audits the skill at the specified path.

```
/optimize-skill ./skills/pdf-processor
```

Audits a skill using a relative path.

```
/optimize-skill ~/Projects/my-plugin/skills/my-skill/SKILL.md
```

Audits a skill by pointing directly to its SKILL.md file.
