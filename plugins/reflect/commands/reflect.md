---
name: reflect
description: Analyze conversation for learnings and propose skill updates
argument-hint: "[skill-name]"
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Reflect Command

Analyze the current conversation for learnings, corrections, and patterns that should be persisted in skill files.

## Parameters

- `$ARGUMENTS` - Optional skill name to target explicitly. If not provided, auto-detect from conversation context.

## Workflow

1. **Analyze the conversation** for learning signals:
   - Explicit instructions and corrections (high confidence)
   - Implicit corrections where user fixed or adjusted output (medium confidence)
   - Successful patterns that worked well (low confidence)

2. **Determine target skill**:
   - If `$ARGUMENTS` specifies a skill name, locate that skill
   - Otherwise, detect which skill was active in the conversation
   - If unclear, ask user to choose from detected candidates
   - Search in: `~/.claude/skills/`, `.claude/skills/`, and plugin directories

3. **Read the target skill file** to understand its current structure

4. **Generate proposed changes**:
   - Match the skill's existing format and tone
   - Add learnings in appropriate sections
   - Include confidence level for each change

5. **Show diff to user**:
   ```
   Proposed changes to [skill-path]:

   [diff output]

   Confidence: HIGH - explicit user instruction
   ```

6. **Ask for approval** using AskUserQuestion with Yes/No options

7. **If approved**, apply changes using the Edit tool

8. **If multiple skills** could be updated, process one at a time with separate approvals

9. **If no learnings detected**, respond: "No actionable learnings detected in this session."

## Examples

```
/reflect
```
Auto-detect skill from conversation context and propose updates.

```
/reflect git-commit
```
Explicitly target the git-commit skill for updates.

```
/reflect code-review
```
Explicitly target the code-review skill for updates.
