//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: _PersistentAggregateObjectVariant._OutputSchematicInspector

extension _PersistentAggregateObjectVariant {

    struct _SchematicInspector<Aggregate>
    where Aggregate: PersistentAggregate {

        // Topic: Main

        // Exposed

        init(_aggregateName: String, _identifierKeyPath: KeyPath<Aggregate, Aggregate.ID>?) {
            self._identifierKeyPath = _identifierKeyPath
            _nameMapping = .init()
            _report = .init(_aggregateName: _aggregateName)
        }

        // Concealed

        private let _identifierKeyPath: KeyPath<Aggregate, Aggregate.ID>?
        private var _nameMapping: [PartialKeyPath<Aggregate>: String]
        private var _report: Report
    }
}

// Protocol: PersistentAggregateSchematicInspector

extension _PersistentAggregateObjectVariant._SchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Report = _PersistentAggregateObjectVariant

    mutating func inspect<Primitive>(_ primitiveKeyPath: KeyPath<Aggregate, Primitive>, named primitiveName: String)
    where Primitive: PersistentPrimitive {
        _nameMapping[primitiveKeyPath] = primitiveName
        _report._primitiveObjectVariantMapping[primitiveName] = Primitive._primitiveObjectVariant
    }
    
    mutating func report() -> Report {
        _report._identifierPrimitiveName = _identifierKeyPath.map { _nameMapping[$0] } ?? nil
        return _report
    }
}
