internal import ElementaryCore

public struct TapProps {
    public var name: String
    public var key: String? = nil

    public init(name: String, key: String? = nil) {
        self.name = name
        self.key = key
    }
}

internal extension TapProps {
    func toCore() -> ElementaryCore.TapProps {
        ElementaryCore.tapProps(key.toOptString(), std.string(name))
    }
}

public extension El {
    static func tapIn(_ props: TapProps) -> NodeRepr {
        NodeRepr(ElementaryCore.tapIn(props.toCore()))
    }

    static func tapOut(_ props: TapProps, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.tapOut(props.toCore(), x.toElemNode()))
    }
}
