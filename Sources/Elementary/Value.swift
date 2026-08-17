//
//  Value.swift
//  ElementarySwift
//
//  Created by Parker Nilson on 8/17/26.
//

//import ElementaryCore
//
///// A Swift-native representation of the dynamic, JSON-like values used to
///// describe node parameters in the underlying Elementary runtime.
//public indirect enum Value: Equatable {
//    case null
//    case bool(Bool)
//    case number(Double)
//    case string(String)
//    case array([Value])
//    case object([String: Value])
//}
//
////==============================================================================
//// Literal conveniences, so callers can write params like `["gain": 0.5]`
//// without spelling out `.number`/`.object` everywhere.
//extension Value: ExpressibleByNilLiteral {
//    public init(nilLiteral: ()) { self = .null }
//}
//
//extension Value: ExpressibleByBooleanLiteral {
//    public init(booleanLiteral value: Bool) { self = .bool(value) }
//}
//
//extension Value: ExpressibleByIntegerLiteral {
//    public init(integerLiteral value: Int) { self = .number(Double(value)) }
//}
//
//extension Value: ExpressibleByFloatLiteral {
//    public init(floatLiteral value: Double) { self = .number(value) }
//}
//
//extension Value: ExpressibleByStringLiteral {
//    public init(stringLiteral value: String) { self = .string(value) }
//}
//
//extension Value: ExpressibleByArrayLiteral {
//    public init(arrayLiteral elements: Value...) { self = .array(elements) }
//}
//
//extension Value: ExpressibleByDictionaryLiteral {
//    public init(dictionaryLiteral elements: (String, Value)...) {
//        self = .object(Dictionary(uniqueKeysWithValues: elements))
//    }
//}
//
////==============================================================================
//// Conversion to/from the underlying elem::js::Value representation
//extension Value {
//    // NOTE: elem::js::Value can also hold Undefined, Function, and Float32Array,
//    // none of which this type surfaces publicly. Any of those coming from the
//    // core are collapsed to `.null` rather than modeled here.
//    init(core: elem.js.Value) {
//        if core.isBool() {
//            self = .bool(Bool(core))
//        } else if core.isNumber() {
//            self = .number(Double(core))
//        } else if core.isString() {
//            self = .string(String(core))
//        } else if core.isArray() {
//            self = .array(core.getArray().map(Value.init(core:)))
//        } else if core.isObject() {
//            var object: [String: Value] = [:]
//            for entry in core.getObject() {
//                object[String(entry.first)] = Value(core: entry.second)
//            }
//            self = .object(object)
//        } else {
//            self = .null
//        }
//    }
//
//    func toCore() -> elem.js.Value {
//        switch self {
//        case .null:
//            return elem.js.Value(elem.js.Null())
//        case .bool(let value):
//            return elem.js.Value(value)
//        case .number(let value):
//            return elem.js.Value(value)
//        case .string(let value):
//            return elem.js.Value(std.string(value))
//        case .array(let values):
//            var array = elem.js.Array()
//            for value in values {
//                array.push_back(value.toCore())
//            }
//            return elem.js.Value(array)
//        case .object(let object):
//            var props = elem.js.Object()
//            for (key, value) in object {
//                props[std.string(key)] = value.toCore()
//            }
//            return elem.js.Value(props)
//        }
//    }
//}
