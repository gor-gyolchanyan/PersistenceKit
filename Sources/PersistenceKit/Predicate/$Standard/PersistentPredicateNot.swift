//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Foundation.NSCompoundPredicate

// Type: PersistentPredicateNot

public struct PersistentPredicateNot<Some>
where Some: PersistentPredicate {

    // Topic: Main

    // Exposed

    public var some: Some

    // Concealed

    init(_ some: Some) {
        self.some = some
    }
}

public prefix func ! <Some>(_ some: Some) -> PersistentPredicateNot<Some> {
    .init(some)
}

// Protocol: _RawPersistentPredicate

extension PersistentPredicateNot: _RawPersistentPredicate {

    // Exposed

    var _predicateObject: _PersistentPredicateObject {
        Foundation.NSCompoundPredicate(
            notPredicateWithSubpredicate: some._predicateObject
        )
    }
}

// Protocol: PersistentPredicate

extension PersistentPredicateNot: PersistentPredicate {

    // Exposed

    public typealias Predicate = Self

    public typealias Primitive = Some.Primitive

    public var predicate: Predicate {
        self
    }
}
