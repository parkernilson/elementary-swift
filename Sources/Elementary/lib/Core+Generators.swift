internal import ElementaryCore

/// Pure signal sources: no notion of an input signal to transform, and no
/// Props struct - each of these originates a new signal from scratch.
public extension El {
    static func sr() -> NodeRepr {
        return NodeRepr(ElementaryCore.sr())
    }

    static func time() -> NodeRepr {
        return NodeRepr(ElementaryCore.time())
    }

    static func phasor(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.phasor(rate.toElemNode()))
    }

    static func syncphasor(rate: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.syncphasor(rate.toElemNode(), reset.toElemNode()))
    }

    static func cycle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.cycle(rate.toElemNode()))
    }
}
