//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

// Type: _PersistentPrimitiveObjectVariant

enum _PersistentPrimitiveObjectVariant {

    // Topic: Main

    // Exposed

    case _bool

    case _int

    case _float32

    case _float64

    case _date

    case _string

    case _data
}

// Topic: Main

extension _PersistentPrimitiveObjectVariant {

    // Exposed

    var _canBePrimaryKey: Bool {
        switch self {
            case ._bool, ._float32, ._float64, ._date, ._data:
                return false
            case ._int, ._string:
                return true
        }
    }

    var _canBeIndexed: Bool {
        switch self {
            case ._bool, ._int, ._date, ._string:
                return true
            case ._float32, ._float64, ._data:
                return false
        }
    }

    var _code: String {
        let rawCode: String
        switch self {
            case ._bool:
                rawCode = "NSNumber<RLMBool>"
            case ._int:
                rawCode = "NSNumber<RLMInt>"
            case ._float32:
                rawCode = "NSNumber<RLMFloat>"
            case ._float64:
                rawCode = "NSNumber<RLMDouble>"
            case ._date:
                rawCode = "NSDate"
            case ._string:
                rawCode = "NSString"
            case ._data:
                rawCode = "NSData"
        }
        return "@\"\(rawCode)\""
    }
}
