internal import ElementaryCore

/// Swift-native mirror of `elemswift.lib.MaxHoldProps`. The shim's own struct
/// exists only because Swift can't import the macro-generated C++ Props type
/// directly since it contains templated types; this type is what callers actually see and construct.
public struct MaxHoldProps {
    public var key: String? = nil
    public var hold: Double? = nil

    public init(key: String? = nil, hold: Double? = nil) {
        self.key = key
        self.hold = hold
    }
}

internal extension MaxHoldProps {
    func toCore() -> elemswift.lib.MaxHoldProps {
        elemswift.lib.maxHoldProps(
            key.toOptString(),
            hold.toOptDouble()
        )
    }
}

public struct OnceProps {
    public var key: String? = nil
    public var arm: Bool? = nil

    public init(key: String? = nil, arm: Bool? = nil) {
        self.key = key
        self.arm = arm
    }
}

internal extension OnceProps {
    func toCore() -> elemswift.lib.OnceProps {
        elemswift.lib.onceProps(key.toOptString(), arm.toOptBool())
    }
}

public struct RandProps {
    public var key: String? = nil
    public var seed: Double? = nil

    public init(key: String? = nil, seed: Double? = nil) {
        self.key = key
        self.seed = seed
    }
}

internal extension RandProps {
    func toCore() -> elemswift.lib.RandProps {
        elemswift.lib.randProps(key.toOptString(), seed.toOptDouble())
    }
}

public struct MetroProps {
    public var key: String? = nil
    public var name: String? = nil
    public var interval: Double? = nil

    public init(key: String? = nil, name: String? = nil, interval: Double? = nil) {
        self.key = key
        self.name = name
        self.interval = interval
    }
}

internal extension MetroProps {
    func toCore() -> elemswift.lib.MetroProps {
        elemswift.lib.metroProps(key.toOptString(), name.toOptString(), interval.toOptDouble())
    }
}

public extension El {
    static func counter(gate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.counter(gate.toElemNode()))
    }

    static func accum(xn: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.accum(xn.toElemNode(), reset.toElemNode()))
    }

    static func latch(t: some ElemNodeConvertible, x: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.latch(t.toElemNode(), x.toElemNode()))
    }

    static func maxhold(_ props: MaxHoldProps = .init(), x: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.maxhold(props.toCore(), x.toElemNode(), reset.toElemNode()))
    }

    static func once(_ props: OnceProps = .init(), x: some ElemNodeConvertible) -> NodeRepr {
        NodeRepr(elemswift.lib.once(props.toCore(), x.toElemNode()))
    }

    static func rand(_ props: RandProps = .init()) -> NodeRepr {
        NodeRepr(elemswift.lib.rand(props.toCore()))
    }

    static func metro(_ props: MetroProps = .init()) -> NodeRepr {
        NodeRepr(elemswift.lib.metro(props.toCore()))
    }
}
