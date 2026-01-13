---
name: reflect-on
description: Enable automatic reflection at session end
allowed-tools: Read, Write, Edit
---

# Reflect On Command

Enable automatic reflection. When enabled, the reflect skill will automatically analyze conversations for learnings when sessions end.

## Workflow

1. **Check for existing config** at `.claude/reflect.local.md`

2. **Create or update the file** with:
   ```markdown
   ---
   enabled: true
   ---

   # Reflect Configuration

   Auto-reflection is active. Learnings will be proposed at session end.
   ```

3. **Confirm activation** to the user:
   - "Auto-reflection enabled. Learnings will be proposed when sessions end."
   - "Note: Changes still require your approval before being applied."

4. **Remind about restart** if hooks were just added:
   - "If this is your first time enabling, restart Claude Code for hooks to activate."

## Example

```
/reflect on
```
