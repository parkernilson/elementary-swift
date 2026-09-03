internal import ElementaryCore

public struct IdentityProps {
    public var key: String? = nil
    public var channel: Double? = nil

    public init(key: String? = nil, channel: Double? = nil) {
        self.key = key
        self.channel = channel
    }
}

internal extension IdentityProps {
    func toCore() -> elemswift.lib.IdentityProps {
        elemswift.lib.identityProps(key.toOptString(), channel.toOptDouble())
    }
}

/// Identity/passthrough, comparison, arithmetic, and boolean-logic node
/// constructors, matching vendor `elem::lib` Math.h.
public extension El {
    static func identity(_ props: IdentityProps = .init(), x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.identity(props.toCore(), x.toElemNode()))
    }

    static func identity<T: ElemNodeConvertible>(_ props: IdentityProps = .init(), children: [T] = []) -> NodeRepr {
        return NodeRepr(elemswift.lib.identity(props.toCore(), children.toElemNodeArgVector()))
    }

    // --- Unary nodes ---

    static func sin(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.sin(x.toElemNode()))
    }

    static func cos(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.cos(x.toElemNode()))
    }

    static func tan(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.tan(x.toElemNode()))
    }

    static func tanh(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.tanh(x.toElemNode()))
    }

    static func asinh(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.asinh(x.toElemNode()))
    }

    static func ln(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.ln(x.toElemNode()))
    }

    static func log(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.log(x.toElemNode()))
    }

    static func log2(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.log2(x.toElemNode()))
    }

    static func ceil(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.ceil(x.toElemNode()))
    }

    static func floor(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.floor(x.toElemNode()))
    }

    static func round(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.round(x.toElemNode()))
    }

    static func sqrt(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.sqrt(x.toElemNode()))
    }

    static func exp(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.exp(x.toElemNode()))
    }

    static func abs(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.abs(x.toElemNode()))
    }

    // --- Binary nodes ---

    static func le(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.le(a.toElemNode(), b.toElemNode()))
    }

    static func leq(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.leq(a.toElemNode(), b.toElemNode()))
    }

    static func ge(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.ge(a.toElemNode(), b.toElemNode()))
    }

    static func geq(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.geq(a.toElemNode(), b.toElemNode()))
    }

    static func pow(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.pow(a.toElemNode(), b.toElemNode()))
    }

    static func eq(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.eq(a.toElemNode(), b.toElemNode()))
    }

    // Named without the trailing underscore the C++ shim needs (`and`/`or`
    // aren't reserved words in Swift, only in C++).
    static func and(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.and_(a.toElemNode(), b.toElemNode()))
    }

    static func or(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.or_(a.toElemNode(), b.toElemNode()))
    }

    // --- Binary reducing nodes ---

    static func add<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.add(xs.toElemNodeArgVector()))
    }

    static func sub<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.sub(xs.toElemNodeArgVector()))
    }

    static func mul<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.mul(xs.toElemNodeArgVector()))
    }

    static func div<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.div(xs.toElemNodeArgVector()))
    }

    static func mod<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.mod(xs.toElemNodeArgVector()))
    }

    static func min<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.min(xs.toElemNodeArgVector()))
    }

    static func max<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(elemswift.lib.max(xs.toElemNodeArgVector()))
    }
}
