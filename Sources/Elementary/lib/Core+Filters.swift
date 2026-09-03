internal import ElementaryCore

public struct MM1PProps {
    public var key: String? = nil
    public var mode: String? = nil

    public init(key: String? = nil, mode: String? = nil) {
        self.key = key
        self.mode = mode
    }
}

internal extension MM1PProps {
    func toCore() -> elemswift.lib.MM1PProps {
        elemswift.lib.mm1pProps(key.toOptString(), mode.toOptString())
    }
}

public struct SVFProps {
    public var key: String? = nil
    public var mode: String? = nil

    public init(key: String? = nil, mode: String? = nil) {
        self.key = key
        self.mode = mode
    }
}

internal extension SVFProps {
    func toCore() -> elemswift.lib.SVFProps {
        elemswift.lib.svfProps(key.toOptString(), mode.toOptString())
    }
}

public struct SVFShelfProps {
    public var key: String? = nil
    public var mode: String? = nil

    public init(key: String? = nil, mode: String? = nil) {
        self.key = key
        self.mode = mode
    }
}

internal extension SVFShelfProps {
    func toCore() -> elemswift.lib.SVFShelfProps {
        elemswift.lib.svfShelfProps(key.toOptString(), mode.toOptString())
    }
}

public extension El {
    static func pole(p: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.pole(p.toElemNode(), x.toElemNode()))
    }

    static func env(atkPole: some ElemNodeConvertible, relPole: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.env(atkPole.toElemNode(), relPole.toElemNode(), x.toElemNode()))
    }

    static func prewarp(fc: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.prewarp(fc.toElemNode()))
    }

    static func mm1p(_ props: MM1PProps = .init(), fc: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.mm1p(props.toCore(), fc.toElemNode(), x.toElemNode()))
    }

    static func svf(_ props: SVFProps = .init(), fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.svf(props.toCore(), fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func svfshelf(
        _ props: SVFShelfProps = .init(),
        fc: some ElemNodeConvertible,
        q: some ElemNodeConvertible,
        gainDecibels: some ElemNodeConvertible,
        x: some ElemNodeConvertible
    ) -> NodeRepr {
        NodeRepr(elemswift.lib.svfshelf(props.toCore(), fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func biquad(
        b0: some ElemNodeConvertible,
        b1: some ElemNodeConvertible,
        b2: some ElemNodeConvertible,
        a1: some ElemNodeConvertible,
        a2: some ElemNodeConvertible,
        x: some ElemNodeConvertible
    ) -> NodeRepr {
        return NodeRepr(elemswift.lib.biquad(
            b0.toElemNode(), b1.toElemNode(), b2.toElemNode(),
            a1.toElemNode(), a2.toElemNode(), x.toElemNode()
        ))
    }

    static func smooth(p: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.smooth(p.toElemNode(), x.toElemNode()))
    }

    static func sm(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.sm(x.toElemNode()))
    }

    static func zero(b0: some ElemNodeConvertible, b1: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.zero(b0.toElemNode(), b1.toElemNode(), x.toElemNode()))
    }

    static func dcblock(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.dcblock(x.toElemNode()))
    }

    static func df11(b0: some ElemNodeConvertible, b1: some ElemNodeConvertible, a1: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.df11(b0.toElemNode(), b1.toElemNode(), a1.toElemNode(), x.toElemNode()))
    }

    static func lowpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.lowpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func highpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.highpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func bandpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.bandpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func notch(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.notch(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func allpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.allpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func peak(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, gainDecibels: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.peak(fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func lowshelf(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, gainDecibels: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.lowshelf(fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func highshelf(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, gainDecibels: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.highshelf(fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func pink(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.pink(x.toElemNode()))
    }
}
