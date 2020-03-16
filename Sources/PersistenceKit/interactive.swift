//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import class Dispatch.DispatchQueue
import class Foundation.Thread

public func interactive<R>(call function: () throws -> R) rethrows -> R {
    if Thread.isMainThread {
        return try function()
    } else {
        return try DispatchQueue.main.sync {
            try function()
        }
    }
}
