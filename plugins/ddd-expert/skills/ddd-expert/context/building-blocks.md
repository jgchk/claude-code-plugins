# DDD Building Blocks (Tactical Patterns)

## Entities

Objects defined by identity, not attributes. Two Entities with identical attributes but different IDs are different objects. You track "the same object" even as all attributes change over time.

**Characteristics**: Unique identifier persists across time. Mutable state, stable identity. Equality based on ID only.

**When to use**: Object tracked through states, must distinguish between objects with same attributes, lifecycle matters.

**Modeling Entities**:
- Strip the Entity's definition down to the most intrinsic characteristics
- Add only behavior essential to the concept and attributes required by that behavior
- Look beyond the specific software to the domain to find the real identity basis

**Identity implementation options**:
- User-assigned IDs (Social Security numbers, tracking IDs)
- System-generated IDs (GUIDs, database sequences)
- Attributes that are unique in context (natural keys)

**Implementation**:
- Prefer domain-meaningful IDs over UUIDs when possible
- Equals/hashCode based solely on identity
- Encapsulate state changes through intention-revealing methods
- Validate invariants on every state change

**Example: Person as Entity**
A person's identity doesn't depend on their name (which can change), their address (which can change), or even their SSN (which can be reassigned in rare cases). A Person Entity is defined by the real-world individual it represents.

---

## Value Objects

Objects defined entirely by attributes. Two with same attributes are interchangeable. You care about *what* they are, not *which* one.

**Characteristics**: Immutable. No identity—equality based on all attributes. Side-effect-free. Freely shareable.

**When to use**: Describes a characteristic or measurement, you care about what not which, immutability is natural.

**Context matters**: An Address is a Value Object for mail-order (just need correct street/city/postal code). But for a postal service or electric utility, addresses might be Entities—they track specific physical locations over time, regardless of how the description changes.

**Implementation**:
- All fields final/readonly
- No setters—new instances for different values
- Equals/hashCode based on all attributes
- Rich behavior operating on own state

**Sharing vs Copying**:

Share Value Objects when:
- Many instances with same values expected
- Object creation is expensive
- Immutability is guaranteed

Copy when:
- Few expected duplicates
- Communication overhead of sharing outweighs benefits

**Examples**: Money (amount + currency), Address, DateRange, Coordinates, Quantity.

---

## Aggregates

A cluster of Entities and Value Objects treated as a single unit for data changes. One Entity is the Root—all external access goes through it.

**Characteristics**: Define consistency boundary. Root controls access. Internal objects never referenced directly from outside. One Aggregate = one transaction. Reference other Aggregates by ID only.

**Design Rules**:

1. **Root has global identity** — Internal entities have local identity only (unique within Aggregate)

2. **Nothing outside can hold a reference to anything inside except the root** — Transient references for single operation OK, but not persisted

3. **Only root can be obtained from database queries** — Internal objects found by traversal from root

4. **Delete removes everything** — Delete operation must remove everything within the boundary at once

5. **Invariants enforced per transaction** — When any object inside Aggregate changes, all invariants must be satisfied

**Finding Aggregates**:
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

**Design Considerations**:

Small Aggregates (default to this):
- Easier to maintain consistency
- Better for concurrent access (smaller lock scope)
- Simpler to understand

Large Aggregates:
- Can protect more complex invariants
- Fewer inter-Aggregate references to manage
- But: harder to maintain, concurrent access issues

---

## Domain Services

Operations that don't belong to any Entity or Value Object. Domain concepts that are verbs, not nouns.

**Characteristics**: Stateless. Named after domain activities. Parameters and return values are domain objects. Interface defined in terms of other model elements.

**When to use**: Operation spans multiple Aggregates, represents a concept that isn't a thing, forcing it into Entity would distort model.

**Avoid when**: Behavior belongs on Entity/Value Object (anemic domain smell).

**Service Types**:

| Type | Purpose | Example |
|------|---------|---------|
| **Domain Service** | Express domain logic | TransferService, PricingService |
| **Application Service** | Coordinate tasks, no business logic | OrderProcessingCoordinator |
| **Infrastructure Service** | Technical concerns | EmailService, PersistenceService |

**Example: Fund Transfer Service**

Transferring money from one account to another doesn't naturally belong to either account. Making it a method on Account (`account.transferTo(otherAccount, amount)`) distorts the model—the operation is fundamentally about *both* accounts.

```java
interface FundsTransferService {
    void transfer(Account source, Account dest, Money amount);
}
```

**Avoiding the Anemic Domain Model**:
Services should not steal behavior that properly belongs in Entities or Value Objects. The domain model becomes anemic when Services contain all the behavior while Entities are mere data holders.

**Rule of thumb**: If the operation is naturally part of an Entity's responsibilities, it belongs in the Entity. Services are for cross-cutting operations.

---

## Repositories

Abstraction for retrieving and storing Aggregates. Provides illusion of in-memory collection of all Aggregates.

**Characteristics**: One per Aggregate type. Interface in domain, implementation in infrastructure. Returns fully reconstituted Aggregates.

**Design Principles**:

1. **Collection-like interface** — add(), remove(), findById(), query methods for common patterns

2. **Aggregate-centric** — Never return internals or raw data. Always complete Aggregates.

3. **Domain-named queries** — findActiveOrders() not findByStatusEqualsActive()

**Using Specifications with Repositories**:

For complex queries, combine the Specification pattern with Repository:

```java
List<Invoice> overdueInvoices =
    invoiceRepository.findSatisfying(
        new InvoiceIsOverdueSpecification(currentDate));
```

This keeps query logic in the domain layer (the Specification) while the Repository handles the actual retrieval mechanism.

**Implementation**:
```
Interface (domain):
  - add(aggregate), remove(aggregate)
  - findById(id): Aggregate?
  - findSatisfying(spec): List<Aggregate>
  - domain-specific finders

Implementation (infrastructure):
  - Handles ORM/SQL/NoSQL details
  - Reconstitutes Aggregates completely
  - May delegate to Factory for reconstitution
```

---

## Domain Events

A record of something significant that happened. Represents a fact domain experts care about.

**Characteristics**: Immutable (represent past). Named in past tense (OrderPlaced, PaymentReceived). Capture state at occurrence. Part of Ubiquitous Language.

**When to use**: Experts talk about something "happening", need reactions across Aggregate boundaries, need audit trail, eventual consistency.

**Implementation**:
```
Structure:
  - Immutable Value Object
  - Timestamp of occurrence
  - Relevant state at that moment
  - Producing Aggregate's identity

Publishing:
  - Aggregate collects during operation
  - Dispatch after transaction commits
  - Or: store and process async
```

**Handling patterns**: Synchronous (within context), Asynchronous (across contexts), Event sourcing (events as source of truth).

---

## Specifications

Explicit predicates representing business rules. Make implicit selection criteria or validation rules first-class objects.

**Characteristics**: Encapsulate boolean logic. Combinable with AND, OR, NOT. Named in domain language. Reusable across contexts.

**Three Uses of Specification**:
1. **Validation**: Does this object meet criteria?
2. **Selection**: Which objects from a collection satisfy criteria?
3. **Building to order**: Create something that satisfies criteria

**When to use**: Complex selection criteria, validation rules that don't fit Entity/Value Object, rules that need combining or reusing.

**Forms**:

1. **Hard-coded Specification** — Logic in isSatisfiedBy() method
2. **Parameterized Specification** — Constructor takes criteria values
3. **Composite Specification** — Combines other specifications

**Implementation**:
```java
interface Specification<T> {
    boolean isSatisfiedBy(T candidate);
    Specification<T> and(Specification<T> other);
    Specification<T> or(Specification<T> other);
    Specification<T> not();
}
```

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

**Combining Specifications**:
```java
Specification<Customer> goldCustomer =
    new CustomerHasMinimumPurchases(10000)
        .and(new CustomerAccountInGoodStanding())
        .and(new CustomerRegisteredBefore(cutoffDate));
```

**Use cases**: Repository queries, policy validation, business rule engines, filtering collections.

---

## Factories

Encapsulate complex object creation, ensuring Aggregates/Entities created in valid state.

**When to use**: Complex creation logic, requires coordinating multiple objects, different scenarios need different approaches.

**Key Principles**:
- Each creation method is atomic
- Factory enforces invariants of created objects
- Factory should create objects in valid state
- Factory abstracts the concrete class being created

**Forms**: Factory methods on Roots (create related Entities), standalone Factory classes, factory methods on natural creators.

**Example: Cargo Factory**
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

**Reconstitution** (rebuilding from storage):
- Does NOT assign new IDs (uses stored IDs)
- Does NOT enforce invariants that might have changed (historical data)
- DOES reassemble the object structure

Repository may delegate to Factory for reconstitution.

---

## Modules

Organize model elements into cohesive units reducing cognitive load. Module names are part of the Ubiquitous Language.

**Principles**: High cohesion within, low coupling between. Names are Ubiquitous Language. Align with domain concepts, not technical layers.

**Common Mistakes**:
- Organizing by technical type (all Services together, all Entities together)
- Creating Modules that cut across domain concepts
- Ignoring Modules entirely
- Using infrastructure patterns like MVC to organize domain objects

**Modules are a communication mechanism.** A well-named Module tells developers immediately what concepts are grouped together and why.

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

**Guidance**: Modules tell a domain story. One Aggregate often = one module. Avoid splitting by technical concern.

---

## Associations

Associations in a model correspond to object interactions in code. Three ways to make associations more tractable:

1. **Impose a traversal direction** — Many bidirectional associations are really unidirectional in practice

2. **Add a qualifier** — Reduce multiplicity by specifying the context

3. **Eliminate nonessential associations** — Keep only those fundamental to the domain concept

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
