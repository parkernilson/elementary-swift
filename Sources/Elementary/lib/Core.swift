internal import ElementaryCore

// TODO: Is this efficient enough? I feel like we are going back and forth between layers,
// but maybe it is worth it for the expressiveness of the API it gives
// We should return GraphNode from any public functions, because ElementaryCore.GraphNodeSPtr is
// an internal type

public enum El {
    // TODO: Add optional key param
    public static func constant(_ x: Double) -> GraphNode {
        return GraphNode(ElementaryCore.constant(x))
    }

    public static func resolve(_ x: ElemNode) -> GraphNode {
        return switch(x) {
            case .num(let num): constant(num)
            case .node(let n): n
        }
    }

    public static func cycle(rate: ElemNode) -> GraphNode {
        return GraphNode(ElementaryCore.cycle(resolve(rate).node))
    }
}
