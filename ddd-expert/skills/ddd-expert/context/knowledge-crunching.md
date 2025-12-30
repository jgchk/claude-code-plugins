# Knowledge Crunching

## The Nature of Knowledge Crunching

Effective domain modelers are **knowledge crunchers**. They take a torrent of information and probe for the relevant trickle. Initial models are usually naive and superficial, based on shallow knowledge.

**Knowledge-rich design** means the behavior of objects expresses domain knowledge, not just database operations. The model becomes a tool for organizing information and making it accessible to analysis.

**Knowledge crunching is not a solo activity.** It involves collaboration between developers and domain experts. Developers bring technical perspective; domain experts bring deep understanding of the business. Neither can do it alone.

---

## The Ingredients of Effective Modeling

1. **Binding model and implementation** — The model and the code are one. Changes to understanding change the code.

2. **Cultivating a language based on the model** — The Ubiquitous Language emerges from and reinforces the model.

3. **Developing a knowledge-rich model** — Objects have behavior that expresses domain rules, not just data.

4. **Distilling the model** — Continuously refine, removing noise and surfacing the essential.

5. **Brainstorming and experimenting** — Try many models. Most will be rejected or refined.

---

## Breakthrough Example: PCB Design Software

In a project to create software for designing printed circuit boards, the initial model merely captured component types and their connections. After extensive knowledge crunching with engineers, a breakthrough came when the team realized that **nets** (groups of electrically connected components) were the true domain concept.

**Before**:
- Components with pins that connect
- Model captured physical structure

**After**:
- Nets that traverse components
- Topology that could be analyzed

The model could now:
- Express rules about signal integrity
- Implement design rule checking
- Simulate behavior

This happened because it captured **how engineers actually thought about the problem**.

---

## Breakthrough Example: Loan Syndication "Share Pie"

A team building loan software struggled with complex share calculations. The model had many special cases and conditional logic. After weeks of struggle, a breakthrough: the concept of **"Share Pie"** — a normalized representation where every participant's share is expressed as a fraction of the whole.

This single insight:
- Eliminated dozens of special cases
- Made calculations straightforward
- Matched how bankers actually thought about shares
- Enabled new features that were previously "impossible"

---

## Recognizing Opportunities for Breakthroughs

**Watch for awkwardness in the model**:
- Complex conditional logic
- Frequent workarounds
- Hard-to-explain code

**Listen to domain experts for missing concepts**:
- Terms they use that aren't in code
- Frustration when describing the system
- "That's not quite right..."

**Notice when the Ubiquitous Language lacks expressiveness**:
- Long explanations for simple concepts
- Mismatches between conversation and code

**Pay attention when developers frequently need workarounds**:
- Same patterns appearing in multiple places
- Copy-paste with variations

---

## Crisis as Opportunity

Breakthroughs often arrive disguised as crises. When the current model becomes obviously inadequate, the team has reached a new level of understanding.

From this elevated viewpoint:
- The old model looks poor
- A better one becomes conceivable
- The team sees connections they missed before

**When breakthrough happens**: Act on it—implement now. Clarity won't last forever. Document why the old model was inferior.

---

## Collaboration Patterns

### Working with Domain Experts

**What they bring**:
- Deep understanding of the business
- Natural domain vocabulary
- Knowledge of edge cases and exceptions
- Intuition about what matters

**What they need from developers**:
- Technical translation of their concepts
- Questions that probe for precision
- Feedback on whether the model captures their meaning

**Effective questions**:
- "Walk me through [process]..."
- "What happens when [edge case]?"
- "What do you call this?"
- "Why is this rule in place?"
- "What could go wrong?"

### Developer's Role

**What developers bring**:
- Ability to formalize concepts
- Pattern recognition across domains
- Understanding of what's implementable
- Visualization through diagrams and code

**What developers must do**:
- **Seriously learn the domain** — Not just patterns, but business fundamentals
- **Resist the urge to jump to solutions** — Understand first
- **Challenge vague terms** — Precision matters
- **Propose models and validate** — Show, get feedback, iterate

---

## Knowledge Crunching Techniques

### Exploration Sessions

**Format**:
- 4-5 people (developers + domain experts)
- 30 minutes to 1.5 hours
- Whiteboard or shared diagram

**Activities**:
- Walk through scenarios
- Draw and redraw diagrams
- Challenge assumptions
- Try alternative phrasings

### Model Spiking

**Purpose**: Quick experiments to test model viability

**Approach**:
1. Identify a specific question about the model
2. Write minimal code to answer it
3. Throw it away or keep it—doesn't matter
4. The insight is what you keep

### Language Games

**Try expressing business rules in different ways**:

"When an order is placed, we check inventory..."
vs.
"A Reservation holds inventory for a pending Order..."

Different phrasings reveal different model structures.

---

## Common Knowledge Crunching Failures

### Analysis Paralysis
- Too much discussion, not enough modeling
- Waiting for complete understanding before acting
- **Fix**: Timebox, experiment in code, accept iteration

### Superficial Models
- First model accepted without challenge
- Database schemas as domain model
- **Fix**: Ask "why" more, look for behavior

### Developer Isolation
- Building without expert involvement
- Assuming you understand the domain
- **Fix**: Regular sessions with experts, validate continuously

### Expert Deference
- Accepting expert terminology without precision
- Not challenging vague concepts
- **Fix**: Push for specifics, implement and show

---

## Signs of Good Knowledge Crunching

**The model explains, not just describes**:
- You can answer "why" questions
- Edge cases make sense
- New scenarios fit naturally

**Experts recognize the model**:
- "Yes, that's exactly how it works"
- They can extend scenarios using the model
- They catch errors in your understanding

**The code expresses the domain**:
- Reading code sounds like domain conversation
- Business rules are explicit
- Changes to rules change specific, obvious code

**Complexity is conquered**:
- What was confusing becomes clear
- Many special cases collapse into general rules
- New features become easier

---

## The Continuous Nature of Knowledge Crunching

Knowledge crunching never ends. As you learn more:
- Hidden concepts surface
- Edge cases reveal new structure
- Business changes require model evolution

**Three things to maintain**:

1. **Live in the domain**
   - Keep looking at things differently
   - Maintain ongoing dialog with domain experts

2. **Keep the design supple**
   - Continuous refactoring
   - Automated test suites
   - Small, frequent integrations

3. **Seek insight**
   - Analysis patterns from other domains
   - Design patterns applied to your domain
   - Deep models that emerge over time
