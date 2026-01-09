# Weeknotes Plugin

Draft and write weeknotes - regular team communication about work in progress.

## What Are Weeknotes?

Weeknotes are a format for regular communication about work in progress. They give teams a voice and platform for broadcasting progress, challenges, and plans to stakeholders.

Based on [Giles Turnbull's weeknotes methodology](https://doingweeknotes.com/).

## Skills

### Weeknotes Writer

Helps draft weeknotes by:
- Gathering information about what happened during the week
- Structuring content with most important things first
- Formatting appropriately for your platform (Slack, Confluence, etc.)
- Following best practices for quick, readable updates

**Trigger phrases:**
- "Help me write weeknotes"
- "Draft my weeknotes"
- "What happened this week?"
- "Prepare my Friday update"

## Commands

### `/weeknote`

Draft a weeknote for the current week.

```
/weeknote
/weeknote focus on the API migration
/weeknote it was a quieter week
```

## Usage

```
> Help me write weeknotes for this week

Claude will ask about your week and draft a weeknote following the methodology:
- Lead with the most important thing
- 3-10 bullet points
- Order by importance, not chronology
- Quick to read (under 2 minutes)
- Honest about challenges, not just wins
```

## Roadmap

Future automation integrations:
- **Jira**: Pull completed issues, sprint status, blockers
- **Slack**: Summarize significant channel discussions
- **Git**: List merged PRs and significant changes
- **Calendar**: Note key meetings and milestones

## Philosophy

From the methodology:
- **Aim low**: 30 minutes max, rough is fine
- **Habit over perfection**: Consistency beats polish
- **Radiate intent**: Signal what's coming next
- **Be honest**: Include struggles, not just wins
- **Write for readers**: What do they need to know?
