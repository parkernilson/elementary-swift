import ElementaryCore

/// A Swift-native representation of the dynamic, JSON-like values used to
/// describe node parameters in the underlying Elementary runtime.
public indirect enum Value: Equatable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([Value])
    case object([String: Value])
}

//==============================================================================
// Literal conveniences, so callers can write params like `["gain": 0.5]`
// without spelling out `.number`/`.object` everywhere.
extension Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) { self = .null }
}

extension Value: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) { self = .bool(value) }
}

extension Value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) { self = .number(Double(value)) }
}

extension Value: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) { self = .number(value) }
}

extension Value: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
}

extension Value: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) { self = .array(elements) }
}

extension Value: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Value)...) {
        self = .object(Dictionary(uniqueKeysWithValues: elements))
    }
}

internal extension Value {
    func toCore() -> elem.js.Value {
        switch self {
        case .null:
            return elem.js.Value(elem.js.Null())
        case .bool(let value):
            return elem.js.Value(value)
        case .number(let value):
            return elem.js.Value(value)
        case .string(let value):
            return elem.js.Value(std.string(value))
        case .array(let values):
            return elem.js.Value(values.toCore())
        case .object(let object):
            return elem.js.Value(object.toCore())
        }
    }
}

internal extension Dictionary where Key == String, Value == Elementary.Value {
    func toCore() -> elem.js.Object {
        var props = elem.js.Object()
        for (key, value) in self {
            props[std.string(key)] = value.toCore()
        }
        return props
    }
}

internal extension Array where Element == Elementary.Value {
    func toCore() -> elem.js.Array {
        var array = elem.js.Array()
        for value in self {
            // TODO: Optimization, move instead of copy
            array.push_back(value.toCore())
        }
        return array
    }
}


