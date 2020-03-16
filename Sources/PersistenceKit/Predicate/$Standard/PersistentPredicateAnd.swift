//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Foundation.NSCompoundPredicate

// Type: PersistentPredicateAnd

public struct PersistentPredicateAnd<Some, Other>
where Some: PersistentPredicate, Other: PersistentPredicate, Some.Primitive == Other.Primitive {

    // Topic: Main

    // Exposed

    public var some: Some

    public var other: Other

    // Concealed

    init(_ some: Some, _ other: Other) {
        self.some = some
        self.other = other
    }
}

public func && <Some, Other>(_ some: Some, _ other: Other) -> PersistentPredicateAnd<Some, Other> {
    .init(some, other)
}

// Protocol: _RawPersistentPredicate

extension PersistentPredicateAnd: _RawPersistentPredicate {

    // Exposed

    var _predicateObject: _PersistentPredicateObject {
        Foundation.NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                some._predicateObject,
                other._predicateObject,
            ]
        )
    }
}

// Protocol: PersistentPredicate

extension PersistentPredicateAnd: PersistentPredicate {

    // Exposed

    public typealias Predicate = Self

    public typealias Primitive = Some.Primitive

    public var predicate: Predicate {
        self
    }
}
