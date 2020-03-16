//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: KeyPath._SchematicInspector

extension KeyPath
where Root: PersistentAggregate, Value: PersistentPrimitive {

    struct _SchematicInspector {

        // Topic: Main

        // Exposed

        init(_keyPath keyPath: KeyPath) {
            _keyPath = keyPath
            _report = ""
        }

        // Concealed

        let _keyPath: KeyPath
        var _report: Report
    }
}

// Protocol: PersistentAggregateSchematicInspector

extension KeyPath._SchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Aggregate = Root

    typealias Report = String

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentPrimitive {
        if memberKeyPath == _keyPath {
            _report = memberName
        }
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentAggregate {
        if memberKeyPath == _keyPath {
            _report = memberName
        }
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member?>, named memberName: String)
    where Member: PersistentAggregate {
        if memberKeyPath == _keyPath {
            _report = memberName
        }
    }

    mutating func report() -> Report {
        _report
    }
}
