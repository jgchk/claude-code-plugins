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

**When to refactor**:
- Design doesn't express team's current understanding
- Important concepts are implicit
- Opportunity exists to make design suppler

**Timing**: If you wait until you can make a complete justification for a change, you've waited too long. Your project is already incurring costs from the awkward design. Postponed changes will be harder to make later.

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

**Common sources of missing concepts**:
- Language used by domain experts that lacks a model element
- Awkwardness in design that hints at missing concepts
- Constraints that are enforced but not named
- Processes that are described but not modeled

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

Test: Can a client developer use it correctly without reading the implementation?

```
Bad:  processData(data, mode, flags)
Good: transferFunds(from, to, amount)
```

### Side-Effect-Free Functions

Prefer operations returning results without modifying state. Pure functions are easy to reason about, test, combine.

**Benefits**:
- Safe to combine operations in any order
- Easier to test
- Lower cognitive load

**Design implications**:
- Separate commands (state changes) from queries (return values)
- Place complex logic in Value Objects that return new Values
- Use immutability where possible

**Example: Paint Mixing**
```java
// Side-effect-free: returns a NEW Paint
public Paint mixWith(Paint other) {
    double totalVolume = this.volume + other.volume;
    // Calculate new color from proportional mixing
    return new Paint(newColor, totalVolume);
}
```

The original Paint objects are unchanged. Callers can experiment with different mixtures safely.

### Assertions

Make invariants and postconditions explicit. State post-conditions of operations and invariants of classes and Aggregates explicitly.

If assertions cannot be coded directly, write automated unit tests. Document assertions in design documents for developers to follow.

**Example: Aggregate Invariant Assertion**
```java
public class PurchaseOrder {
    /**
     * INVARIANT: sum(lineItem.amount) <= approvedLimit
     * POST: new line item added, invariant preserved
     * THROWS: LimitExceededException if invariant would be violated
     */
    public void addLineItem(Product product, int quantity) {
        Money newTotal = total().add(product.price().times(quantity));
        if (newTotal.exceeds(approvedLimit)) {
            throw new LimitExceededException(newTotal, approvedLimit);
        }
        lineItems.add(new LineItem(product, quantity));
    }
}
```

### Conceptual Contours

Decompose design elements (operations, interfaces, classes, Aggregates) into cohesive units based on intuition of important divisions in the domain.

**Signs of good contours**:
- Changes affect minimal elements
- Concepts compose naturally
- Boundaries feel stable even as the model evolves

**Signs of poor contours (misalignment)**:
- Concepts spread across classes
- Classes combine unrelated concepts
- Features require touching many places
- Simple changes require touching many classes
- Model changes frequently require restructuring

### Standalone Classes

Low coupling is fundamental to design. Eliminate all dependencies except those required by the concept.

**Goal**: A class that can be understood and tested without considering any other class.

Every dependency is a cognitive burden. Implicit dependencies (through globals or hidden state) are worst. Explicit dependencies (through constructor or method parameters) are better but still costly.

### Closure of Operations

Where possible, define operations whose return type is the same as the type of its arguments. Operations returning same type enable fluent composition.

```java
public class Money {
    public Money add(Money other) {
        return new Money(this.amount + other.amount, this.currency);
    }
}

// Enables:
totalPrice = basePrice.add(tax).add(shipping)
deadline = startDate.plusDays(30).endOfBusinessDay()
```

**Benefits**:
- Operations compose naturally
- Set of possible outcomes is limited and predictable
- Self-contained; no need to understand other types

### Declarative Style

Combine Specifications, Assertions, and Side-Effect-Free Functions to express business logic declaratively rather than procedurally.

**Procedural**:
```java
List<Invoice> result = new ArrayList<>();
for (Invoice invoice : invoices) {
    if (invoice.isUnpaid()) {
        int daysPast = daysBetween(invoice.dueDate(), today);
        if (daysPast > gracePeriod) {
            result.add(invoice);
        }
    }
}
```

**Declarative**:
```java
List<Invoice> result = invoices.select(delinquencySpec);
```

---

## Breakthrough Refactoring

Sometimes incremental, sometimes a fundamental insight causes qualitative improvement. The returns from a breakthrough to a deep model can be immense.

**Example: Loan Syndication "Share Pie" Breakthrough**

A team building loan software struggled with complex share calculations. The model had many special cases and conditional logic. After weeks of struggle, a breakthrough: the concept of "Share Pie" — a normalized representation where every participant's share is expressed as a fraction of the whole.

This single insight:
- Eliminated dozens of special cases
- Made calculations straightforward
- Matched how bankers actually thought about shares
- Enabled new features that were previously "impossible"

**Signals**:
- "Oh, that's what it really is!"
- Complex code becomes simple
- Experts say "yes, exactly!"
- Many problems resolve at once

**Precipitating factors**: Constraints forcing simplification. New expert perspective. Reading about similar domains. Living with model until patterns emerge.

**Enabling breakthroughs**: Continuous refactoring keeps code malleable. Conversation with experts. Draw and redraw diagrams. Challenge fundamental assumptions.

**Crisis as Opportunity**: Breakthroughs often arrive disguised as crises. When the current model becomes obviously inadequate, the team has reached a new level of understanding. From this elevated viewpoint, the old model looks poor—but a better one becomes conceivable.

**When it happens**: Act on it—implement now. Clarity won't last forever. Document why old model was inferior.

---

## Applying Analysis Patterns

**Analysis Patterns** = Groups of concepts that represent a common construction in business modeling (from Martin Fowler's book).

**How to use**:
- Don't apply literally; adapt to your specific domain
- Use as vocabulary for knowledge crunching
- Leverage documented trade-offs and consequences
- The pattern name becomes part of the Ubiquitous Language

**Example: Applying Accounting Patterns**

A team building investment software discovered patterns from accounting:
- **Account**: A container for recording transactions
- **Entry**: A record of an amount posted to an account
- **Transaction**: A balanced set of entries (debits = credits)
- **Posting Rules**: Rules that trigger entries in response to events

These patterns provided:
- Established vocabulary
- Proven abstractions
- Guidance on relationships and invariants

The team didn't implement the full accounting model—just the parts relevant to their domain.

---

## Design Patterns Applied to the Domain

Some design patterns from "Design Patterns" (Gang of Four) can be applied as domain patterns:

### Strategy (Policy)

When alternative processes must be provided, factor out the varying part into a Strategy.

**Domain application**:
- Express business rules or policies as Strategy objects
- Different versions represent different ways a process can be done
- Focuses on expressing a domain concept, not just algorithmic flexibility

**Example: Routing Policies**
```java
interface LegMagnitudePolicy {
    double calculateMagnitude(Leg leg);
}

class FastestRoutePolicy implements LegMagnitudePolicy {
    public double calculateMagnitude(Leg leg) {
        return leg.elapsedTime();
    }
}

class CheapestRoutePolicy implements LegMagnitudePolicy {
    public double calculateMagnitude(Leg leg) {
        return leg.cost();
    }
}
```

The Routing Service accepts a policy and finds routes that minimize total magnitude according to that policy.

### Composite

When parts and wholes should be treated uniformly:
- Define an abstract type encompassing both
- "Leaf" nodes implement behavior based on their own values
- Containers implement by aggregating contents
- Clients deal with the abstraction, not specific types

**Example: Shipment Routes**

A shipping route can be:
- A single leg (ship voyage, truck trip)
- A composite of legs (origin to port, port to port, port to destination)
- A composite of composites (regional routes combined into international routes)

```java
abstract class Route {
    abstract List<PortOperation> getPortOperations();
}

class Leg extends Route {
    List<PortOperation> getPortOperations() {
        return Arrays.asList(loadOperation, unloadOperation);
    }
}

class CompositeRoute extends Route {
    private List<Route> segments;

    List<PortOperation> getPortOperations() {
        return segments.stream()
            .flatMap(r -> r.getPortOperations().stream())
            .collect(toList());
    }
}
```

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

---

## Three Things to Focus On

1. **Live in the domain**
   - Keep looking at things differently
   - Maintain ongoing dialog with domain experts

2. **Keep the design supple through:**
   - Continuous refactoring
   - Automated test suites
   - Small, frequent integrations

3. **Seek insight through:**
   - Analysis patterns
   - Design patterns applied to the domain
   - Deep models that emerge over time
