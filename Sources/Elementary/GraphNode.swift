internal import ElementaryCore

/// Anything that can appear as a node function's input: a literal constant or
/// an existing node. Conforming types resolve themselves to a `GraphNode`, so
/// call sites can pass `440` or a `GraphNode` interchangeably without wrapping.
public protocol NodeConvertible {
    func toNode() -> GraphNode
}

extension Double: NodeConvertible {
    public func toNode() -> GraphNode { El.constant(self) }
}

extension GraphNode: NodeConvertible {
    public func toNode() -> GraphNode { self }
}

public class GraphNode {
    internal var node: ElementaryCore.GraphNodeSPtr
    
    public init(kind: String, params: [String: Value], children: [GraphNode]) {
        self.node = elem.SymbolicGraph.createNode(std.string(kind), params.toCore(), children.toCore())
    }
    
    // TODO: Do I need to do consuming here?
    internal init(_ node: ElementaryCore.GraphNodeSPtr) {
        self.node = node
    }
}

internal extension Array where Element == GraphNode {
    func toCore() -> ElementaryCore.GraphNodeSPtrVector {
        var nodes = ElementaryCore.GraphNodeSPtrVector()
        for child in self {
            // TODO: Why does this use an ampersand? Is this correct?
            ElementaryCore.appendGraphNode(&nodes, child.node)
        }
        return nodes
    }
}
