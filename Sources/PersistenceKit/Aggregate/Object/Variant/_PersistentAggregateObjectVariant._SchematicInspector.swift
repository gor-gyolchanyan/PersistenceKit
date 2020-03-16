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

        init(_aggregateName: String, _idKeyPath: KeyPath<Aggregate, Aggregate.Schematic.ID>) {
            self._idKeyPath = _idKeyPath
            _nameMapping = .init()
            _report = .init(_aggregateName: _aggregateName)
        }

        // Concealed

        private let _idKeyPath: KeyPath<Aggregate, Aggregate.Schematic.ID>
        private var _nameMapping: [PartialKeyPath<Aggregate>: String]
        private var _report: Report
    }
}

// Protocol: PersistentAggregateSchematicInspector

extension _PersistentAggregateObjectVariant._SchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Report = _PersistentAggregateObjectVariant

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentPrimitive {
        _nameMapping[memberKeyPath] = memberName
        _report._objectVariantMapping[memberName] = Member._primitiveObjectVariant
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentAggregate {
        _nameMapping[memberKeyPath] = memberName
        _report._objectVariantMapping[memberName] = Member._primitiveObjectVariant
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member?>, named memberName: String)
    where Member: PersistentAggregate {
        _nameMapping[memberKeyPath] = memberName
        _report._objectVariantMapping[memberName] = Member._primitiveObjectVariant
    }

    mutating func report() -> Report {
        _report._idName = Aggregate._hasID ? _nameMapping[_idKeyPath] :  nil
        return _report
    }
}
