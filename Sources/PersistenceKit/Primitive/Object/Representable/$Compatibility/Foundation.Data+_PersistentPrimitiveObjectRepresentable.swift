//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import struct Foundation.Data
import class Foundation.NSData

// Type: Foundation.Data

// Protocol: _PersistentPrimitiveObjectRepresentable

extension Foundation.Data: _PersistentPrimitiveObjectRepresentable {

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        ._data
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        guard let realmRawPrimitive = _primitiveObject as? Foundation.NSData else {
            return nil
        }
        self = realmRawPrimitive as Self
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        self as Foundation.NSData
    }
}
