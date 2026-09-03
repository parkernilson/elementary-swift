internal import ElementaryCore

public final class NodeRepr {
    internal var core: elemswift.lib.NodeReprSPtr
    
    public init(kind: String, params: [String: Value], children: [NodeRepr]) {
        self.core = elem.NodeRepr.createNode(std.string(kind), params.toCore(), children.toCore())
    }
    
    internal init(_ node: elemswift.lib.NodeReprSPtr) {
        self.core = node
    }
}

internal extension Array where Element == NodeRepr {
    func toCore() -> elemswift.lib.NodeReprSPtrVector {
        var nodes = elemswift.lib.NodeReprSPtrVector()
        for child in self {
            elemswift.lib.appendGraphNode(&nodes, child.core)
        }
        return nodes
    }
}

