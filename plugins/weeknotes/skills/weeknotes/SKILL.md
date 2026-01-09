---
name: Weeknotes Writer
description: This skill should be used when the user asks to "write weeknotes", "help me write weeknotes", "draft my weeknotes", "what happened this week", "prepare my Friday update", "write my weekly update", "create team weeknotes", or mentions "weeknotes" in the context of team communication. Helps draft regular team communication about work in progress.
---

# Weeknotes Writer

Draft weeknotes - regular team communication about work in progress. Weeknotes give teams a voice and platform for broadcasting progress, challenges, and plans to stakeholders.

## What Weeknotes Are

Weeknotes are:
- A reflection on the week that just ended - nothing more
- Deliberately rough notes, not formal documentation
- Quick to write (30 minutes max) and quick to read
- Usually bullet points with occasional links or images
- A habit that builds value over time through accumulated history

Weeknotes are NOT:
- A diary or chronological log
- Formal documentation requiring polish
- A complete list of every task completed
- Something requiring editorial approval

## Gathering Information

Before drafting, gather context about the week. Use these sources:

### From the User
Ask the user about their week. Key questions:
- "What was the most important thing that happened this week?"
- "What challenges or blockers came up?"
- "What decisions were made?"
- "What's coming next week?"
- "Anything you're proud of or want to highlight?"

### From Available Tools
If integrated tools are available:
- **Jira**: Check completed issues, sprint progress, blockers
- **Git**: Review merged PRs, significant commits
- **Calendar**: Note key meetings or milestones
- **Slack**: Look for significant discussions or decisions

Start with whatever information is available. Missing some sources is fine.

## Drafting Workflow

### Step 1: Identify the Most Important Thing
Start with the single most important thing that happened this week. Lead with this - readers who only skim should catch it.

### Step 2: Build Out 3-10 Bullets
Add supporting points in order of importance (not chronological order):
- Significant progress or completions
- Challenges encountered and how they were handled
- Decisions made and why
- Things learned or discovered
- What's coming next

### Step 3: Keep It Short
Target length: 3-10 bullet points. If writing more than 10, the note is too long. Ruthlessly cut:
- Remove anything that's "nice to know" but not important
- Combine related points
- Delete anything that only the team would understand without context

### Step 4: Add Personality
Weeknotes work best when they feel human:
- Include an honest reflection on how the week felt
- Mention blockers or frustrations (it builds trust)
- A touch of humor is fine if it fits the team's voice
- Acknowledge team members who did great work

### Step 5: Format for the Platform
For Slack, format the weeknote appropriately:
- Use a clear header with date/week number
- Bullet points with emoji for visual scanning
- Keep paragraphs very short
- Include links to relevant resources where helpful

## Output Format for Slack

```
*Week of [Date] - [Team Name] Weeknotes*

:star: *Highlights*
• [Most important thing first]
• [Other significant achievements]

:construction: *Challenges*
• [Blockers or difficulties encountered]

:arrow_forward: *Coming Up*
• [What's planned for next week]

:thought_balloon: *Reflections*
[Optional: A sentence or two on how the week felt, lessons learned, or team morale]
```

Adapt this template as needed - rigid templates get boring. Variety is fine.

## Review Checklist

Before the user publishes, verify:

- [ ] Leads with the most important thing
- [ ] Readable in under 2 minutes
- [ ] Would make sense to someone outside the team
- [ ] Doesn't include sensitive information
- [ ] Honest about challenges (not just good news)
- [ ] Signals what's coming next (radiates intent)

## Writing Style

Follow these principles:
- **Aim low**: Make it a small task, not a burden
- **Bullet points over prose**: Easier to write and read
- **Order of importance, not chronology**: Most important first
- **Be honest**: Include struggles, not just wins
- **Quick and rough**: 30 minutes max, imperfection is fine
- **Write for the reader**: What do they need to know?

## Handling Common Situations

### "Not much happened this week"
- Note that it was a quieter week (that's valuable context)
- Focus on smaller progress or maintenance work
- Reflect on why it was quiet (recovery after a push? blocked? ramping up?)
- It's okay if a weeknote is just 3 bullets

### "Too much happened this week"
- Pick the 3-5 most important things only
- Summarize themes rather than listing everything
- Link to detailed updates if stakeholders need more
- Remember: readers don't have time for everything either

### "I don't want to share bad news"
- Honesty builds trust over time
- Frame challenges constructively (what you learned, what you're doing about it)
- Hiding problems makes weeknotes feel like spin
- Leaders appreciate knowing about blockers early

## Additional Resources

For detailed principles and philosophy behind effective weeknotes, consult:
- **`references/weeknotes-principles.md`** - Key wisdom from Giles Turnbull's weeknotes methodology

## Future Automation

This skill is designed to integrate with:
- **Jira** - Automatically pull completed issues, sprint status, blockers
- **Slack** - Summarize significant channel discussions
- **Git** - List merged PRs and significant changes
- **Calendar** - Note key meetings and milestones

These integrations will be added over time to reduce manual gathering.
