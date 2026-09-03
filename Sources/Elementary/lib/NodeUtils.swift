internal import ElementaryCore

/// Namespace for all node-constructor functions ported from the vendor
/// `elem::lib` C++ namespace, split across `Core+*.swift` files by DSP domain.
public enum El {}

public extension El {
    static func constant(_ x: Double, key: String?) -> NodeRepr {
        return NodeRepr(elem.lib.constant(x, key.toOptString()))
    }
    
    static func unpack(_ node: NodeRepr, numChannels: Int32) -> [NodeRepr] {
        return elem.lib.unpack(node.core, numChannels).map(NodeRepr.init)
    }
}

/// Anything that can appear as an argument typed `ElemNode` on the C++ side: a
/// literal constant or an existing node. A `Double` crosses as the literal
/// alternative of the underlying `ElemNode` variant (via `ElemNodeArg`)
/// instead of being materialized into a `const` `NodeRepr` first.
public protocol ElemNodeConvertible {
    func toElemNode() -> ElementaryCore.ElemNodeArg
}

extension Double: ElemNodeConvertible {
    public func toElemNode() -> ElementaryCore.ElemNodeArg { ElementaryCore.ElemNodeArg(self) }
}

extension NodeRepr: ElemNodeConvertible {
    public func toElemNode() -> ElementaryCore.ElemNodeArg { ElementaryCore.ElemNodeArg(core) }
}

internal extension Array where Element: ElemNodeConvertible {
    /// Builds a `std::vector<ElemNodeArg>` for functions like `scope` that
    /// take a variadic list of `ElemNode` children.
    func toElemNodeArgVector() -> ElementaryCore.ElemNodeArgVector {
        var vec = ElementaryCore.ElemNodeArgVector()
        for child in self {
            ElementaryCore.appendElemNodeArg(&vec, child.toElemNode())
        }
        return vec
    }
}
