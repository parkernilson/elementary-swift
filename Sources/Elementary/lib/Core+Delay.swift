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
    func toCore() -> ElementaryCore.DelayProps {
        ElementaryCore.delayProps(key.toOptString(), size)
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
    func toCore() -> ElementaryCore.SDelayProps {
        ElementaryCore.sdelayProps(key.toOptString(), size)
    }
}

/// Delay-line primitives: pure time-domain buffering, distinct from the
/// spectral-shaping filters in Core+Filters.swift.
public extension El {
    static func z(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.z(x.toElemNode()))
    }

    static func delay(_ props: DelayProps, len: some ElemNodeConvertible, fb: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.delay(props.toCore(), len.toElemNode(), fb.toElemNode(), x.toElemNode()))
    }

    static func sdelay(_ props: SDelayProps, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.sdelay(props.toCore(), x.toElemNode()))
    }
}
