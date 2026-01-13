---
name: reflect-off
description: Disable automatic reflection at session end
allowed-tools: Read, Write, Edit
---

# Reflect Off Command

Disable automatic reflection. Sessions will end without triggering the reflect analysis.

## Workflow

1. **Check for existing config** at `.claude/reflect.local.md`

2. **If file exists**, update it:
   ```markdown
   ---
   enabled: false
   ---

   # Reflect Configuration

   Auto-reflection is disabled.
   ```

3. **If file doesn't exist**, create it with `enabled: false`

4. **Confirm deactivation** to the user:
   - "Auto-reflection disabled. Use `/reflect` to manually trigger reflection."

## Example

```
/reflect off
```
