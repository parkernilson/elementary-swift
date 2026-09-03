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
    func toCore() -> elemswift.lib.TapProps {
        elemswift.lib.tapProps(key.toOptString(), std.string(name))
    }
}

public extension El {
    static func tapIn(_ props: TapProps) -> NodeRepr {
        NodeRepr(elemswift.lib.tapIn(props.toCore()))
    }

    static func tapOut(_ props: TapProps, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.tapOut(props.toCore(), x.toElemNode()))
    }
}
