//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentAggregateSchematic

public protocol PersistentAggregateSchematic {

    // Topic: Main
    
    // Exposed

    associatedtype Aggregate: PersistentAggregate

    typealias Mapping = PersistentPrimitiveMapping<Aggregate>

    var aggregateName: String { get }

    var identifierKeyPath: KeyPath<Aggregate, Aggregate.ID> { get }

    func report<Inspector>(to inspector: inout Inspector)
    where Inspector: PersistentAggregateSchematicInspector, Inspector.Aggregate == Aggregate

    func aggregate(from mapping: Mapping) -> Aggregate?
}
