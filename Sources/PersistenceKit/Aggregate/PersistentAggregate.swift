//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentAggregate

public protocol PersistentAggregate: Identifiable
where ID: PersistentPrimitive {

    // Topic: Main

    // Exposed

    associatedtype Schematic: PersistentAggregateSchematic
    where Schematic.Aggregate == Self

    static var schematic: Schematic { get }
}

// Topic: Main

extension PersistentAggregate {

    // Concealed
    
    static var _persistentAggregateObjectVariant: _PersistentAggregateObjectVariant {
        let schematic = Self.schematic
        var inspector = _PersistentAggregateObjectVariant._SchematicInspector<Self>(
            _aggregateName: schematic.aggregateName,
            _identifierKeyPath: schematic.identifierKeyPath
        )
        schematic.report(to: &inspector)
        return inspector.report()
    }

    static var _aggregateObjectType: _PersistentAggregateObject.Type {
        Self._persistentAggregateObjectVariant._persistentAggregateObjectType()
    }

    init?(_persistentAggregateObject: _PersistentAggregateObject) {
        let schematic = Self.schematic
        var inspector = PersistentPrimitiveMapping<Self>._InputSchematicInspector(_persistentAggregateObject: _persistentAggregateObject)
        schematic.report(to: &inspector)
        let persistentPrimitiveMapping = inspector.report()
        guard let instance = schematic.aggregate(from: persistentPrimitiveMapping) else {
            return nil
        }
        self = instance
    }

    var _persistentPrimitiveMapping: PersistentPrimitiveMapping<Self> {
        var inspector = PersistentPrimitiveMapping<Self>._OutputSchematicInspector(_aggregate: self)
        Self.schematic.report(to: &inspector)
        return inspector.report()
    }

    var _persistentAggregateObject: _PersistentAggregateObject {
        let persistentAggregateObjectVariant = Self._persistentAggregateObjectVariant
        let persistentAggregateObjectType = persistentAggregateObjectVariant._persistentAggregateObjectType()
        let persistentAggregateObject = persistentAggregateObjectType.init(value: _persistentPrimitiveMapping._primitiveObjectMapping)
        return persistentAggregateObject
    }
}
