internal import ElementaryCore

/// Swift-native mirror of `ElementaryCore.MaxHoldProps`. The shim's own struct
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
    func toCore() -> ElementaryCore.MaxHoldProps {
        ElementaryCore.maxHoldProps(
            key.toOptString(),
            hold.toOptDouble()
        )
    }
}

public enum El {
    public static func cycle(rate: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.cycle(rate.toElemNode()))
    }

    public static func maxhold(_ props: MaxHoldProps = .init(), x: some ElemNodeConvertible, reset: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(ElementaryCore.maxhold(props.toCore(), x.toElemNode(), reset.toElemNode()))
    }
}
