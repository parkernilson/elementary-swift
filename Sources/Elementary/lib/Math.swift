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
    func toCore() -> ElementaryCore.IdentityProps {
        ElementaryCore.identityProps(key.toOptString(), channel.toOptDouble())
    }
}

/// Identity/passthrough, comparison, arithmetic, and boolean-logic node
/// constructors, matching vendor `elem::lib` Math.h.
public extension El {
    static func identity(_ props: IdentityProps = .init(), x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.identity(props.toCore(), x.toElemNode()))
    }

    static func identity<T: ElemNodeConvertible>(_ props: IdentityProps = .init(), children: [T] = []) -> NodeRepr {
        return NodeRepr(ElementaryCore.identity(props.toCore(), children.toElemNodeArgVector()))
    }

    // --- Unary nodes ---

    static func sin(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.sin(x.toElemNode()))
    }

    static func cos(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.cos(x.toElemNode()))
    }

    static func tan(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.tan(x.toElemNode()))
    }

    static func tanh(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.tanh(x.toElemNode()))
    }

    static func asinh(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.asinh(x.toElemNode()))
    }

    static func ln(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.ln(x.toElemNode()))
    }

    static func log(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.log(x.toElemNode()))
    }

    static func log2(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.log2(x.toElemNode()))
    }

    static func ceil(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.ceil(x.toElemNode()))
    }

    static func floor(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.floor(x.toElemNode()))
    }

    static func round(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.round(x.toElemNode()))
    }

    static func sqrt(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.sqrt(x.toElemNode()))
    }

    static func exp(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.exp(x.toElemNode()))
    }

    static func abs(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.abs(x.toElemNode()))
    }

    // --- Binary nodes ---

    static func le(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.le(a.toElemNode(), b.toElemNode()))
    }

    static func leq(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.leq(a.toElemNode(), b.toElemNode()))
    }

    static func ge(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.ge(a.toElemNode(), b.toElemNode()))
    }

    static func geq(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.geq(a.toElemNode(), b.toElemNode()))
    }

    static func pow(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.pow(a.toElemNode(), b.toElemNode()))
    }

    static func eq(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.eq(a.toElemNode(), b.toElemNode()))
    }

    // Named without the trailing underscore the C++ shim needs (`and`/`or`
    // aren't reserved words in Swift, only in C++).
    static func and(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.and_(a.toElemNode(), b.toElemNode()))
    }

    static func or(_ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.or_(a.toElemNode(), b.toElemNode()))
    }

    // --- Binary reducing nodes ---

    static func add<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.add(xs.toElemNodeArgVector()))
    }

    static func sub<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.sub(xs.toElemNodeArgVector()))
    }

    static func mul<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.mul(xs.toElemNodeArgVector()))
    }

    static func div<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.div(xs.toElemNodeArgVector()))
    }

    static func mod<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.mod(xs.toElemNodeArgVector()))
    }

    static func min<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.min(xs.toElemNodeArgVector()))
    }

    static func max<T: ElemNodeConvertible>(_ xs: [T]) -> NodeRepr {
        return NodeRepr(ElementaryCore.max(xs.toElemNodeArgVector()))
    }
}
