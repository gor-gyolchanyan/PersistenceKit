//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPredicate

// Protocol: _RawPersistentPredicate

extension PersistentPredicate {

    // Exposed

    var _predicateObject: _PersistentPredicateObject {
        if let instance = self as? _RawPersistentPredicate {
            return instance._predicateObject
        } else {
            return predicate._predicateObject
        }
    }
}
