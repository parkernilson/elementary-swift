internal import ElementaryCore

public extension El {
    // TODO: Add optional key param
    static func constant(_ x: Double) -> NodeRepr {
        return NodeRepr(ElementaryCore.constant(x))
    }
}
