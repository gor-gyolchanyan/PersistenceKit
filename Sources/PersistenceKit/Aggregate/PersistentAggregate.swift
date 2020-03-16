//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentAggregate

public protocol PersistentAggregate {

    // Topic: Main

    // Exposed

    associatedtype Schematic: PersistentAggregateSchematic
    where Schematic.Aggregate == Self

    static var schematic: Schematic { get }
}

// Topic: Main

extension PersistentAggregate {

    // Concealed
    
    static var _aggregateObjectVariant: _PersistentAggregateObjectVariant {
        let schematic = Self.schematic
        var inspector = _PersistentAggregateObjectVariant._SchematicInspector<Self>(
            _aggregateName: schematic.aggregateName,
            _idKeyPath: schematic.idKeyPath
        )
        schematic.report(to: &inspector)
        return inspector.report()
    }

    static var _aggregateObjectType: _PersistentAggregateObject.Type {
        Self._aggregateObjectVariant._persistentAggregateObjectType()
    }

    static var _hasID: Bool {
        Schematic.ID.self != Never.self
    }

    init?(_aggregateObject: _PersistentAggregateObject) {
        let schematic = Self.schematic
        var inspector = PersistentMapping<Self>._InputSchematicInspector(_aggregateObject: _aggregateObject)
        schematic.report(to: &inspector)
        let persistentPrimitiveMapping = inspector.report()
        guard let instance = schematic.aggregate(from: persistentPrimitiveMapping) else {
            return nil
        }
        self = instance
    }

    var _id: Schematic.ID {
        self[keyPath: Self.schematic.idKeyPath]
    }

    var _mapping: PersistentMapping<Self> {
        var inspector = PersistentMapping<Self>._OutputSchematicInspector(_aggregate: self)
        Self.schematic.report(to: &inspector)
        return inspector.report()
    }

    var _aggregateObject: _PersistentAggregateObject {
        let persistentAggregateObjectVariant = Self._aggregateObjectVariant
        let persistentAggregateObjectType = persistentAggregateObjectVariant._persistentAggregateObjectType()
        let persistentAggregateObject = persistentAggregateObjectType.init(value: _mapping._objectMapping)
        return persistentAggregateObject
    }
}
