//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: Swift.String

// Protocol: _RawPersistentPredicateParameter

extension Swift.String: _RawPersistentPredicateParameter {

    // Exposed

    var _predicateParameterObject: _PersistentPredicateParameterObject {
        .init(forConstantValue: _primitiveObject)
    }
}
