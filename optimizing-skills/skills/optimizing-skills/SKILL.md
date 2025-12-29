---
name: optimizing-skills
description: Applies Anthropic's best practices for Claude Code skills. Use when creating new skills, reviewing existing ones, or when "/optimize-skill" is mentioned.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

# Skill Best Practices

Apply best practices when creating or optimizing skills.

## Table of Contents

- [Workflow](#workflow)
- [Architecture: Skills vs Commands vs Agents](#architecture-skills-vs-commands-vs-agents)
- [Evaluation Checklist](#evaluation-checklist)
- [Severity Levels](#severity-levels)
- [Output Format](#output-format)
- [Example Improvements](#example-improvements)
- [When Rewriting](#when-rewriting)

## Workflow

### When Creating a New Skill
1. **Clarify the scope** - What problem does this skill solve? When should it trigger?
2. **Design the structure** - Determine if it needs workflows/ or context/ subdirectories
3. **Apply the checklist below** - Build it right the first time
4. **Validate before saving** - Review against the evaluation criteria

### When Optimizing an Existing Skill
1. **Read the target skill** - Load the SKILL.md and any referenced files
2. **Run the checklist** - Evaluate against each criterion below
3. **Report findings** - Present issues organized by severity
4. **Offer to rewrite** - Provide an optimized version if requested

## Architecture: Skills vs Commands vs Agents

Understand what you're optimizing:

| Type | Purpose | Location |
|------|---------|----------|
| **Skills** | Domain containers organizing related capabilities | `~/.claude/skills/{domain}/` |
| **Commands** | Task-specific workflows nested inside skills | `~/.claude/skills/{domain}/workflows/` |
| **Agents** | Standalone parallel workers | `~/.claude/agents/` |

**Recommended directory structure:**
```
~/.claude/skills/{domain}/
├── SKILL.md              # Routing logic (aim for 5-10KB)
├── workflows/            # Task-specific commands
│   └── {task}.md
└── context/              # Supporting reference files
    └── {reference}.md
```

## Evaluation Checklist

### Metadata (Critical)
- [ ] `name`: lowercase, hyphens only, max 64 chars, gerund form preferred (e.g., `processing-pdfs`)
- [ ] `description`: non-empty, max 1024 chars, third person, includes WHAT it does AND WHEN to use it
- [ ] No reserved words (`anthropic`, `claude`) in name

### Conciseness (Critical)
- [ ] SKILL.md body under 500 lines (~5-10KB for routing logic)
- [ ] **Default assumption**: Claude is already very smart - only add context Claude doesn't have
- [ ] No explanations Claude already knows (what PDFs are, how libraries work, etc.)
- [ ] Each paragraph justifies its token cost
- [ ] Not monolithic (48KB+ files are an anti-pattern)

### Structure (High Priority)
- [ ] References are one level deep from SKILL.md (no nested references)
- [ ] Long reference files (100+ lines) have table of contents
- [ ] Files named descriptively (`form_validation.md` not `doc2.md`)
- [ ] Progressive disclosure: details in `context/` or separate files, not inline
- [ ] Task workflows in `workflows/` subdirectory (if applicable)

### Degrees of Freedom (High Priority)

Match specificity to task fragility:

| Freedom | When to use | Example |
|---------|-------------|---------|
| **High** (heuristics) | Multiple valid approaches, context-dependent | Code review guidelines |
| **Medium** (templates with params) | Preferred pattern exists, some variation ok | Report generation |
| **Low** (exact scripts) | Fragile/critical operations, consistency required | Database migrations |

**Analogy**:
- **Narrow bridge with cliffs**: Only one safe path → exact instructions (low freedom)
- **Open field**: Many paths work → general direction (high freedom)

### Content Quality (Medium Priority)
- [ ] No time-sensitive info (use "old patterns" section if needed)
- [ ] Consistent terminology throughout (don't mix "field"/"box"/"element")
- [ ] Concrete examples, not abstract descriptions
- [ ] Forward slashes in all paths (no Windows backslashes)
- [ ] MCP tools use fully qualified names (`ServerName:tool_name`)
- [ ] Doesn't offer too many options - provide a default with escape hatch

### Workflows (If Applicable)
- [ ] Complex tasks have clear sequential steps
- [ ] Checklists provided for multi-step processes
- [ ] Feedback loops for quality-critical operations (validate → fix → repeat)
- [ ] Conditional workflows guide through decision points

### Scripts (If Applicable)
- [ ] Scripts solve problems rather than punt to Claude
- [ ] Error handling is explicit and helpful
- [ ] No magic constants (all values justified with comments)
- [ ] Required packages listed
- [ ] Clear whether to execute vs read as reference
- [ ] Verifiable intermediate outputs for complex operations

### Testing & Iteration
- [ ] Tested with target models (Haiku needs more guidance, Opus needs less)
- [ ] Evaluations created before extensive documentation
- [ ] Real usage scenarios tested, not just theoretical

## Severity Levels

**Critical**: Skill may fail to trigger or function
- Invalid frontmatter
- Missing/vague description (no "when to use")
- Deeply nested references

**High**: Significant quality/efficiency impact
- Over 500 lines in SKILL.md / monolithic 48KB+ files
- Verbose explanations Claude doesn't need
- Wrong degree of freedom for task type
- Inconsistent terminology

**Medium**: Suboptimal but functional
- Missing table of contents in long files
- Time-sensitive content
- Windows-style paths
- Missing MCP server prefixes

**Low**: Minor improvements
- Non-gerund naming
- Could add more examples
- Missing model-specific testing

## Output Format

```markdown
## Skill Analysis: [skill-name]

### Critical Issues
- Issue description → Specific fix

### High Priority
- Issue description → Specific fix

### Medium Priority
- Issue description → Specific fix

### Low Priority
- Issue description → Specific fix

### Summary
X issues found (X critical, X high, X medium, X low)
```

## Example Improvements

**Verbose description** →
```yaml
# Before
description: This skill helps you process PDF files by extracting text

# After
description: Extracts text and tables from PDFs. Use when working with PDF files or document extraction.
```

**Missing trigger context** →
```yaml
# Before
description: Generates commit messages

# After
description: Generates commit messages by analyzing git diffs. Use when the user asks for help with commits or staged changes.
```

**Over-explained content** →
```markdown
# Before (150 tokens)
PDF files are a common format that contains text and images.
To extract text, you'll need a library. We recommend pdfplumber...

# After (50 tokens)
Use pdfplumber for text extraction:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Too many options** →
```markdown
# Before (confusing)
You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image...

# After (clear default with escape hatch)
Use pdfplumber for text extraction.
For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

**Monolithic structure** →
```markdown
# Before: Everything in one 800-line SKILL.md

# After: Split into focused files
SKILL.md (routing logic, ~100 lines)
├── workflows/
│   ├── extract-text.md
│   └── fill-forms.md
└── context/
    ├── api-reference.md
    └── examples.md
```

## When Rewriting

If asked to optimize/rewrite the skill:

1. Fix all critical and high priority issues
2. Address medium priority where straightforward
3. Preserve the skill's core functionality and intent
4. Split into `workflows/` and `context/` directories if over 300 lines
5. Ensure description includes both WHAT and WHEN
6. Present the rewritten skill for user review before saving
