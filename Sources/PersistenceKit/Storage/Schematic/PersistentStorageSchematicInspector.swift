//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentStorageSchematicInspector

public protocol PersistentStorageSchematicInspector {

    // Topic: Main

    // Exposed

    associatedtype Report

    mutating func inspect<Aggregate>(_ aggregateType: Aggregate.Type)
    where Aggregate: PersistentAggregate

    mutating func report() -> Report
}
