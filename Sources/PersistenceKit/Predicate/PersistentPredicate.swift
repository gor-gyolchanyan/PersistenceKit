//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPredicate

public protocol PersistentPredicate {

    // Topic: Main

    // Exposed

    associatedtype Predicate: PersistentPredicate

    associatedtype Primitive: PersistentPrimitive

    var predicate: Predicate { get }
}
