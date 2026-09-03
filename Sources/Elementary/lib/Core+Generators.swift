internal import ElementaryCore

public extension El {
    static func sr() -> NodeRepr {
        return NodeRepr(elemswift.lib.sr())
    }

    static func time() -> NodeRepr {
        return NodeRepr(elemswift.lib.time())
    }

    static func phasor(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.phasor(rate.toElemNode()))
    }

    static func syncphasor(rate: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.syncphasor(rate.toElemNode(), reset.toElemNode()))
    }

    static func cycle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.cycle(rate.toElemNode()))
    }

    static func train(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.train(rate.toElemNode()))
    }

    static func saw(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.saw(rate.toElemNode()))
    }

    static func square(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.square(rate.toElemNode()))
    }

    static func triangle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.triangle(rate.toElemNode()))
    }

    static func blepsaw(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.blepsaw(rate.toElemNode()))
    }

    static func blepsquare(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.blepsquare(rate.toElemNode()))
    }

    static func bleptriangle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.bleptriangle(rate.toElemNode()))
    }

    static func noise(_ props: RandProps = .init()) -> NodeRepr {
        return NodeRepr(elemswift.lib.noise(props.toCore()))
    }
}
