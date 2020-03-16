//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentAggregate
// Protocol: _PersistentPrimitiveObjectRepresentable

extension PersistentAggregate {

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        ._object(_aggregateObjectType)
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        guard
            let aggregateObject = _primitiveObject as? _PersistentAggregateObject
        else {
            return nil
        }
        self.init(_aggregateObject: aggregateObject)
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        _aggregateObject
    }
}
