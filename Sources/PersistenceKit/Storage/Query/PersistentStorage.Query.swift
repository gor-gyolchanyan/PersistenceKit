//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import protocol Combine.Publisher
import protocol Combine.Subscriber
import class Combine.PassthroughSubject
import class Foundation.NSPredicate
import class Realm.RLMResults
import class Realm.RLMNotificationToken
import class Realm.RLMCollectionChange

// Type: PersistentStorage.Query

extension PersistentStorage {

    public final class Query<Aggregate>
    where Aggregate: PersistentAggregate {

        // Topic: Main

        // Concealed

        init(_storage storage: PersistentStorage, _aggregateType aggregateType: Aggregate.Type, _queryObject queryObject: _PersistentStorageQueryObject) {
            _storage = storage
            _aggregateType = aggregateType
            _publisher = .init()
            _ordering = .init()
            _mapping = .init()
            _listeningToken = nil

            _startListening(_queryObject: queryObject)
        }

        deinit {
            _stopListening(_error: nil)
        }

        var _storage: PersistentStorage
        let _aggregateType: Aggregate.Type
        let _publisher: Combine.PassthroughSubject<Output, Failure>
        var _ordering: [Aggregate?]
        var _mapping: [Aggregate.Schematic.ID: Index]
        var _listeningToken: _ListeningToken?
    }
}

// Topic: Main

extension PersistentStorage.Query {

    // Exposed

    public struct Change {

        // Topic: Main

        // Exposed

        public let index: Index

        public let old: Aggregate?

        public let new: Aggregate?

        // Concealed

        init(_index index: Index, _old old: Aggregate?, _new new: Aggregate?) {
            self.index = index
            self.old = old
            self.new = new
        }
    }

    public func index(of id: Aggregate.Schematic.ID) -> Index? {
        _mapping[id]
    }

    // Concealed

    typealias _Object = Realm.RLMResults<_PersistentAggregateObject>
    typealias _Publisher = Combine.PassthroughSubject<Change, Error>
    typealias _ListeningToken = Realm.RLMNotificationToken

    func _startListening(_queryObject queryObject: _PersistentStorageQueryObject) {
        _listeningToken = queryObject.addNotificationBlock { [unowned self] query, change, error in
            if let error = error {
                return self._stopListening(_error: error)
            }
            guard let query = query else {
                return
            }
            if let change = change {
                return self._updateState(_query: query, _change: change)
            } else {
                return self._initializeState(_query: query)
            }
        }
    }

    func _stopListening(_error error: Error?) {
        if let error = error {
            _publisher.send(completion: .failure(error))
        } else {
            _publisher.send(completion: .finished)
        }
        _listeningToken?.invalidate()
        _listeningToken = nil
    }

    func _updateState(
        _query query: _PersistentStorageQueryObject,
        _change change: Realm.RLMCollectionChange
    ) {
        for index in change.insertions {
            let newObject = query.object(at: index.uintValue)
            let index = index.intValue
            let newAggregate = Aggregate(_aggregateObject: newObject)
            _ordering.insert(newAggregate, at: index)
            if Aggregate._hasID {
                if let newAggregate = newAggregate {
                    _mapping.updateValue(index, forKey: newAggregate._id)
                }
            }
            _publisher.send(.init(_index: index, _old: nil, _new: newAggregate))
        }
        for index in change.deletions.reversed() as ReversedCollection {
            let index = index.intValue
            let oldAggregate = _ordering.indices.contains(index) ? _ordering[index] : nil
            _ordering.remove(at: index)
            if Aggregate._hasID {
                if let oldAggregate = oldAggregate {
                    _mapping.removeValue(forKey: oldAggregate._id)
                }
            }
            _publisher.send(.init(_index: index, _old: oldAggregate, _new: nil))
        }
        for index in change.modifications {
            let newObject = query.object(at: index.uintValue)
            let index = index.intValue
            let oldAggregate = _ordering.indices.contains(index) ? _ordering[index] : nil
            let newAggregate = Aggregate(_aggregateObject: newObject)
            _ordering[index] = newAggregate
            _publisher.send(.init(_index: index, _old: oldAggregate, _new: newAggregate))
        }
    }

    func _initializeState(_query query: _PersistentStorageQueryObject) {
        _ordering.removeAll(keepingCapacity: true)
        for index in 0 ..< query.count {
            let newObject = query.object(at: index)
            let newAggregate = Aggregate(_aggregateObject: newObject)
            _ordering.append(newAggregate)
            let index = _ordering.index(before: _ordering.endIndex)
            if Aggregate._hasID {
                if let newAggregate = newAggregate {
                    _mapping.updateValue(index, forKey: newAggregate._id)
                }
            }
            _publisher.send(.init(_index: index, _old: nil, _new: newAggregate))
        }
    }
}

// Protocol: RandomAccessCollection

extension PersistentStorage.Query: RandomAccessCollection {

    // Exposed

    public typealias Index = Int

    public typealias Element = Aggregate?

    public var startIndex: Index {
        _ordering.startIndex
    }

    public var endIndex: Int {
        _ordering.endIndex
    }

    public var count: Int {
        _ordering.count
    }

    public subscript(_ index: Index) -> Aggregate? {
        _ordering[index]
    }
}

// Type: Combine.Publisher

extension PersistentStorage.Query: Combine.Publisher {

    // Exposed

    public typealias Output = Change

    public typealias Failure = Error

    public func receive<S>(subscriber: S)
    where S: Combine.Subscriber, S.Failure == Failure, S.Input == Output {
        _publisher.receive(subscriber: subscriber)
    }
}
