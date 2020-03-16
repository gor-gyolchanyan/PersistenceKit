//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Dispatch.DispatchQueue
import struct Foundation.URL
import class Foundation.FileManager
import class Realm.RLMRealmConfiguration

// Type: PersistentStorage._SchemataicInspector

extension PersistentStorage {

    struct _SchemataicInspector {

        // Topic: Main

        // Exposed

        init(_storageName: [String]) {
            self._storageName = _storageName
            _aggregateObjectTypeSet = .init()
        }

        // Concealed

        private var _storageName: [String]
        private var _aggregateObjectTypeSet: [ObjectIdentifier: _PersistentAggregateObject.Type]
    }
}

// Protocol: PersistentStorageSchematicInspector

extension PersistentStorage._SchemataicInspector: PersistentStorageSchematicInspector {

    // Exposed

    typealias Report = Result<PersistentStorage._Object, Error>

    mutating func inspect<Aggregate>(_ aggregateType: Aggregate.Type)
    where Aggregate: PersistentAggregate {
        _aggregateObjectTypeSet[.init(aggregateType)] = aggregateType._aggregateObjectType
    }

    func report() -> Report {
        let containerUrl: Foundation.URL
        do {
            containerUrl = try Foundation.FileManager
            .default
            .url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            return .failure(error)
        }

        let storageUrl = _storageName.reduce(into: containerUrl) { $0.appendPathComponent($1) }

        do {
            if !FileManager.default.fileExists(atPath: storageUrl.path) {
                try FileManager.default.createDirectory(
                    atPath: storageUrl.path,
                    withIntermediateDirectories: true,
                    attributes: [:]
                )
            }
        } catch {
            return .failure(error)
        }

        let configuration = Realm.RLMRealmConfiguration()
        configuration.fileURL =
            storageUrl
            .appendingPathComponent("Default.realm")
        configuration.readOnly = false
        configuration.schemaVersion = 1
        configuration.migrationBlock = { migration, oldSchemaVersion in

        }
        configuration.objectClasses = Array(_aggregateObjectTypeSet.values)
        configuration.deleteRealmIfMigrationNeeded = true

        let object: PersistentStorage._Object
        do {
            object = try interactive {
                try .init(configuration: configuration)
            }
        } catch {
            return .failure(error)
        }
        object.autorefresh = true

        return .success(object)
    }
}
