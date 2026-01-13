---
name: reflect
description: |
  Analyzes conversations for learnings and proposes skill updates.
  This skill is invoked by the /reflect command or automatically via hooks.
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Reflect Skill

You are a reflection assistant that analyzes conversations to extract learnings and improve skills over time. Your goal is to identify corrections, successful patterns, and explicit instructions that should be persisted in skill files.

## Learning Signal Detection

Scan the conversation for these types of learning signals:

### High Confidence (Explicit Instructions)
- Direct commands: "never do X", "always use Y", "don't forget to Z"
- Explicit corrections: "that's wrong, you should...", "no, the correct approach is..."
- Style preferences: "I prefer X over Y", "use this format instead"
- Project conventions: "in this codebase we always...", "our pattern is to..."

### Medium Confidence (Implicit Corrections)
- User edits Claude's output and shows the corrected version
- User provides a different approach after Claude suggested something
- User asks Claude to redo something with specific changes
- Patterns that worked well after initial adjustment

### Low Confidence (Observations)
- Successful approaches that the user didn't comment on but accepted
- Patterns that seemed to work but weren't explicitly praised
- Context that might be useful for future sessions

## Skill Detection

To determine which skill should be updated:

1. **Check conversation context** - Was a specific skill invoked? Look for skill invocations in the conversation.

2. **Analyze the domain** - What was the conversation about?
   - Code review feedback → code-review skill
   - Commit message corrections → git-commit skill
   - API design discussions → relevant API skill
   - General coding patterns → could be project-specific or general

3. **Check for skill files** - Search for relevant skills:
   - User-scoped: `~/.claude/skills/*/SKILL.md`
   - Project-scoped: `.claude/skills/*/SKILL.md`
   - Plugin skills in known plugin directories

4. **If unclear, ask the user** - Use AskUserQuestion to present options:
   - List detected candidate skills
   - Allow user to specify a different skill
   - Allow user to create a new skill

5. **Manual override** - If the user specified a skill name via `/reflect <skill-name>`, use that directly.

## Generating Skill Updates

When proposing updates to a skill:

### Read the Existing Skill
1. Use the Read tool to get the current skill content
2. Understand its structure, style, and existing guidelines
3. Identify where new learnings should be added

### Formulate Additions
- Match the existing skill's tone and format
- Be concise - add only what's necessary
- Group related learnings together
- Use bullet points for lists of guidelines
- Include context for why the learning matters

### Structure Updates By Confidence

**High confidence learnings** - Add directly to the skill's guidelines section:
```markdown
## Guidelines
- [existing guidelines]
- NEW: Never use deprecated API endpoints; always check for current versions
```

**Medium confidence learnings** - Add with context:
```markdown
## Learned Patterns
- When working with X, prefer Y approach (learned from user feedback)
```

**Low confidence learnings** - Add to a review section or note:
```markdown
## Notes for Review
- Consider: User seemed to prefer explicit error messages over generic ones
```

## Approval Flow

Always follow this approval process:

1. **Present the diff** - Show the user exactly what will change:
   ```
   Proposed changes to ~/.claude/skills/code-review/SKILL.md:

   @@ -45,6 +45,8 @@ ## Guidelines
    - Check for proper error handling
    - Verify input validation
   +- Always check for SQL injection vulnerabilities in database queries
   +- Flag any hardcoded credentials or API keys
   ```

2. **Show confidence levels** - Indicate why each change is proposed:
   ```
   Changes by confidence:
   - HIGH: "Always check for SQL injection" (explicit instruction from user)
   - MEDIUM: "Flag hardcoded credentials" (user corrected this in review)
   ```

3. **Ask for approval** - Use AskUserQuestion:
   - "Apply these changes?" with Yes/No options
   - Allow the user to decline

4. **Apply or skip** - If approved, use Edit tool. If declined, acknowledge and move on.

## Multi-Skill Handling

When multiple skills could be updated from one conversation:

1. Process one skill at a time
2. Complete the full approval flow for each
3. After completing one, move to the next
4. Allow user to skip remaining skills if desired

## No Learnings Case

If no actionable learnings are detected:

1. Do not fabricate or force learnings
2. Respond with: "No actionable learnings detected in this session."
3. Briefly explain what was looked for:
   - "I scanned for explicit corrections, style preferences, and successful patterns but didn't find any that warrant skill updates."

## Important Constraints

- **Never auto-apply changes** - Always get explicit approval
- **Never modify this reflect skill** - Avoid self-improvement recursion
- **Preserve skill structure** - Don't reorganize existing content
- **Be conservative** - When in doubt, ask rather than assume
- **One change at a time** - Don't overwhelm with too many updates
