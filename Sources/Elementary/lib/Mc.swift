internal import ElementaryCore

/// Multichannel ("mc.*") variants of the single-channel node constructors in
/// Core+Sequencing.swift, matching vendor `elem::lib` Mc.h. Each returns one
/// `NodeRepr` per channel instead of a single node, and is prefixed "mc" to
/// avoid overloading the single-channel names by Props type alone.

// TODO: I don't know if I like the mc name prefix. Maybe we need a nested enum

public struct MCSampleProps {
    public var path: String
    public var key: String? = nil
    public var mode: String? = nil
    public var startOffset: Double? = nil
    public var stopOffset: Double? = nil
    public var playbackRate: Double? = nil

    public init(
        path: String,
        key: String? = nil,
        mode: String? = nil,
        startOffset: Double? = nil,
        stopOffset: Double? = nil,
        playbackRate: Double? = nil
    ) {
        self.path = path
        self.key = key
        self.mode = mode
        self.startOffset = startOffset
        self.stopOffset = stopOffset
        self.playbackRate = playbackRate
    }
}

internal extension MCSampleProps {
    func toCore() -> elemswift.lib.MCSampleProps {
        elemswift.lib.mcSampleProps(
            key.toOptString(), std.string(path), mode.toOptString(),
            startOffset.toOptDouble(), stopOffset.toOptDouble(), playbackRate.toOptDouble()
        )
    }
}

public struct MCSampleSeqProps {
    public var path: String
    public var seq: [ValueTimeSeqStep]
    public var duration: Double
    public var key: String? = nil

    public init(path: String, seq: [ValueTimeSeqStep], duration: Double, key: String? = nil) {
        self.path = path
        self.seq = seq
        self.duration = duration
        self.key = key
    }
}

internal extension MCSampleSeqProps {
    func toCore() -> elemswift.lib.MCSampleSeqProps {
        elemswift.lib.mcSampleSeqProps(key.toOptString(), std.string(path), seq.toCore(), duration)
    }
}

public struct MCSampleSeq2Props {
    public var path: String
    public var seq: [ValueTimeSeqStep]
    public var duration: Double
    public var key: String? = nil
    public var stretch: Double? = nil
    public var shift: Double? = nil

    public init(
        path: String,
        seq: [ValueTimeSeqStep],
        duration: Double,
        key: String? = nil,
        stretch: Double? = nil,
        shift: Double? = nil
    ) {
        self.path = path
        self.seq = seq
        self.duration = duration
        self.key = key
        self.stretch = stretch
        self.shift = shift
    }
}

internal extension MCSampleSeq2Props {
    func toCore() -> elemswift.lib.MCSampleSeq2Props {
        elemswift.lib.mcSampleSeq2Props(key.toOptString(), std.string(path), seq.toCore(), duration, stretch.toOptDouble(), shift.toOptDouble())
    }
}

public struct MCTableProps {
    public var path: String
    public var key: String? = nil

    public init(path: String, key: String? = nil) {
        self.path = path
        self.key = key
    }
}

internal extension MCTableProps {
    func toCore() -> elemswift.lib.MCTableProps {
        elemswift.lib.mcTableProps(key.toOptString(), std.string(path))
    }
}

public struct MCCaptureProps {
    public var name: String? = nil

    public init(name: String? = nil) {
        self.name = name
    }
}

internal extension MCCaptureProps {
    func toCore() -> elemswift.lib.MCCaptureProps {
        elemswift.lib.mcCaptureProps(name.toOptString())
    }
}

public extension El {
    static func mcSample(_ props: MCSampleProps, channels: Int, gate: some ElemNodeConvertible) -> [NodeRepr] {
        return elemswift.lib.mcSample(props.toCore(), Double(channels), gate.toElemNode()).map(NodeRepr.init)
    }

    static func mcSampleSeq(_ props: MCSampleSeqProps, channels: Int, time: some ElemNodeConvertible) -> [NodeRepr] {
        return elemswift.lib.mcSampleSeq(props.toCore(), Double(channels), time.toElemNode()).map(NodeRepr.init)
    }

    static func mcSampleSeq2(_ props: MCSampleSeq2Props, channels: Int, time: some ElemNodeConvertible) -> [NodeRepr] {
        return elemswift.lib.mcSampleSeq2(props.toCore(), Double(channels), time.toElemNode()).map(NodeRepr.init)
    }

    static func mcTable(_ props: MCTableProps, channels: Int, t: some ElemNodeConvertible) -> [NodeRepr] {
        return elemswift.lib.mcTable(props.toCore(), Double(channels), t.toElemNode()).map(NodeRepr.init)
    }

    static func mcCapture<T: ElemNodeConvertible>(_ props: MCCaptureProps = .init(), channels: Int, g: some ElemNodeConvertible, args: [T] = []) -> [NodeRepr] {
        return elemswift.lib.mcCapture(props.toCore(), Double(channels), g.toElemNode(), args.toElemNodeArgVector()).map(NodeRepr.init)
    }
}
