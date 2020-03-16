//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPrimitiveMapping

public struct PersistentPrimitiveMapping<Aggregate>
where Aggregate: PersistentAggregate {

    // Topic: Main

    // Concealed

    init() {
        _primitiveNameMapping = .init()
        _primitiveObjectMapping = .init()
    }

    var _primitiveNameMapping: [PartialKeyPath<Aggregate>: String]
    var _primitiveObjectMapping: [String: _PersistentPrimitiveObject]
}

// Topic: Main

extension PersistentPrimitiveMapping {

    // Exposed

    public subscript<Primitive>(_ keyPath: KeyPath<Aggregate, Primitive>) -> Primitive?
    where Primitive: PersistentPrimitive {
        guard
            let primitiveName = _primitiveNameMapping[keyPath],
            let primitiveObject = _primitiveObjectMapping[primitiveName],
            let primitive = Primitive(_primitiveObject: primitiveObject)
        else {
            return nil
        }
        return primitive
    }
}
