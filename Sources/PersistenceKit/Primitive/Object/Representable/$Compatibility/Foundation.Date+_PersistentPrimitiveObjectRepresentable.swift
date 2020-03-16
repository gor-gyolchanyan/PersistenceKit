//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import struct Foundation.Date
import class Foundation.NSDate

// Type: Foundation.Date

// Protocol: _PersistentPrimitiveObjectRepresentable

extension Foundation.Date: _PersistentPrimitiveObjectRepresentable {

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        ._date
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        guard let realmRawPrimitive = _primitiveObject as? Foundation.NSDate else {
            return nil
        }
        self = realmRawPrimitive as Self
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        self as Foundation.NSDate
    }
}
