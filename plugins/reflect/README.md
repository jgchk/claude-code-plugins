# Reflect Plugin

Self-improving skills through conversation reflection. Learn from corrections once, never repeat the same mistakes.

## The Problem

LLMs don't learn from your corrections between sessions. Every conversation starts from zero. You correct a mistake today, and tomorrow it happens again. This plugin solves that by extracting learnings from conversations and persisting them in skill files.

## Installation

Add this plugin to your Claude Code configuration.

## Commands

### `/reflect [skill-name]`

Manually trigger reflection on the current conversation. Analyzes for:
- **Explicit corrections** - "don't do X", "always use Y"
- **Implicit corrections** - when you fixed or adjusted Claude's output
- **Successful patterns** - approaches that worked well

If no skill name is provided, auto-detects which skill to update based on conversation context.

### `/reflect on`

Enable automatic reflection. When enabled, reflection triggers automatically at session end via hooks.

### `/reflect off`

Disable automatic reflection. Use `/reflect` for manual reflection only.

### `/reflect status`

Check whether automatic reflection is currently enabled or disabled.

## How It Works

1. **Detection** - Scans conversation for learning signals with confidence levels:
   - HIGH: Explicit instructions ("never do X")
   - MEDIUM: Implicit corrections (user fixed something)
   - LOW: Observations that might be useful

2. **Targeting** - Determines which skill to update:
   - Auto-detects from conversation context
   - Asks if unclear
   - Accepts manual override via argument

3. **Approval** - Shows proposed changes as a diff and asks for confirmation before applying

4. **Persistence** - Edits the skill file to include new learnings

## Configuration

Auto-reflection state is stored in `.claude/reflect.local.md`:

```markdown
---
enabled: true
---

# Reflect Configuration

Auto-reflection is active.
```

Add `.claude/*.local.md` to your `.gitignore` - this is user-local configuration.

## Example Workflow

```
# Have a conversation where you correct Claude
You: "Don't use var, always use const or let"

# Later, trigger reflection
/reflect

# Claude shows:
Proposed changes to ~/.claude/skills/code-review/SKILL.md:

@@ -20,6 +20,7 @@ ## Guidelines
 - Check for proper error handling
+- Never use var; always use const or let for variable declarations

Confidence: HIGH - explicit user instruction

Apply these changes? [Yes] [No]
```

## Tips

- **Version control your skills** - Store `~/.claude/skills/` in a git repo to track how your skills evolve over time
- **Start with manual** - Use `/reflect` manually until you're confident in the mechanism
- **Be explicit** - Clear corrections like "always X" or "never Y" produce better learnings
- **Review regularly** - Periodically review your skill files to prune or refine learnings

## Limitations

- Changes always require approval (by design)
- The reflect skill itself cannot be self-improved (to avoid recursion)
- Hooks require Claude Code restart after enabling
