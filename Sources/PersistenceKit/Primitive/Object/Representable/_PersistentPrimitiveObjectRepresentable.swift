//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: _PersistentPrimitiveObjectRepresentable

protocol _PersistentPrimitiveObjectRepresentable {

    // Topic: Main

    // Exposed

    static var _primitiveObjectVariant: _PersistentPrimitiveObjectVariant { get }

    init?(_primitiveObject: _PersistentPrimitiveObject)

    var _primitiveObject: _PersistentPrimitiveObject { get }
}
