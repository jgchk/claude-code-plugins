# Model Refinement

## Refactoring Toward Deeper Insight

The most valuable refactorings discover better models, not just cleaner code.

**Levels**:
1. **Technical refactoring** — Rename, extract methods. Important but doesn't change model.
2. **Model refactoring** — Change Aggregate boundaries, extract concepts. Fundamentally different understanding.

Model refactoring is the goal. Technical refactoring enables it.

**Finding Deeper Models**:
- **Listen for friction** — Where is code hard to change? What needs long explanations?
- **Look for implicit concepts** — Buried in procedures, hidden in conditionals, implicit in variable names
- **Question the obvious** — Why Entity not Value Object? Does this boundary make sense?

---

## Making Implicit Concepts Explicit

Hidden domain concepts often lurk in:

**Procedures**:
```
Before: applyDiscount(order, discountPercent, validUntil)
After:  order.apply(DiscountPolicy.percentage(10).validUntil(date))
```
DiscountPolicy was implicit—now first-class.

**Conditional logic**:
```
Before: if (order.status == APPROVED && order.paymentVerified && !order.flaggedForReview)
After:  if (order.isReadyForFulfillment())
```
"Ready for fulfillment" was hidden.

**Method arguments**:
```
Before: calculateRoute(originLat, originLng, destLat, destLng)
After:  calculateRoute(Location origin, Location destination)
```
Location was implicit in primitives.

**Recognizing Missing Concepts**:
- Domain experts use terms not in the code
- Awkward phrasing to avoid a missing term
- "The system should..." (missing subject = missing concept)
- Complex procedures that are hard to explain

---

## Supple Design

Makes it easy to work with the model. Changes natural, intentions clear, side effects predictable.

### Intention-Revealing Interfaces

Names state what, not how. Clients don't need to understand implementation.

```
Bad:  processData(data, mode, flags)
Good: transferFunds(from, to, amount)
```

### Side-Effect-Free Functions

Prefer operations returning results without modifying state. Pure functions are easy to reason about, test, combine.

```
// Query (side-effect-free)
totalPrice = order.calculateTotal()

// Command (clearly mutates)
order.addItem(item)
```

### Assertions

Make invariants and postconditions explicit.

```
class Account:
  invariant: balance >= 0 or hasOverdraftProtection()

  withdraw(amount):
    assert canWithdraw(amount)
    balance -= amount
    assert invariantSatisfied()
```

### Conceptual Contours

Decompose to align with domain concepts. Cuts follow natural seams.

**Misalignment signs**: Concepts spread across classes. Classes combine unrelated concepts. Features require touching many places.

### Standalone Classes

Minimize dependencies. Every dependency adds cognitive load and coupling.

### Closure of Operations

Operations returning same type enable fluent composition.

```
totalPrice = basePrice.add(tax).add(shipping)
deadline = startDate.plusDays(30).endOfBusinessDay()
```

---

## Breakthrough Refactoring

Sometimes incremental, sometimes a fundamental insight causes qualitative improvement.

**Signals**:
- "Oh, that's what it really is!"
- Complex code becomes simple
- Experts say "yes, exactly!"
- Many problems resolve at once

**Precipitating factors**: Constraints forcing simplification. New expert perspective. Reading about similar domains. Living with model until patterns emerge.

**Enabling breakthroughs**: Continuous refactoring keeps code malleable. Conversation with experts. Draw and redraw diagrams. Challenge fundamental assumptions.

**When it happens**: Act on it—implement now. Clarity won't last forever. Document why old model was inferior.

---

## Exploration Teams

When a model problem needs more than casual refactoring, assemble a focused team.

**Format**:
- 4-5 people with relevant skills (developers, domain experts)
- Short sessions: 30 minutes to 1.5 hours
- 2-3 meetings spaced over a few days
- Don't drag it out—if stuck, pick a smaller aspect

**Process**:
1. **Brainstorm freely** — Sketch diagrams, walk through scenarios
2. **Try multiple models** — Don't settle on first idea
3. **Validate with experts** — They must understand and find it useful
4. **Experiment in code** — Small spikes to test viability

**Keys to success**:
- Include domain experts, not just developers
- Keep scope focused—one aspect of the model
- Timebox ruthlessly—breakthrough or pick smaller target
- Document insights even if immediate breakthrough doesn't happen

---

## Preserving Model Integrity

**Continuous Integration** (within Bounded Context): Merge frequently. Run tests constantly. Catch divergence early.

**Ubiquitous Language Discipline**: When terminology changes, code changes. Glossary stays current.

**Context Map Maintenance**: Update when relationships change. Question when integration is painful.

---

## Practical Refinement Process

1. **Identify friction** — Hard-to-change code, confusing concepts, language misalignment

2. **Explore alternatives** — What's missing? Different way to model? How would expert describe it?

3. **Prototype new model** — Small experiment. See if it simplifies.

4. **Refactor if better** — Incrementally move to new model. Update tests and glossary.

5. **Repeat** — Models are never done. Each improvement enables the next.
