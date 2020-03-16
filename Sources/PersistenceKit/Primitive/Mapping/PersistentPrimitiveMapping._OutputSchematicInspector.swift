//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPrimitiveMapping._OutputSchematicInspector

extension PersistentPrimitiveMapping {

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

extension PersistentPrimitiveMapping._OutputSchematicInspector: PersistentAggregateSchematicInspector {

    // Exposed

    typealias Report = PersistentPrimitiveMapping

    mutating func inspect<Primitive>(_ primitiveKeyPath: KeyPath<Aggregate, Primitive>, named primitiveName: String)
    where Primitive: PersistentPrimitive {
        _report._primitiveObjectMapping[primitiveName] = _aggregate[keyPath: primitiveKeyPath]._primitiveObject
        _report._primitiveNameMapping[primitiveKeyPath] = primitiveName
    }

    func report() -> Report {
        _report
    }
}

