//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Foundation.NSNull

// Type: Swift.Optional

// Protocol: _PersistentPrimitiveObjectRepresentable

extension Swift.Optional: _PersistentPrimitiveObjectRepresentable
where Wrapped: PersistentPrimitive {

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        Wrapped._primitiveObjectVariant
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        if _primitiveObject is NSNull {
            self = .none
        } else if let wrapped = Wrapped(_primitiveObject: _primitiveObject) {
            self = .some(wrapped)
        } else {
            return nil
        }
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        switch self {
            case .none:
                return NSNull()
            case .some(let wrapped):
                return wrapped._primitiveObject
        }
    }
}
