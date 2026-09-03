internal import ElementaryCore

public class NodeRepr {
    internal var core: ElementaryCore.NodeReprSPtr
    
    public init(kind: String, params: [String: Value], children: [NodeRepr]) {
        self.core = elem.NodeRepr.createNode(std.string(kind), params.toCore(), children.toCore())
    }
    
    internal init(_ node: ElementaryCore.NodeReprSPtr) {
        self.core = node
    }
}

internal extension Array where Element == NodeRepr {
    func toCore() -> ElementaryCore.NodeReprSPtrVector {
        var nodes = ElementaryCore.NodeReprSPtrVector()
        for child in self {
            ElementaryCore.appendGraphNode(&nodes, child.core)
        }
        return nodes
    }
}

