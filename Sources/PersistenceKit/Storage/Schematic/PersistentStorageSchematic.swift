//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: PersistentStorageSchematic

public protocol PersistentStorageSchematic {

    // Topic: Main

    // Exposed

    var storageName: [String] { get }

    func report<Inspector>(to inspector: inout Inspector)
    where Inspector: PersistentStorageSchematicInspector
}
