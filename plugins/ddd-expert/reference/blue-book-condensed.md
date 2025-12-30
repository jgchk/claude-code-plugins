# Domain-Driven Design: Condensed Reference

*Based on "Domain-Driven Design: Tackling Complexity in the Heart of Software" by Eric Evans*

---

## Part I: Putting the Domain Model to Work

### Chapter 1: Crunching Knowledge

Effective domain modelers are **knowledge crunchers**. They take a torrent of information and probe for the relevant trickle. Initial models are usually naive and superficial, based on shallow knowledge.

**Knowledge-rich design** means the behavior of objects expresses domain knowledge, not just database operations. The model becomes a tool for organizing information and making it accessible to analysis.

#### Example: PCB Design Software

In a project to create software for designing printed circuit boards, the initial model merely captured component types and their connections. After extensive knowledge crunching with engineers, a breakthrough came when the team realized that *nets* (groups of electrically connected components) were the true domain concept. This transformed the design:

- Before: Components with pins that connect
- After: Nets that traverse components, with topology that could be analyzed

The model could now express rules about signal integrity, implement design rule checking, and simulate behavior - because it captured how engineers actually thought about the problem.

**Key Practices:**
- Bind the model and implementation together from the start
- Cultivate a language based on the model
- Develop a knowledge-rich model with behavior, not just data
- Distill knowledge through continuous learning with domain experts

**The ingredients of effective modeling:**
1. Binding model and implementation
2. Cultivating a language based on the model
3. Developing a knowledge-rich model
4. Distilling the model
5. Brainstorming and experimenting

**Knowledge crunching is not a solo activity.** It involves collaboration between developers and domain experts. Developers bring technical perspective; domain experts bring deep understanding of the business. Neither can do it alone.

### Chapter 2: Communication and the Use of Language

#### Ubiquitous Language

A project needs a **common language** that is rigorous enough for technical development. Domain experts have limited jargon; developers have language for discussing technical patterns. The overhead of translation between these languages causes information loss.

**UBIQUITOUS LANGUAGE** = A language structured around the domain model, used by all team members to connect all activities with the software.

**Key principles:**
- Use the model as the backbone of the language
- Team members should use the language consistently in speech, diagrams, writing, and code
- Changes to the language are changes to the model
- Iron out difficulties by experimenting with alternative expressions
- Recognize that a change in the language is a change in the model

**The language includes:**
- Names of classes and prominent operations
- Terms to discuss rules made explicit in the model
- Names of high-level organizing principles (like those in large-scale structure)
- Names of patterns applied to the domain model

**Conversation Example (Before Ubiquitous Language):**
> Developer: "When the routing service receives a route request with the origin and destination codes, it queries the repository for all matching legs, filters based on hazmat codes, and builds an itinerary object."
> Expert: "What's a leg? And what's an itinerary? We talk about voyages and routes..."

**Conversation Example (With Ubiquitous Language):**
> Developer: "The Routing Service finds a Route for a Cargo by finding Legs that connect the origin to the destination, ensuring any required customs clearance."
> Expert: "And it needs to respect the Customer's transit time requirements?"
> Developer: "Yes, the Route Specification constrains which Itineraries are acceptable."

**Documents and Diagrams:**
- Diagrams are a means of communication, not the model itself
- The model is not the diagram; the diagram represents aspects of the model
- UML should be used to communicate, not as a complete specification
- Code is the ultimate model expression; written documents and diagrams should complement it

**Written design documents should:**
- Complement code and conversation
- Serve as a narrative explanation of the model
- Give meaning to the model
- Be kept to a manageable size
- Focus on core concepts while pointing to code for details

### Chapter 3: Binding Model and Implementation

#### Model-Driven Design

**MODEL-DRIVEN DESIGN** = Tightly relating the model to the implementation. Every element of the design either reflects the model directly or supports elements that do.

**Key elements:**
- Software must faithfully mirror domain concepts
- Model changes ripple through implementation; implementation insights feed back to the model
- A single model serves both analysis and design

**Why Models Must Support Implementation:**
- An analysis model may capture domain knowledge but not translate to software
- Analysis and design models that diverge become harmful
- The same model must work for both understanding and building

If the managers of a project perceive analysis to be a separate process, the project will not benefit from deep modeling. If developers don't realize that changing code changes the model, their refactoring will weaken the model rather than strengthen it.

**Letting the Implementation Reflect the Model:**
- Object-oriented programming provides a natural way to implement models
- Classes can represent model concepts; associations map to object references
- Behavior in the model becomes behavior in code

**The Modeling Paradigm:**
- Model-Driven Design requires an implementation paradigm (like OO) that directly supports modeling
- Procedural languages don't naturally express domain models
- The choice of paradigm shapes what models are practical

**Hands-On Modelers:**
- Anyone responsible for changing code must learn to express a model through code
- Every developer must be involved in some level of discussion about the model
- Those who contribute code must also contribute to the model through the Ubiquitous Language

---

## Part II: The Building Blocks of Model-Driven Design

### Layered Architecture

Isolate domain logic from user interface, application, and infrastructure concerns:

| Layer | Responsibility |
|-------|----------------|
| **User Interface** | Display information, interpret user input |
| **Application** | Coordinates tasks, delegates to domain objects, no business rules |
| **Domain** | Business concepts, rules, and logic - the heart of the software |
| **Infrastructure** | Technical capabilities: persistence, messaging, etc. |

**The domain layer is where the model lives.** Objects in other layers should not express domain logic.

**Relating Layers:**

| Layer Connection | Pattern |
|-----------------|---------|
| UI to Application | Thin controllers, DTOs |
| Application to Domain | Direct calls to domain objects |
| Domain to Infrastructure | Dependency inversion (domain defines interfaces) |

### Chapter 4: Isolating the Domain

**Smart UI Anti-Pattern**: Embedding business logic in the user interface leads to:
- Duplication of behavior and rules
- No reuse of business logic
- Lack of abstraction limits functionality

**Advantages of Smart UI (for simple projects):**
- High productivity for simple applications
- Less skilled developers can succeed
- Requirements changes can be accommodated quickly

**When to use Smart UI:** Only for simple projects where no integration or iterative enhancement is anticipated.

**Isolating domain logic is the prerequisite for domain-driven design.** If you mix domain logic with infrastructure or presentation concerns, model-driven design becomes impractical.

### Chapter 5: A Model Expressed in Software

#### Associations

Associations in a model correspond to object interactions in code. Three ways to make associations more tractable:

1. **Impose a traversal direction** - Many bidirectional associations are really unidirectional in practice
2. **Add a qualifier** - Reduce multiplicity by specifying the context
3. **Eliminate nonessential associations** - Keep only those fundamental to the domain concept

**Example: Country-President Association**

Instead of bidirectional:
```
Country <---> President
```

Make it unidirectional with a qualifier:
```
Country.getPresident(period) --> President
```

This reflects the domain reality: we look up which president a country had during a given period.

#### Entities (Reference Objects)

**ENTITY** = An object defined primarily by its identity, rather than its attributes.

**Key characteristics:**
- Has continuity through a lifecycle
- Distinguished by identity, not attributes
- Attributes may change, but identity remains
- Must have an operation to produce unique, stable identity

**Identity implementation options:**
- User-assigned IDs (like Social Security numbers)
- System-generated IDs (GUIDs, database sequences)
- Attributes that are unique in context

**Modeling Entities:**
- Strip the Entity's definition down to the most intrinsic characteristics
- Add only behavior essential to the concept and attributes required by that behavior
- Look beyond the specific software to the domain to find the real identity basis

**Example: Person as Entity**

A person's identity doesn't depend on their name (which can change), their address (which can change), or even their social security number (which can be reassigned in rare cases). A Person Entity is defined by the real-world individual it represents - we track "the same person" even as all their attributes change over time.

#### Value Objects

**VALUE OBJECT** = An object that describes some characteristic or attribute, with no conceptual identity.

**Key characteristics:**
- You care about *what* they are, not *which* one
- Immutable (in most cases)
- Can be shared freely
- Defined by their attributes
- Interchangeable when attributes match

**When to use Value Objects:**
- When you only care about the attributes of a model element
- When objects don't have identity within the domain
- When treating the element as a Value Object simplifies design

**Example: Address as Value Object**

For a mail-order company, addresses are Value Objects. It doesn't matter *which* address object - only whether it has the right street, city, and postal code. Two address objects with identical attributes are interchangeable.

But for a postal service or an electric utility, addresses might be Entities - they track specific physical locations over time, regardless of how the description changes.

**Design implications:**
- Make Value Objects immutable when possible
- Don't give Value Objects identity
- Consider making Value Objects flyweights when there are many instances
- Value Objects can reference Entities (e.g., a Route references Location Entities)

**Sharing and Copying:**

Value Objects can be freely shared because they're immutable:
- Share when there will be many instances with the same values
- Share when object creation is expensive
- Share when identity is not meaningful (immutability is key)

Copy when:
- There are few expected duplicates
- Communication overhead of sharing outweighs benefits

#### Services

**SERVICE** = An operation offered as an interface that stands alone in the model, with no encapsulated state.

**Characteristics of a good Service:**
- Operation relates to a domain concept not a natural part of an Entity or Value Object
- Interface defined in terms of other model elements
- Operation is stateless

**Application vs. Domain Services:**
- **Domain Services**: Express domain logic (e.g., transfer funds between accounts)
- **Application Services**: Coordinate tasks, transform data for presentation, have no domain logic
- **Infrastructure Services**: Technical concerns like sending email, persisting objects

**Example: Fund Transfer Service**

Transferring money from one account to another doesn't naturally belong to either account. Making it a method on Account (`account.transferTo(otherAccount, amount)`) distorts the model - the operation is fundamentally about *both* accounts.

A Fund Transfer Service expresses this more clearly:
```java
interface FundsTransferService {
    void transfer(Account source, Account dest, Money amount);
}
```

**Granularity:**
- Medium-grained, stateless Services can be easier to reuse
- Can control transactions and security at the Service level
- But beware: too many Services can lead to anemic domain models

**Avoiding the "Anemic Domain Model":**

Services should not steal behavior that properly belongs in Entities or Value Objects. The domain model becomes anemic when Services contain all the behavior while Entities are mere data holders.

**Rule of thumb:** If the operation is naturally part of an Entity's responsibilities, it belongs in the Entity. Services are for cross-cutting operations.

#### Modules (Packages)

**MODULE** = A named container of related domain concepts that forms a cohesive part of the model.

**Design principles:**
- Low coupling between Modules
- High cohesion within Modules
- Modules should tell the story of the system
- Module names become part of the Ubiquitous Language

**Common mistakes:**
- Organizing by technical type (all Services together, all Entities together)
- Creating Modules that cut across domain concepts
- Ignoring Modules entirely
- Using infrastructure-layer patterns like MVC to organize domain objects

**Modules are a communication mechanism.** A well-named Module tells developers immediately what concepts are grouped together and why. Poor Module names obscure the design.

**Example: Shipping Application Modules**

Instead of:
```
entities/
services/
repositories/
valueobjects/
```

Use domain-driven packaging:
```
cargo/
  Cargo, DeliverySpecification, Itinerary
routing/
  Route, RoutingService
customer/
  Customer, CustomerRepository
```

### Chapter 6: The Life Cycle of a Domain Object

#### Aggregates

**AGGREGATE** = A cluster of associated objects treated as a unit for data changes.

**Key elements:**
- **Root Entity**: The single Entity through which external objects reference the Aggregate
- **Boundary**: Defines what's inside the Aggregate
- Objects within can reference each other freely
- External objects can only reference the root

**Rules:**
1. Root has global identity; internal entities have local identity only
2. Nothing outside can hold a reference to anything inside except the root
3. Only the root can be obtained directly from database queries
4. Objects inside can hold references to other Aggregate roots
5. Delete operation must remove everything within the boundary at once
6. Invariants involving Aggregate members are enforced with each transaction

**Finding Aggregates:**
- Look for clusters of objects that change together
- Identify invariants that span multiple objects
- Find natural transactional boundaries

**Example: Purchase Order Aggregate**

```
PurchaseOrder (Root)
├── LineItem (local entity)
├── LineItem
└── LineItem

Invariants:
- Total of line items must not exceed credit limit
- Each line item has quantity > 0
```

The PurchaseOrder is the root. LineItems cannot be accessed except through their PurchaseOrder. When enforcing the total-not-exceeding-limit invariant, the PurchaseOrder has complete control because no external code can modify LineItems directly.

**Aggregate Design Considerations:**

Small Aggregates:
- Easier to maintain consistency
- Better for concurrent access (smaller lock scope)
- Simpler to understand

Large Aggregates:
- Can protect more complex invariants
- Fewer inter-Aggregate references to manage
- But: harder to maintain, concurrent access issues

**Default to smaller Aggregates** and combine only when invariants truly require it.

#### Factories

**FACTORY** = An operation or object that encapsulates the knowledge needed to create complex objects or Aggregates.

**When to use:**
- Creating an Aggregate requires knowledge of internal structure
- Creation requires specific expertise not belonging to created objects
- Complex object assembly

**Factory types:**
- Factory Method on Aggregate root
- Standalone Factory class
- Factory Method on another object (reconstitution from storage)

**Key principles:**
- Each creation method is atomic
- Factory enforces invariants of created objects
- Factory should create objects in valid state
- Factory abstracts the concrete class being created

**Example: Cargo Factory**

Creating a Cargo involves setting up a DeliverySpecification, possibly an initial Route, and internal state:

```java
public class Cargo {
    // Factory method on the Cargo itself
    public static Cargo newCargo(TrackingId id, RouteSpecification routeSpec) {
        Cargo cargo = new Cargo(id);
        cargo.routeSpecification = routeSpec;
        cargo.deliveryHistory = new DeliveryHistory(cargo);
        // ... ensure all invariants
        return cargo;
    }
}
```

**Reconstitution:**

When retrieving objects from storage, a Factory can be used to rebuild them. The reconstitution Factory:
- Does NOT assign new IDs (uses stored IDs)
- Does NOT enforce invariants that might have changed (historical data)
- DOES reassemble the object structure

#### Repositories

**REPOSITORY** = A mechanism for encapsulating storage, retrieval, and search behavior for a collection of objects.

**Key characteristics:**
- Provides illusion of an in-memory collection
- Supports queries by various criteria
- Only for Aggregate roots (enforces the Aggregate's boundaries)
- Encapsulates actual storage mechanism

**Interface design:**
- Query methods return fully instantiated objects (or collections)
- Provide methods for common queries clients need
- Client code remains ignorant of database technology

**Example: Cargo Repository**

```java
public interface CargoRepository {
    Cargo find(TrackingId id);
    List<Cargo> findByCustomer(CustomerId customer);
    List<Cargo> findByRoute(RouteSpecification spec);
    void save(Cargo cargo);
}
```

**Implementation considerations:**
- Abstract the type (use interface or abstract class)
- Take advantage of the decoupling from infrastructure
- Separate query method code from traversal code
- Consider Specifications for complex queries

**Relationship with Factories:**
- Factory creates new objects; Repository finds existing ones
- Repository may delegate to Factory for reconstitution
- Keep them separate conceptually

**Using Specifications with Repositories:**

For complex queries, combine the Specification pattern with Repository:

```java
List<Invoice> overdueInvoices =
    invoiceRepository.findSatisfying(
        new InvoiceIsOverdueSpecification(currentDate));
```

This keeps query logic in the domain layer (the Specification) while the Repository handles the actual retrieval mechanism.

---

## Part III: Refactoring Toward Deeper Insight

### Chapter 8: Breakthrough

Refactoring toward deeper insight is fundamental. The returns from a breakthrough to a deep model can be immense:
- Dramatic increase in velocity
- Better alignment with domain expert thinking
- Simpler, more supple design

**Example: Loan Syndication Breakthrough**

A team building loan software struggled with complex share calculations. The model had many special cases and conditional logic. After weeks of struggle, a breakthrough: the concept of "Share Pie" - a normalized representation where every participant's share is expressed as a fraction of the whole.

This single insight:
- Eliminated dozens of special cases
- Made calculations straightforward
- Matched how bankers actually thought about shares
- Enabled new features that were previously "impossible"

**Recognizing opportunity:**
- Watch for awkwardness in the model
- Listen to domain experts for missing concepts
- Notice when the Ubiquitous Language lacks expressiveness
- Pay attention when developers frequently need workarounds

**Crisis as Opportunity:**

Breakthroughs often arrive disguised as crises. When the current model becomes obviously inadequate, the team has reached a new level of understanding. From this elevated viewpoint, the old model looks poor - but a better one becomes conceivable.

### Chapter 9: Making Implicit Concepts Explicit

Look for concepts that are implicit in the model but not explicitly represented:

**Common sources:**
- Language used by domain experts that lacks a model element
- Awkwardness in design that hints at missing concepts
- Constraints that are enforced but not named
- Processes that are described but not modeled

**Useful patterns to make concepts explicit:**

#### Specification

**SPECIFICATION** = A predicate that determines if an object satisfies some criteria.

```java
public interface Specification<T> {
    boolean isSatisfiedBy(T candidate);
}
```

**Uses:**
- Validation: Does this object meet criteria?
- Selection: Which objects from a collection satisfy criteria?
- Building to order: Create something that satisfies criteria

**Benefits:**
- Separates rule from the object being evaluated
- Rules become explicit in the model
- Can combine specifications (and, or, not)

**Example: Invoice Delinquency Specification**

```java
public class InvoiceDelinquencySpecification implements Specification<Invoice> {
    private Date currentDate;
    private int gracePeriodDays;

    public boolean isSatisfiedBy(Invoice invoice) {
        int daysPastDue = calculateDaysBetween(invoice.dueDate(), currentDate);
        return invoice.isUnpaid() && daysPastDue > gracePeriodDays;
    }
}
```

**Combining Specifications:**

```java
Specification<Customer> goldCustomer =
    new CustomerHasMinimumPurchases(10000)
        .and(new CustomerAccountInGoodStanding())
        .and(new CustomerRegisteredBefore(cutoffDate));
```

#### Constraints

Make constraints explicit as objects or named methods rather than implicit in procedural code.

**Before:**
```java
if (container.getCapacity() < cargo.getSize()) {
    throw new Exception("Container too small");
}
```

**After:**
```java
if (!container.canAccommodate(cargo)) {
    throw new CapacityExceededException(container, cargo);
}
```

#### Processes as Domain Objects

If a process is important to the domain, consider making it a first-class model element (often as a Service).

**Example: Overbooking Policy**

In cargo shipping, overbooking is a deliberate strategy - accepting more bookings than capacity, betting that some will cancel. This isn't just a "feature" - it's a domain concept:

```java
public class OverbookingPolicy {
    public boolean isAllowed(Cargo cargo, Voyage voyage) {
        return voyage.bookedCapacity() + cargo.size()
               <= voyage.capacity() * overbookingLimit;
    }
}
```

### Chapter 10: Supple Design

Supple design makes the model easier to understand and change. Key patterns:

#### Intention-Revealing Interfaces

Name classes and operations to describe their effect and purpose, not their implementation.

- Method names should state **what** is done, not **how**
- Test: Can a client developer use it correctly without reading the implementation?

**Before:**
```java
public void process(List<Paint> paints) {
    // mixes paints using volumetric algorithm
}
```

**After:**
```java
public Paint mixPaintsBy Volume(List<Paint> paints) {
    // Implementation details hidden
}
```

#### Side-Effect-Free Functions

**SIDE-EFFECT-FREE FUNCTION** = An operation that returns a result without modifying observable state.

**Benefits:**
- Safe to combine operations in any order
- Easier to test
- Lower cognitive load

**Design implications:**
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

#### Assertions

State post-conditions of operations and invariants of classes and Aggregates explicitly.

- If assertions cannot be coded directly, write automated unit tests
- Document assertions in design documents for developers to follow

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

#### Conceptual Contours

Decompose design elements (operations, interfaces, classes, Aggregates) into cohesive units based on intuition of important divisions in the domain.

**Signs of good contours:**
- Changes affect minimal elements
- Concepts compose naturally
- Boundaries feel stable even as the model evolves

**Signs of poor contours:**
- Simple changes require touching many classes
- Concepts split awkwardly across boundaries
- Model changes frequently require restructuring

#### Standalone Classes

Low coupling is fundamental to design. Eliminate all dependencies except those required by the concept.

**Goal:** A class that can be understood and tested without considering any other class.

Every dependency is a cognitive burden. Implicit dependencies (through globals or hidden state) are worst. Explicit dependencies (through constructor or method parameters) are better but still costly.

#### Closure of Operations

Where possible, define operations whose return type is the same as the type of its arguments.

Example: Adding two Money objects returns a Money object.

```java
public class Money {
    public Money add(Money other) {
        return new Money(this.amount + other.amount, this.currency);
    }
}
```

**Benefits:**
- Operations compose naturally
- Set of possible outcomes is limited and predictable
- Self-contained; no need to understand other types

#### Declarative Style

Combine Specifications, Assertions, and Side-Effect-Free Functions to express business logic declaratively rather than procedurally.

**Procedural:**
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

**Declarative:**
```java
List<Invoice> result = invoices.select(delinquencySpec);
```

### Chapter 11: Applying Analysis Patterns

**ANALYSIS PATTERNS** = Groups of concepts that represent a common construction in business modeling (from Fowler's book).

**How to use:**
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

The team didn't implement the full accounting model - just the parts relevant to their domain.

### Chapter 12: Relating Design Patterns to the Model

Some design patterns from "Design Patterns" (Gang of Four) can be applied as domain patterns:

#### Strategy (Policy)

When alternative processes must be provided, factor out the varying part into a Strategy.

**Domain application:**
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

#### Composite

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

## Part IV: Strategic Design

### Chapter 13: Refactoring Toward Deeper Insight (Summary)

Three things to focus on:

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

**When to refactor:**
- Design doesn't express team's current understanding
- Important concepts are implicit
- Opportunity exists to make design suppler

**Timing:**
- If you wait until you can make a complete justification for a change, you've waited too long
- Your project is already incurring costs from the awkward design
- Postponed changes will be harder to make later

### Chapter 14: Maintaining Model Integrity

#### Bounded Context

**BOUNDED CONTEXT** = The delimited applicability of a particular model.

**Key principles:**
- Multiple models coexist on large projects
- Explicitly define the context within which a model applies
- Keep the model strictly consistent within these bounds
- Set boundaries in terms of team organization, code bases, and database schemas

**Why boundaries matter:**
- Different teams develop different interpretations
- Terms mean different things in different contexts
- Unrecognized divergence leads to model corruption

**Example: The "Charge" Debacle**

Two teams on one project:
- Team A: Customer invoicing - "Charge" means amount billed to customer
- Team B: Vendor payment - "Charge" means expense posted to accounts

They tried to share a "Charge" class. Chaos ensued:
- Mystery records appeared in the database
- Reports crashed
- Each team's assumptions about Charge behavior contradicted the other's

Solution: Explicit Bounded Contexts with separate CustomerCharge and SupplierCharge classes.

**Recognizing splinters:**
- **Duplicate concepts**: Same concept represented differently
- **False cognates**: Same term used for different concepts (like "embarazada" in Spanish doesn't mean "embarrassed")

**Bounded Context is NOT the same as Module:**
- Modules organize within ONE model
- Bounded Contexts separate DIFFERENT models
- A Bounded Context might contain many Modules

#### Continuous Integration

Within a Bounded Context, apply processes to keep the model unified:

- Frequent merging of all code
- Automated test suites
- Relentless exercise of the Ubiquitous Language
- Build/test cycles that flag model fragmentation

**Two levels of integration:**
1. **Model concepts**: Through constant communication and exercising the language
2. **Implementation artifacts**: Through merge/build/test processes

**Without Continuous Integration**, even a small team will diverge. Developers make different assumptions, use terms inconsistently, and duplicate behavior because they're unaware of existing implementations.

#### Context Map

**CONTEXT MAP** = A document (diagram or text) that identifies each model in play and its Bounded Context, with points of contact between them.

**Purpose:**
- Give a global view of the project's contexts
- Describe relationships between contexts
- Highlight translation requirements

**Creating a Context Map:**
- Identify each Bounded Context
- Name each context (names enter Ubiquitous Language)
- Describe points of contact
- Map existing terrain before changing it

**Example Context Map:**

```
[Booking Context] <---> [Transport Network Context]
         |                        |
         |                        |
   (translation)            (translation)
         |                        |
         v                        v
    [Legacy Cargo Tracking] [Voyage Schedule]
```

**The Context Map reflects reality, not aspirations.** Map what IS, not what you wish it were. Then you can plan changes.

### Patterns for Context Relationships

#### Shared Kernel

Two teams agree to share a subset of the domain model, keeping it tightly coordinated.

**Characteristics:**
- Small, explicitly identified shared part
- Special status requiring coordination for changes
- Both teams build off this kernel
- Continuous integration of the kernel code

**Use when:**
- Teams work closely together
- Integration benefits outweigh coordination cost
- Shared concepts are truly the same in both contexts

**Risks:**
- Shared Kernel tends to grow
- Coordination overhead increases
- One team's needs may constrain the other

#### Customer/Supplier Development Teams

One context feeds another; the supplier (upstream) provides what the customer (downstream) needs.

**Key elements:**
- Upstream prioritizes downstream needs in planning
- Downstream participates in acceptance tests
- Clear protocols for managing interface changes

**Example:**

Booking Context (customer) needs routing information from Transport Network Context (supplier). The Transport Network team:
- Includes Booking team's needs in sprint planning
- Gets acceptance tests from Booking team
- Notifies Booking team before interface changes

#### Conformist

When the upstream team has no motivation to support the downstream team's needs, the downstream team conforms to the upstream model.

**Trade-offs:**
- Eliminates translation complexity
- Constrains downstream design
- Use when integration is essential but influence is impossible

**When to conform:**
- Upstream model is actually good enough
- Interface is large (translation would be huge)
- Downstream can extend without modifying

**When NOT to conform:**
- Upstream model is poor or incompatible with your needs
- You need to innovate beyond what upstream provides

#### Anticorruption Layer

**ANTICORRUPTION LAYER** = An isolating layer that provides a translation between two contexts, keeping the corruption of one model from affecting the other.

**Components:**
- **Facade**: Simplified interface to the other system
- **Adapter**: Translates between protocols
- **Translator**: Converts between model concepts

**When to use:**
- When integration with a legacy or external system is required
- When the other model is unacceptable for your domain
- When you need to protect your model from foreign concepts

**Example: Integrating with Legacy System**

```java
// Anticorruption Layer for legacy cargo tracking
public class LegacyCargoTrackingTranslator {
    private LegacySystem legacy;

    public Cargo findCargo(TrackingId id) {
        LegacyShipmentRecord record = legacy.getShipment(id.toString());
        return translateToCargo(record);
    }

    private Cargo translateToCargo(LegacyShipmentRecord record) {
        // Translate legacy concepts to our model
        // Handle inconsistencies and missing data
        // Map legacy status codes to our domain events
    }
}
```

#### Separate Ways

Integration has costs. Sometimes it's best to have no integration at all.

**Consider when:**
- Integration provides limited benefit
- Integration complexity exceeds value
- Contexts have incompatible models

**The declaration that two contexts are going Separate Ways doesn't mean you're giving up.** It means recognizing that forced integration would cost more than independent development.

#### Open Host Service

**OPEN HOST SERVICE** = A well-documented protocol that gives access to your subsystem as a set of services.

**Characteristics:**
- Open protocol shared by multiple integrating systems
- Enhanced as needed for all users collectively
- One-off translators for special needs

**Use when:**
- Multiple systems need to integrate with your context
- Ad-hoc translators for each would be unwieldy
- A stable protocol can serve most needs

#### Published Language

**PUBLISHED LANGUAGE** = A well-documented shared language that can express domain information.

**Examples:**
- Industry standard schemas (SWIFT for financial transactions, ACORD for insurance)
- Shared XML schemas
- Documented APIs with semantic specifications

**Benefits:**
- Neutral ground for translation
- Established semantics reduce ambiguity
- Documentation helps new integrators

### Chapter 15: Distillation

Distillation separates components to extract the essence.

#### Core Domain

**CORE DOMAIN** = The distinctive, central part of the domain model that provides the most business value.

**Actions:**
- Boil the model down to its core
- Apply top talent to the Core Domain
- Invest in finding deep models for the Core
- Justify other investments by how they support the Core

**Identifying the Core:**
- What distinguishes this system from others?
- What would be hardest to outsource?
- What requires the deepest domain knowledge?

**The harsh reality:** Not all parts of the design will be equally refined. Scarce, skilled developers often gravitate toward technical infrastructure or generic problems. The specialized Core often ends up with less skilled developers.

**Fight this tendency.** The Core Domain is where the most value should be added. Apply your best talent there.

#### Generic Subdomains

**GENERIC SUBDOMAIN** = A cohesive subdomain that is not the motivation for your project but supports the Core.

**Characteristics:**
- Abstracts concepts needed by many businesses
- Not what makes your application special
- Can often use off-the-shelf or published models

**Options for implementation:**

| Option | Advantages | Disadvantages |
|--------|-----------|---------------|
| **Off-the-shelf** | Less code, external maintenance | May not fit, integration overhead |
| **Published model** | Mature, documented | May need adaptation |
| **Outsourced** | Frees core team | Communication overhead |
| **In-house** | Exact fit | Ongoing maintenance |

**Key principle:** Don't let generic subdomains absorb your best talent.

**Example: Time Zones**

Two projects needed time zone handling:

Project A (Shipping):
- Clear need for conversion (international scheduling)
- Assigned contractor (temporary, doesn't need domain knowledge)
- Based on existing BSD Unix implementation
- Result: Functional time zone support

Project B (Insurance):
- Vague need (event timestamps)
- Assigned junior developer... who pulled in senior developer
- Tried to build general solution a priori
- Result: Complex, unused code; Core Domain neglected

Project A treated time zones as a Generic Subdomain. Project B let it distract from the Core.

#### Domain Vision Statement

A short description (about one page) of the Core Domain and the value it brings.

**Contents:**
- Nature of the domain model
- How it is valuable to the enterprise
- How different interests are balanced

**What to include:**
- What makes this model special
- How it serves business needs
- Key distinctions from off-the-shelf solutions

**What NOT to include:**
- Technical architecture details
- Generic infrastructure concerns
- Features available in any competing product

**Use:**
- Guide resource allocation
- Inform modeling choices
- Educate team members

#### Highlighted Core

Make the Core Domain easy to see:

**Distillation Document:**
- 3-7 sparse pages
- Describes Core Domain and primary interactions
- Minimalist entry point, not complete design document
- Should age slowly (focuses on stable, high-level concepts)

**Flagged Core:**
- Mark Core elements within the primary model repository
- Use stereotypes, comments, or tools
- Make it effortless to know what's in or out

**Using the Distillation Document as Process Tool:**

When a code change requires updating the Distillation Document:
- That signals a significant change to the Core
- Consultation with the team is warranted
- Changes require notification to all team members

#### Cohesive Mechanisms

**COHESIVE MECHANISM** = A framework that encapsulates complex computations, exposing capability through an Intention-Revealing Interface.

**Distinction from Generic Subdomain:**
- Generic Subdomain: An expressive model of domain concepts
- Cohesive Mechanism: Solves computational problems posed by the model

*"A model proposes; a Cohesive Mechanism disposes."*

**Example: Graph Traversal for Organization Charts**

An organization model needed to answer questions like "Who in this chain of command can approve this?" The solution: a graph traversal framework.

- Organization model declares structure (persons as nodes, relationships as edges)
- Graph framework handles traversal algorithms
- Clean separation between "what" (the organization) and "how" (finding paths)

**Benefits:**
- Model can focus on expressing "what"
- Mechanism handles "how"
- Clearer separation of concerns
- Mechanism can be tested independently

#### Segregated Core

**SEGREGATED CORE** = Refactoring to place Core elements into their own Module(s), distinct from supporting elements.

**Process:**
1. Identify Core subdomains (from Distillation Document)
2. Move related classes to new Modules
3. Sever data and functionality not directly expressing Core concepts
4. Refactor to simplify relationships
5. Repeat for each Core subdomain

**Benefits:**
- Core becomes more visible
- Easier to understand and work on
- Supporting elements can be handled with less care

**Costs:**
- Significant refactoring effort
- May make some relationships more complex
- Requires team coordination

#### Abstract Core

**ABSTRACT CORE** = An abstract model expressing the most fundamental concepts and relationships.

**Characteristics:**
- Contains abstract classes or interfaces
- Specialized aspects placed in separate Modules
- References run toward the Abstract Core

**Use when:**
- Interrelationships in the Core are complex
- Need to see fundamental concepts without detail
- Multiple specialized implementations exist

### Chapter 16: Large-Scale Structure

#### Evolving Order

**EVOLVING ORDER** = Let the structure evolve with the application, changing as needed.

**Key principles:**
- Don't impose structure prematurely
- Allow structure to grow organically
- Revisit and refine as understanding deepens
- A structure that doesn't fit should be discarded

**Avoid the Master Plan:** Overly ambitious up-front architecture:
- Becomes obsolete as requirements change
- Prevents organic adaptation
- Alienates developers who can't influence it

#### System Metaphor

**SYSTEM METAPHOR** = A loose, easily understood analogy that provides a vocabulary for large-scale structures.

**Benefits:**
- Easy to communicate
- Gives intuition about relationships
- Provides shared vocabulary

**Examples:**
- "Desktop" for GUI file systems
- "Shopping cart" for e-commerce
- "Pipeline" for data processing

**Risks:**
- May break down as the system grows
- Can be misleading if taken too literally
- May constrain thinking

#### Responsibility Layers

**RESPONSIBILITY LAYERS** = Organizing the model into layers of conceptual responsibility, with dependencies running one way.

**Common layers (varies by domain):**

| Layer | Responsibility | Examples |
|-------|---------------|----------|
| **Decision Support** | Analysis, planning, recommendations | Routing optimization, risk analysis |
| **Policy** | Rules, goals, constraints | Business rules, regulatory requirements |
| **Operations** | Current activities, state | Orders, shipments, transactions |
| **Potential/Capability** | What's possible | Resources, inventory, schedules |

**Rules:**
- Upper layers depend on lower layers
- Lower layers have no knowledge of upper layers
- Each layer has clear responsibilities

**Example: Cargo Shipping Layers**

```
[Decision Support]  - Router, Route Bias Policy
         |
         v
[Operations]        - Cargo, Route Specification, Itinerary
         |
         v
[Capability]        - Customer, Transport Leg, Location
```

**Choosing Layers:**

Look for:
- Storytelling: Layers communicate domain priorities
- Conceptual dependency: Upper layer concepts need lower layer backdrop
- Shearing planes: Different rates of change between layers

**Impact on Design:**

When a team has adopted Responsibility Layers, every design decision must respect them. This can feel constraining, but provides:
- Consistency across the codebase
- Clearer dependencies
- Easier onboarding for new developers

#### Knowledge Level

**KNOWLEDGE LEVEL** = A separate set of objects that describe and constrain the structure and behavior of the basic model.

**Use when:**
- Roles and relationships vary across situations
- Users need to configure object behavior
- Same code must support different business rules

**Structure:**
- Knowledge Level: Describes types, rules, policies
- Operational Level: Objects that follow those rules

**Example: Employee Types**

Operational Level:
```
bob: Employee (references office_admin: EmployeeType)
```

Knowledge Level:
```
office_admin: EmployeeType
  - payroll: HourlyPayroll
  - retirement: DefinedBenefit
```

The Knowledge Level (EmployeeType) constrains which retirement plans and payroll types an Employee can have. Changing an EmployeeType affects all Employees of that type.

**Caution:** Knowledge Levels add complexity. Use sparingly, only where configurability is crucial.

#### Pluggable Component Framework

**PLUGGABLE COMPONENT FRAMEWORK** = Abstract interfaces defining core concepts, allowing diverse implementations to be substituted.

**Characteristics:**
- Distilled Abstract Core as interfaces
- Hub that connects components through protocols
- Independent implementation of components

**Requirements:**
- Very mature domain understanding
- Deep, stable model
- Precise interface design

**Example: SEMATECH CIM Framework**

In semiconductor manufacturing, the CIM Framework defines:
- Abstract interfaces: Lot, ProcessFlow, ProcessOperation, Machine
- Protocol for interaction
- Standard semantics

Vendors implement Machine interfaces for their equipment. Applications built on CIM work with any compliant machine.

**Use sparingly:** Requires significant investment and may constrain future refinement.

### Chapter 17: Bringing Strategy Together

#### Combining Structures and Contexts

- Large-scale structure can exist within a single Bounded Context
- Structure can also organize the Context Map
- Different contexts may use different internal structures

#### Combining Structure and Distillation

- Structure helps explain relationships in Core Domain
- Core Domain concepts may be part of the structure itself
- Distillation lightens the load when restructuring

#### Assessment Questions

1. Can you draw a consistent Context Map?
2. Is there a Ubiquitous Language? Is it rich enough?
3. Is the Core Domain identified? Can you write a Vision Statement?
4. Does technology support Model-Driven Design?
5. Do developers have necessary skills and domain knowledge?

#### Strategic Design Decision Making

**Six Essentials:**

1. **Decisions must reach the entire team**
   - Everyone must know and follow the strategy
   - Authority matters less than actual adoption

2. **Process must absorb feedback**
   - Application developers have deepest domain knowledge
   - Architecture teams need tight feedback loops with development

3. **Plan must allow for evolution**
   - Don't set highest-level decisions in stone
   - EVOLVING ORDER over rigid blueprints

4. **Don't siphon all best talent to architecture**
   - Strong designers needed on application teams
   - Domain knowledge needed on strategy teams

5. **Strategic design requires minimalism**
   - Every element had better be worth the cost
   - Ill-fitting structure causes more harm than no structure

6. **Objects are specialists; developers are generalists**
   - Let people cross boundaries
   - Discourage over-specialization

---

## Summary: Pattern Quick Reference

### Building Blocks

| Pattern | Purpose |
|---------|---------|
| **Entity** | Objects defined by identity, not attributes |
| **Value Object** | Immutable objects defined by attributes |
| **Service** | Stateless operations not belonging to Entities/VOs |
| **Module** | Named containers for related concepts |
| **Aggregate** | Cluster treated as unit for changes |
| **Factory** | Creates complex objects and Aggregates |
| **Repository** | Collection-like interface for obtaining Aggregates |

### Supple Design

| Pattern | Purpose |
|---------|---------|
| **Intention-Revealing Interface** | Names state purpose, not mechanism |
| **Side-Effect-Free Function** | Operations that don't modify state |
| **Assertion** | Explicit post-conditions and invariants |
| **Conceptual Contours** | Boundaries following natural domain divisions |
| **Standalone Class** | Minimal dependencies |
| **Closure of Operations** | Operations that stay in the same type |
| **Specification** | Predicate encapsulating business rules |

### Context Boundaries

| Pattern | Purpose |
|---------|---------|
| **Bounded Context** | Explicit boundary for a model's applicability |
| **Continuous Integration** | Keep model unified within a context |
| **Context Map** | Overview of contexts and relationships |

### Context Relationships

| Pattern | Purpose |
|---------|---------|
| **Shared Kernel** | Small shared model between aligned teams |
| **Customer/Supplier** | Upstream supports downstream needs |
| **Conformist** | Downstream adopts upstream model |
| **Anticorruption Layer** | Translation layer to protect model |
| **Separate Ways** | No integration between contexts |
| **Open Host Service** | Public protocol for integration |
| **Published Language** | Well-documented shared language |

### Distillation

| Pattern | Purpose |
|---------|---------|
| **Core Domain** | The distinctive, valuable heart |
| **Generic Subdomain** | Supporting but not differentiating |
| **Domain Vision Statement** | Short description of Core's value |
| **Highlighted Core** | Make Core visible in documentation |
| **Cohesive Mechanism** | Encapsulated computational framework |
| **Segregated Core** | Core in its own Module(s) |
| **Abstract Core** | Abstract model of fundamentals |

### Large-Scale Structure

| Pattern | Purpose |
|---------|---------|
| **Evolving Order** | Let structure grow organically |
| **System Metaphor** | Loose unifying analogy |
| **Responsibility Layers** | Organize by conceptual responsibilities |
| **Knowledge Level** | Objects describing rules for other objects |
| **Pluggable Component Framework** | Abstract interfaces for substitutable components |

---

## Core Principles (The Heart of DDD)

1. **Focus on the Core Domain** - Invest your best resources where it matters most

2. **Model in collaboration with domain experts** - Knowledge crunching is continuous

3. **Speak a single Ubiquitous Language** - Bridge the gap between business and technology

4. **Make implicit concepts explicit** - Hidden concepts cause hidden bugs

5. **Define clear boundaries** - Know where each model applies

6. **Refactor toward deeper insight** - Models improve as understanding grows

7. **Favor evolution over up-front design** - Let order emerge from working code

8. **Design supple models** - Enable change through clear, intention-revealing designs
