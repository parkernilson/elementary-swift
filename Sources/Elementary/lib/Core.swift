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

    // TODO: These helpers are for people who want to create their own compositions in swift
    // however we may be duplicating some functionality (like resolving the variant ElemNode type).
    // However, for all the stdlib helpers we can just use the underlying implementation.
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
