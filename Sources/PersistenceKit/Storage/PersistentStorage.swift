//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Realm.RLMRealm
import class Realm.RLMNotificationToken
import class Realm.RLMResults

// Type: PersistentStorage

public final class PersistentStorage {

    // Topic: Main

    // Concealed

    init(_object object: _Object) {
        _object = object
    }

    deinit {
        _object.invalidate()
    }

    let _object: _Object
}

// Topic: Main

extension PersistentStorage {

    // Exposed

    public convenience init<Schematic>(_ schematic: Schematic) throws
    where Schematic: PersistentStorageSchematic {
        var inspector = _SchemataicInspector(_storageName: schematic.storageName)
        schematic.report(to: &inspector)
        self.init(_object: try inspector.report().get())
    }

    public func transaction<Success>(_ function: () throws -> Success) throws -> Success {
        try interactive {
            _object.beginWriteTransaction()
            let success: Success
            do {
                success = try function()
            } catch {
                _object.cancelWriteTransaction()
                throw error
            }
            try _object.commitWriteTransaction()
            return success
        }
    }

    public func load<Aggregate>(_ aggregateType: Aggregate.Type, for id: Aggregate.Schematic.ID) -> Aggregate?
    where Aggregate: PersistentAggregate {
        interactive {
            guard let aggregateObject = aggregateType._aggregateObjectType.object(in: _object, forPrimaryKey: id._primitiveObject) else {
                return nil
            }
            return aggregateType.init(_aggregateObject: aggregateObject)
        }
    }

    public func query<Aggregate>(_ aggregateType: Aggregate.Type) -> Query<Aggregate> {
        interactive {
            let queryObject = aggregateType._aggregateObjectType.objects(
                in: _object,
                with: nil
                )
                as! _PersistentStorageQueryObject

            return .init(_storage: self, _aggregateType: aggregateType, _queryObject: queryObject)
        }
    }

    public func query<Aggregate, Predicate>(_ aggregateType: Aggregate.Type, where predicate: Predicate) -> Query<Aggregate>
    where Predicate: PersistentPredicate {
        interactive {
            let queryObject = aggregateType._aggregateObjectType.objects(
                in: _object,
                with: predicate._predicateObject
                )
                as! _PersistentStorageQueryObject

            return .init(_storage: self, _aggregateType: aggregateType, _queryObject: queryObject)
        }
    }

    public func save<Aggregate>(_ aggregate: Aggregate)
    where Aggregate: PersistentAggregate {
        interactive {
            if Aggregate._hasID {
                _object.addOrUpdate(aggregate._aggregateObject)
            } else {
                _object.add(aggregate._aggregateObject)
            }
        }
    }

    public func clear<Aggregate>(_ aggregateType: Aggregate.Type, for id: Aggregate.Schematic.ID)
    where Aggregate: PersistentAggregate {
        interactive {
            guard
                let aggregateObject = Aggregate._aggregateObjectType.object(
                    in: _object,
                    forPrimaryKey: id._primitiveObject
                )
                else {
                    return
            }
            _object.delete(aggregateObject)
        }
    }

    // Concealed

    typealias _Object = Realm.RLMRealm
}
