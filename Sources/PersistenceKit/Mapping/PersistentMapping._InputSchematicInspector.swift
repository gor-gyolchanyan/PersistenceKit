//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import struct ObjectiveC.Selector

// Type: PersistentMapping._InputSchematicInspector

extension PersistentMapping {

    struct _InputSchematicInspector {

        // Topic: Main

        // Exposed

        init(_aggregateObject: _PersistentAggregateObject) {
            self._aggregateObject = _aggregateObject
            _report = .init()
        }

        let _aggregateObject: _PersistentAggregateObject

        // Concealed

        private var _report: Report
    }
}

import ObjectiveC

// Protocol: PersistentAggregateSchematicInspector

extension PersistentMapping._InputSchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Report = PersistentMapping

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentPrimitive {
        // TODO: Replace literal selector with something better.
        let selector = Selector("_get_\(memberName)")
        guard let primitiveObject = _aggregateObject.perform(selector)?.takeUnretainedValue() as? _PersistentPrimitiveObject else {
            return
        }
        _report._objectMapping[memberName] = primitiveObject
        _report._nameMapping[memberKeyPath] = memberName
    }

    mutating func inspect<Member>(_ memberKeyPath: KeyPath<Aggregate, Member>, named memberName: String)
    where Member: PersistentAggregate {
        // TODO: Replace literal selector with something better.
        let selector = Selector("_get_\(memberName)")
        guard let primitiveObject = _aggregateObject.perform(selector)?.takeUnretainedValue() as? _PersistentPrimitiveObject else {
            return
        }
        _report._objectMapping[memberName] = primitiveObject
        _report._nameMapping[memberKeyPath] = memberName
    }

    func report() -> Report {
        _report
    }
}

