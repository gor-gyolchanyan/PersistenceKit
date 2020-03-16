//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Foundation.NSNull

// Type: PersistentMapping._OutputSchematicInspector

extension PersistentMapping {

    struct _OutputSchematicInspector {

        // Topic: Main

        // Exposed

        init(_aggregate: Aggregate) {
            self._aggregate = _aggregate
            _report = .init()
        }

        let _aggregate: Aggregate

        // Concealed

        private var _report: Report
    }
}

// Protocol: PersistentAggregateSchematicInspector

extension PersistentMapping._OutputSchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Report = PersistentMapping

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentPrimitive {
        _report._objectMapping[memberName] = _aggregate[keyPath: memberKeyPath]._primitiveObject
        _report._nameMapping[memberKeyPath] = memberName
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentAggregate {
        _report._objectMapping[memberName] = _aggregate[keyPath: memberKeyPath]._primitiveObject
        _report._nameMapping[memberKeyPath] = memberName
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member?>, named memberName: String)
    where Member: PersistentAggregate {
        _report._objectMapping[memberName] = _aggregate[keyPath: memberKeyPath]?._primitiveObject ?? NSNull()
        _report._nameMapping[memberKeyPath] = memberName
    }

    func report() -> Report {
        _report
    }
}

