//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: Swift.UInt16

// Protocol: _RawPersistentPredicateParameter

extension Swift.UInt16: _RawPersistentPredicateParameter {

    // Exposed

    var _predicateParameterObject: _PersistentPredicateParameterObject {
        .init(forConstantValue: _primitiveObject)
    }
}
