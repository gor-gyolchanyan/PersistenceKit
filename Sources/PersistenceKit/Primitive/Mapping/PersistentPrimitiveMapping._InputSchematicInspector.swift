//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import struct ObjectiveC.Selector

// Type: PersistentPrimitiveMapping._InputSchematicInspector

extension PersistentPrimitiveMapping {

    struct _InputSchematicInspector {

        // Topic: Main

        // Exposed

        init(_persistentAggregateObject: _PersistentAggregateObject) {
            self._persistentAggregateObject = _persistentAggregateObject
            _report = .init()
        }

        let _persistentAggregateObject: _PersistentAggregateObject

        // Concealed

        private var _report: Report
    }
}

import ObjectiveC

// Protocol: PersistentAggregateSchematicInspector

extension PersistentPrimitiveMapping._InputSchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Report = PersistentPrimitiveMapping

    mutating func inspect<Primitive>(_ primitiveKeyPath: KeyPath<Aggregate, Primitive>, named primitiveName: String)
    where Primitive: PersistentPrimitive {
        // TODO: Replace literal selector with something better.
        let selector = Selector("_get_\(primitiveName)")
        guard let primitiveObject = _persistentAggregateObject.perform(selector)?.takeUnretainedValue() as? _PersistentPrimitiveObject else {
            return
        }
        _report._primitiveObjectMapping[primitiveName] = primitiveObject
        _report._primitiveNameMapping[primitiveKeyPath] = primitiveName
    }

    func report() -> Report {
        _report
    }
}

