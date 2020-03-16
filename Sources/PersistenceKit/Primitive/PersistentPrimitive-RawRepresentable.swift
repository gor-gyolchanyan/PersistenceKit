//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPrimitive

// Topic: RawRepresentable

extension PersistentPrimitive
where Self: RawRepresentable, Primitive == RawValue {

    // Exposed

    public init?(primitive: Primitive) {
        self.init(rawValue: primitive)
    }

    public var primitive: Primitive {
        rawValue
    }
}
