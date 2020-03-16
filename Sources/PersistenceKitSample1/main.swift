//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import Foundation
import PersistenceKit

// There is a bug which causes nested `KeyPath`s inside `PersistenPredicate`s to fail.

RunLoop.main.run() // This is necessary for query updates to be delivered.
