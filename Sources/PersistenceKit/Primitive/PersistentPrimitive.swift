//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPrimitive

public protocol PersistentPrimitive {

    // Topic: Main

    // Exposed

    associatedtype Primitive: PersistentPrimitive

    init?(primitive: Primitive)

    var primitive: Primitive { get }
}
