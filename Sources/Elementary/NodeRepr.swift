internal import ElementaryCore

/// Anything that can appear as a node function's input: a literal constant or
/// an existing node. Conforming types resolve themselves to a `NodeRepr`, so
/// call sites can pass `440.0` or a `NodeRepr` interchangeably without wrapping.
public protocol NodeConvertible {
    func toNode() -> NodeRepr
}

extension Double: NodeConvertible {
    public func toNode() -> NodeRepr { El.constant(self) }
}

extension NodeRepr: NodeConvertible {
    public func toNode() -> NodeRepr { self }
}

public class NodeRepr {
    internal var node: ElementaryCore.NodeReprSPtr
    
    public init(kind: String, params: [String: Value], children: [NodeRepr]) {
        self.node = elem.NodeRepr.createNode(std.string(kind), params.toCore(), children.toCore())
    }
    
    // TODO: Do I need to do consuming here?
    internal init(_ node: ElementaryCore.NodeReprSPtr) {
        self.node = node
    }
}

internal extension Array where Element == NodeRepr {
    func toCore() -> ElementaryCore.NodeReprSPtrVector {
        var nodes = ElementaryCore.NodeReprSPtrVector()
        for child in self {
            // TODO: Why does this use an ampersand? Is this correct?
            ElementaryCore.appendGraphNode(&nodes, child.node)
        }
        return nodes
    }
}
