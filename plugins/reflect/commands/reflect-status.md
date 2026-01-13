---
name: reflect-status
description: Check if automatic reflection is enabled
allowed-tools: Read, Glob
---

# Reflect Status Command

Check the current state of automatic reflection.

## Workflow

1. **Check for config file** at `.claude/reflect.local.md`

2. **If file doesn't exist**:
   - Report: "Auto-reflection is not configured."
   - Suggest: "Use `/reflect on` to enable automatic reflection at session end."

3. **If file exists**, read and parse the YAML frontmatter:
   - Extract the `enabled` field
   - Report current status

4. **Display status**:
   - If `enabled: true`: "Auto-reflection is ENABLED. Learnings will be proposed at session end."
   - If `enabled: false`: "Auto-reflection is DISABLED. Use `/reflect` for manual reflection."

## Example

```
/reflect status
```
