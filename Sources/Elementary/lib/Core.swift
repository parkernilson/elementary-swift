internal import ElementaryCore

// TODO: Is this efficient enough? I feel like we are going back and forth between layers,
// but maybe it is worth it for the expressiveness of the API it gives
// We should return GraphNode from any public functions, because ElementaryCore.GraphNodeSPtr is
// an internal type

/// Swift-native mirror of `ElementaryCore.MaxHoldProps`. The shim's own struct
/// exists only because Swift can't import the macro-generated C++ Props type
/// directly; this type is what callers actually see and construct.
public struct MaxHoldProps {
    public var key: String? = nil
    public var hold: Double? = nil

    public init(key: String? = nil, hold: Double? = nil) {
        self.key = key
        self.hold = hold
    }
}

internal extension MaxHoldProps {
    func toCore() -> ElementaryCore.MaxHoldProps {
        ElementaryCore.maxHoldProps(
            key.map { ElementaryCore.OptString(std.string($0)) } ?? ElementaryCore.OptString(),
            hold.map { ElementaryCore.OptDouble($0) } ?? ElementaryCore.OptDouble()
        )
    }
}

public enum El {

    // TODO: Add optional key param
    public static func constant(_ x: Double) -> GraphNode {
        return GraphNode(ElementaryCore.constant(x))
    }

    public static func cycle(rate: some NodeConvertible) -> GraphNode {
        return GraphNode(ElementaryCore.cycle(rate.toNode().node))
    }

    public static func maxhold(_ props: MaxHoldProps = .init(), x: some NodeConvertible, reset: some NodeConvertible) -> GraphNode {
        return GraphNode(ElementaryCore.maxhold(props.toCore(), x.toNode().node, reset.toNode().node))
    }
}
