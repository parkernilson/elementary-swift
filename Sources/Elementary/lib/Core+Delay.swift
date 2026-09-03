internal import ElementaryCore

public struct DelayProps {
    public var size: Double
    public var key: String? = nil

    public init(size: Double, key: String? = nil) {
        self.size = size
        self.key = key
    }
}

internal extension DelayProps {
    func toCore() -> elemswift.lib.DelayProps {
        elemswift.lib.delayProps(key.toOptString(), size)
    }
}

public struct SDelayProps {
    public var size: Double
    public var key: String? = nil

    public init(size: Double, key: String? = nil) {
        self.size = size
        self.key = key
    }
}

internal extension SDelayProps {
    func toCore() -> elemswift.lib.SDelayProps {
        elemswift.lib.sdelayProps(key.toOptString(), size)
    }
}

public extension El {
    static func z(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.z(x.toElemNode()))
    }

    static func delay(_ props: DelayProps, len: some ElemNodeConvertible, fb: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.delay(props.toCore(), len.toElemNode(), fb.toElemNode(), x.toElemNode()))
    }

    static func sdelay(_ props: SDelayProps, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.sdelay(props.toCore(), x.toElemNode()))
    }
}
