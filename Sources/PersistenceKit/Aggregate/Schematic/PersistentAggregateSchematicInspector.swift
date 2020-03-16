//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentAggregateSchematicInspector

public protocol PersistentAggregateSchematicInspector {

    // Topic: Main

    // Exposed

    associatedtype Aggregate: PersistentAggregate

    associatedtype Report

    mutating func inspect<Primitive>(_ primitiveKeyPath: KeyPath<Aggregate, Primitive>, named primitiveName: String)
    where Primitive: PersistentPrimitive

    mutating func report() -> Report
}

// Topic: Default

extension PersistentAggregateSchematicInspector {

    // Exposed

    public func inspect<Primitive>(_ primitiveKeyPath: KeyPath<Aggregate, Primitive>, named primitiveName: String)
    where Primitive: PersistentPrimitive { }
}
