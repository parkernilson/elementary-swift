internal import ElementaryCore

class GraphNode {
    internal var node: ElementaryCore.GraphNodeSPtr
    
    public init(kind: String, params: [String: Value], children: [GraphNode]) {
        self.node = elem.SymbolicGraph.createNode(std.string(kind), params.toCore(), children.toCore())
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
