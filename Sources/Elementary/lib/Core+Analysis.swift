internal import ElementaryCore

public struct MeterProps {
    public var key: String? = nil
    public var name: String? = nil

    public init(key: String? = nil, name: String? = nil) {
        self.key = key
        self.name = name
    }
}

internal extension MeterProps {
    func toCore() -> ElementaryCore.MeterProps {
        ElementaryCore.meterProps(key.toOptString(), name.toOptString())
    }
}

public struct SnapshotProps {
    public var key: String? = nil
    public var name: String? = nil

    public init(key: String? = nil, name: String? = nil) {
        self.key = key
        self.name = name
    }
}

internal extension SnapshotProps {
    func toCore() -> ElementaryCore.SnapshotProps {
        ElementaryCore.snapshotProps(key.toOptString(), name.toOptString())
    }
}

public struct ScopeProps {
    public var key: String? = nil
    public var name: String? = nil
    public var size: Double? = nil
    public var channels: Double? = nil

    public init(key: String? = nil, name: String? = nil, size: Double? = nil, channels: Double? = nil) {
        self.key = key
        self.name = name
        self.size = size
        self.channels = channels
    }
}

internal extension ScopeProps {
    func toCore() -> ElementaryCore.ScopeProps {
        ElementaryCore.scopeProps(key.toOptString(), name.toOptString(), size.toOptDouble(), channels.toOptDouble())
    }
}

public struct FFTProps {
    public var key: String? = nil
    public var name: String? = nil
    public var size: Double? = nil

    public init(key: String? = nil, name: String? = nil, size: Double? = nil) {
        self.key = key
        self.name = name
        self.size = size
    }
}

internal extension FFTProps {
    func toCore() -> ElementaryCore.FFTProps {
        ElementaryCore.fftProps(key.toOptString(), name.toOptString(), size.toOptDouble())
    }
}

public struct CaptureProps {
    public var key: String? = nil

    public init(key: String? = nil) {
        self.key = key
    }
}

internal extension CaptureProps {
    func toCore() -> ElementaryCore.CaptureProps {
        ElementaryCore.captureProps(key.toOptString())
    }
}

public extension El {
    static func meter(_ props: MeterProps = .init(), x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.meter(props.toCore(), x.toElemNode()))
    }

    static func snapshot(_ props: SnapshotProps = .init(), trigger: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.snapshot(props.toCore(), trigger.toElemNode(), x.toElemNode()))
    }

    static func scope<T: ElemNodeConvertible>(_ props: ScopeProps = .init(), children: [T]) -> NodeRepr {
        NodeRepr(ElementaryCore.scope(props.toCore(), children.toElemNodeArgVector()))
    }

    static func fft(_ props: FFTProps = .init(), x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.fft(props.toCore(), x.toElemNode()))
    }

    static func capture(_ props: CaptureProps = .init(), g: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.capture(props.toCore(), g.toElemNode(), x.toElemNode()))
    }
}
