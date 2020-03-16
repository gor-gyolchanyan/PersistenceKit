//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPredicateParameter

// Protocol: _RawPersistentPredicateParameter

extension PersistentPredicateParameter {

    // Concealed

    var _predicateParameterObject: _PersistentPredicateParameterObject {
        if let instance = self as? _RawPersistentPredicateParameter {
            return instance._predicateParameterObject
        } else {
            return parameter._predicateParameterObject
        }
    }
}
