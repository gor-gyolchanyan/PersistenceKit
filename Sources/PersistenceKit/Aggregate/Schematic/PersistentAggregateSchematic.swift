//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentAggregateSchematic

public protocol PersistentAggregateSchematic {

    // Topic: Main
    
    // Exposed

    associatedtype Aggregate: PersistentAggregate

    associatedtype ID: PersistentPrimitive & Hashable = Never

    typealias Mapping = PersistentMapping<Aggregate>

    var aggregateName: String { get }

    var idKeyPath: KeyPath<Aggregate, ID> { get }

    func report<Inspector>(to inspector: inout Inspector)
    where Inspector: PersistentAggregateSchematicInspector, Inspector.Aggregate == Aggregate

    func aggregate(from mapping: Mapping) -> Aggregate?
}

extension PersistentAggregateSchematic
where ID == Never {

    // Exposed

    public var idKeyPath: KeyPath<Aggregate, ID> { \._neverID }
}

// Topic: Main

extension PersistentAggregate {

    // Concealed

    fileprivate var _neverID: Never { fatalError("Attempted to access the ID of an aggregate that doesn't have and ID.") }
}
