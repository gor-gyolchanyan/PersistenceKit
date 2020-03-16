//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPredicateParameter

public protocol PersistentPredicateParameter {

    // Topic: Main

    // Exposed

    associatedtype Primitive: PersistentPrimitive

    associatedtype Parameter: PersistentPredicateParameter

    var parameter: Parameter { get }
}
