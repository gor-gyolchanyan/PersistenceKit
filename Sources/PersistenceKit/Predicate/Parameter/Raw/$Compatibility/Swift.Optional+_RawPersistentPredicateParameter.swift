//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: Swift.Optional

// Protocol: _RawPersistentPredicateParameter

extension Swift.Optional: _RawPersistentPredicateParameter
where Wrapped: PersistentPrimitive & _RawPersistentPredicateParameter {

    // Exposed

    var _predicateParameterObject: _PersistentPredicateParameterObject {
        .init(forConstantValue: _primitiveObject)
    }
}
