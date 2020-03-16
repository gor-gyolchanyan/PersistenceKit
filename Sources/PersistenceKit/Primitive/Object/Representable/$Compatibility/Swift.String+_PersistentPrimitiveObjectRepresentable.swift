//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Foundation.NSString

// Type: Swift.String

// Protocol: _PersistentPrimitiveObjectRepresentable

extension Swift.String: _PersistentPrimitiveObjectRepresentable {

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        ._string
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        guard let realmRawPrimitive = _primitiveObject as? Foundation.NSString else {
            return nil
        }
        self = realmRawPrimitive as Self
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        self as Foundation.NSString
    }
}
