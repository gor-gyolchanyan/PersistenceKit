//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPrimitive

// Topic: LosslessStringConvertible

extension PersistentPrimitive
where Self: LosslessStringConvertible, Primitive == String {

    // Exposed

    public init?(primitive: Primitive) {
        self.init(primitive)
    }

    public var primitive: Primitive {
        description
    }
}
