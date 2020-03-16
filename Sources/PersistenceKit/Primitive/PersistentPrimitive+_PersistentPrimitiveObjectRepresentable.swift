//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentPrimitive

// Protocol: _PersistentPrimitiveObjectRepresentable

extension PersistentPrimitive {

    // Concealed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        if let instanceType = Self.self as? _PersistentPrimitiveObjectRepresentable.Type {
            return instanceType._primitiveObjectVariant
        } else {
            return Primitive._primitiveObjectVariant
        }
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        if let instanceType = Self.self as? _PersistentPrimitiveObjectRepresentable.Type {
            guard
                let instance = instanceType.init(_primitiveObject: _primitiveObject)
            else {
                return nil
            }
            self = instance as! Self
        } else {
            guard
                let primitive = Primitive(_primitiveObject: _primitiveObject)
            else {
                return nil
            }
            self.init(primitive: primitive)
        }
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        if let instance = self as? _PersistentPrimitiveObjectRepresentable {
            return instance._primitiveObject
        } else {
            return primitive._primitiveObject
        }
    }
}
