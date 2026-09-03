internal import ElementaryCore

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

    static func train(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.train(rate.toElemNode()))
    }

    static func saw(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.saw(rate.toElemNode()))
    }

    static func square(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.square(rate.toElemNode()))
    }

    static func triangle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.triangle(rate.toElemNode()))
    }

    static func blepsaw(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.blepsaw(rate.toElemNode()))
    }

    static func blepsquare(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.blepsquare(rate.toElemNode()))
    }

    static func bleptriangle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.bleptriangle(rate.toElemNode()))
    }

    static func noise(_ props: RandProps = .init()) -> NodeRepr {
        return NodeRepr(ElementaryCore.noise(props.toCore()))
    }
}
