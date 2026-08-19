internal import ElementaryCore

struct GraphNode {
    public let kind: String
    public let params: [String: Value]
    public let children: [GraphNode]
    
    internal func build() -> elem.SymbolicGraphNode {
        return elem.SymbolicGraph.createNode(
            std.string(self.kind),
            self.params.toCore(),
            self.children.toCore()
        )
    }
}

internal extension Array where Element == GraphNode {
    func toCore() -> elem.GraphNodeVector {
        var nodes = elem.GraphNodeVector()
        for child in self {
            // TODO: Why does this use an ampersand? Is this correct?
            elem.appendGraphNode(&nodes, child.build())
        }
        return nodes
    }
}
