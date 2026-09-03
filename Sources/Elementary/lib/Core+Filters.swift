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
    func toCore() -> ElementaryCore.MM1PProps {
        ElementaryCore.mm1pProps(key.toOptString(), mode.toOptString())
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
    func toCore() -> ElementaryCore.SVFProps {
        ElementaryCore.svfProps(key.toOptString(), mode.toOptString())
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
    func toCore() -> ElementaryCore.SVFShelfProps {
        ElementaryCore.svfShelfProps(key.toOptString(), mode.toOptString())
    }
}

public extension El {
    static func pole(p: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.pole(p.toElemNode(), x.toElemNode()))
    }

    static func env(atkPole: some ElemNodeConvertible, relPole: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.env(atkPole.toElemNode(), relPole.toElemNode(), x.toElemNode()))
    }

    static func prewarp(fc: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.prewarp(fc.toElemNode()))
    }

    static func mm1p(_ props: MM1PProps = .init(), fc: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.mm1p(props.toCore(), fc.toElemNode(), x.toElemNode()))
    }

    static func svf(_ props: SVFProps = .init(), fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(ElementaryCore.svf(props.toCore(), fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func svfshelf(
        _ props: SVFShelfProps = .init(),
        fc: some ElemNodeConvertible,
        q: some ElemNodeConvertible,
        gainDecibels: some ElemNodeConvertible,
        x: some ElemNodeConvertible
    ) -> NodeRepr {
        NodeRepr(ElementaryCore.svfshelf(props.toCore(), fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func biquad(
        b0: some ElemNodeConvertible,
        b1: some ElemNodeConvertible,
        b2: some ElemNodeConvertible,
        a1: some ElemNodeConvertible,
        a2: some ElemNodeConvertible,
        x: some ElemNodeConvertible
    ) -> NodeRepr {
        return NodeRepr(ElementaryCore.biquad(
            b0.toElemNode(), b1.toElemNode(), b2.toElemNode(),
            a1.toElemNode(), a2.toElemNode(), x.toElemNode()
        ))
    }

    static func smooth(p: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.smooth(p.toElemNode(), x.toElemNode()))
    }

    static func sm(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.sm(x.toElemNode()))
    }

    static func zero(b0: some ElemNodeConvertible, b1: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.zero(b0.toElemNode(), b1.toElemNode(), x.toElemNode()))
    }

    static func dcblock(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.dcblock(x.toElemNode()))
    }

    static func df11(b0: some ElemNodeConvertible, b1: some ElemNodeConvertible, a1: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.df11(b0.toElemNode(), b1.toElemNode(), a1.toElemNode(), x.toElemNode()))
    }

    static func lowpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.lowpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func highpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.highpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func bandpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.bandpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func notch(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.notch(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func allpass(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.allpass(fc.toElemNode(), q.toElemNode(), x.toElemNode()))
    }

    static func peak(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, gainDecibels: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.peak(fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func lowshelf(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, gainDecibels: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.lowshelf(fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func highshelf(fc: some ElemNodeConvertible, q: some ElemNodeConvertible, gainDecibels: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.highshelf(fc.toElemNode(), q.toElemNode(), gainDecibels.toElemNode(), x.toElemNode()))
    }

    static func pink(_ x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.pink(x.toElemNode()))
    }
}
