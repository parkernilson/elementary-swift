internal import ElementaryCore

public struct SampleProps {
    public var path: String
    public var key: String? = nil
    public var mode: String? = nil
    public var startOffset: Double? = nil
    public var stopOffset: Double? = nil

    public init(path: String, key: String? = nil, mode: String? = nil, startOffset: Double? = nil, stopOffset: Double? = nil) {
        self.path = path
        self.key = key
        self.mode = mode
        self.startOffset = startOffset
        self.stopOffset = stopOffset
    }
}

internal extension SampleProps {
    func toCore() -> elemswift.lib.SampleProps {
        elemswift.lib.sampleProps(key.toOptString(), std.string(path), mode.toOptString(), startOffset.toOptDouble(), stopOffset.toOptDouble())
    }
}

public struct TableProps {
    public var path: String
    public var key: String? = nil

    public init(path: String, key: String? = nil) {
        self.path = path
        self.key = key
    }
}

internal extension TableProps {
    func toCore() -> elemswift.lib.TableProps {
        elemswift.lib.tableProps(key.toOptString(), std.string(path))
    }
}

public struct ConvolveProps {
    public var path: String
    public var key: String? = nil

    public init(path: String, key: String? = nil) {
        self.path = path
        self.key = key
    }
}

internal extension ConvolveProps {
    func toCore() -> elemswift.lib.ConvolveProps {
        elemswift.lib.convolveProps(key.toOptString(), std.string(path))
    }
}

public struct SeqProps {
    public var seq: [Value]
    public var key: String? = nil
    public var offset: Double? = nil
    public var hold: Bool? = nil
    public var loop: Bool? = nil

    public init(seq: [Value], key: String? = nil, offset: Double? = nil, hold: Bool? = nil, loop: Bool? = nil) {
        self.seq = seq
        self.key = key
        self.offset = offset
        self.hold = hold
        self.loop = loop
    }
}

internal extension SeqProps {
    func toCore() -> elemswift.lib.SeqProps {
        elemswift.lib.seqProps(key.toOptString(), seq.toCore(), offset.toOptDouble(), hold.toOptBool(), loop.toOptBool())
    }
}

public struct SparSeqStep {
    public var value: Double
    public var tickTime: Double

    public init(value: Double, tickTime: Double) {
        self.value = value
        self.tickTime = tickTime
    }
}

internal extension SparSeqStep {
    func toCore() -> elemswift.lib.SparSeqStep {
        elemswift.lib.sparSeqStep(value, tickTime)
    }
}

internal extension Array where Element == SparSeqStep {
    func toCore() -> elemswift.lib.SparSeqStepVector {
        var vec = elemswift.lib.SparSeqStepVector()
        for step in self {
            vec.push_back(step.toCore())
        }
        return vec
    }
}

public protocol SparSeqLoopConvertible {
    func toSparSeqLoopArg() -> elemswift.lib.SparSeqLoopArg
}

extension Bool: SparSeqLoopConvertible {
    public func toSparSeqLoopArg() -> elemswift.lib.SparSeqLoopArg { .init(self) }
}

extension Array: SparSeqLoopConvertible where Element == Value {
    public func toSparSeqLoopArg() -> elemswift.lib.SparSeqLoopArg { .init(self.toCore()) }
}

public struct SparSeqProps {
    public var seq: [SparSeqStep]
    public var key: String? = nil
    public var offset: Double? = nil
    public var loop: (any SparSeqLoopConvertible)? = nil
    public var interpolate: Double? = nil
    public var tickInterval: Double? = nil

    public init(
        seq: [SparSeqStep],
        key: String? = nil,
        offset: Double? = nil,
        loop: (any SparSeqLoopConvertible)? = nil,
        interpolate: Double? = nil,
        tickInterval: Double? = nil
    ) {
        self.seq = seq
        self.key = key
        self.offset = offset
        self.loop = loop
        self.interpolate = interpolate
        self.tickInterval = tickInterval
    }
}

internal extension SparSeqProps {
    func toCore() -> elemswift.lib.SparSeqProps {
        elemswift.lib.sparSeqProps(
            key.toOptString(),
            seq.toCore(),
            offset.toOptDouble(),
            loop.map { elemswift.lib.OptSparSeqLoopArg($0.toSparSeqLoopArg()) } ?? elemswift.lib.OptSparSeqLoopArg(),
            interpolate.toOptDouble(),
            tickInterval.toOptDouble()
        )
    }
}

public struct ValueTimeSeqStep {
    public var value: Double
    public var time: Double

    public init(value: Double, time: Double) {
        self.value = value
        self.time = time
    }
}

internal extension ValueTimeSeqStep {
    func toCore() -> elemswift.lib.ValueTimeSeqStep {
        elemswift.lib.valueTimeSeqStep(value, time)
    }
}

internal extension Array where Element == ValueTimeSeqStep {
    func toCore() -> elemswift.lib.ValueTimeSeqStepVector {
        var vec = elemswift.lib.ValueTimeSeqStepVector()
        for step in self {
            vec.push_back(step.toCore())
        }
        return vec
    }
}

public struct SparSeq2Props {
    public var seq: [ValueTimeSeqStep]
    public var key: String? = nil

    public init(seq: [ValueTimeSeqStep], key: String? = nil) {
        self.seq = seq
        self.key = key
    }
}

internal extension SparSeq2Props {
    func toCore() -> elemswift.lib.SparSeq2Props {
        elemswift.lib.sparSeq2Props(key.toOptString(), seq.toCore())
    }
}

public struct SampleSeqProps {
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

internal extension SampleSeqProps {
    func toCore() -> elemswift.lib.SampleSeqProps {
        elemswift.lib.sampleSeqProps(key.toOptString(), std.string(path), seq.toCore(), duration)
    }
}

public struct SampleSeq2Props {
    public var path: String
    public var seq: [ValueTimeSeqStep]
    public var duration: Double
    public var key: String? = nil
    public var stretch: Double? = nil
    public var shift: Double? = nil

    public init(path: String, seq: [ValueTimeSeqStep], duration: Double, key: String? = nil, stretch: Double? = nil, shift: Double? = nil) {
        self.path = path
        self.seq = seq
        self.duration = duration
        self.key = key
        self.stretch = stretch
        self.shift = shift
    }
}

internal extension SampleSeq2Props {
    func toCore() -> elemswift.lib.SampleSeq2Props {
        elemswift.lib.sampleSeq2Props(key.toOptString(), std.string(path), seq.toCore(), duration, stretch.toOptDouble(), shift.toOptDouble())
    }
}

public extension El {
    static func sample(_ props: SampleProps, trigger: some ElemNodeConvertible, rate: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.sample(props.toCore(), trigger.toElemNode(), rate.toElemNode()))
    }

    static func table(_ props: TableProps, t: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.table(props.toCore(), t.toElemNode()))
    }

    static func convolve(_ props: ConvolveProps, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.convolve(props.toCore(), x.toElemNode()))
    }

    static func seq(_ props: SeqProps, trigger: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.seq(props.toCore(), trigger.toElemNode(), reset.toElemNode()))
    }

    static func seq2(_ props: SeqProps, trigger: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.seq2(props.toCore(), trigger.toElemNode(), reset.toElemNode()))
    }

    static func sparseq(_ props: SparSeqProps, trigger: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.sparseq(props.toCore(), trigger.toElemNode(), reset.toElemNode()))
    }

    static func sparseq2(_ props: SparSeq2Props, time: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.sparseq2(props.toCore(), time.toElemNode()))
    }

    static func sampleseq(_ props: SampleSeqProps, time: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.sampleseq(props.toCore(), time.toElemNode()))
    }

    static func sampleseq2(_ props: SampleSeq2Props, time: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.sampleseq2(props.toCore(), time.toElemNode()))
    }
}
