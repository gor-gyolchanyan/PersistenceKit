//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: KeyPath

// Protocol: _RawPersistentPredicateParameter

extension KeyPath: _RawPersistentPredicateParameter
where Root: PersistentAggregate, Value: PersistentPrimitive {

    // Exposed

    var _predicateParameterObject: _PersistentPredicateParameterObject {
        var inspector = _SchematicInspector(_keyPath: self)
        Root.schematic.report(to: &inspector)
        return .init(forKeyPath: inspector.report())
    }
}

// Protocol: PersistentPredicateParameter

extension KeyPath: PersistentPredicateParameter
where Root: PersistentAggregate, Value: PersistentPrimitive {

    // Exposed

    public typealias Primitive = Value

    public typealias Parameter = KeyPath<Root, Value>

    public var parameter: Parameter {
        self
    }
}
