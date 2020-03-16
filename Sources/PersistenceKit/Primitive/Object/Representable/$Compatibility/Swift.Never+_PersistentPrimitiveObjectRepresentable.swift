//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Foundation.NSNull

// Type: Swift.Never

// Protocol: _PersistentPrimitiveObjectRepresentable

extension Swift.Never: _PersistentPrimitiveObjectRepresentable {

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant {
        ._int
    }

    init?(_primitiveObject: _PersistentPrimitiveObject) {
        return nil
    }

    var _primitiveObject: _PersistentPrimitiveObject {
        NSNull()
    }
}
