internal import ElementaryCore

/// Unit-conversion and small utility signal helpers, matching vendor
/// `elem::lib` Signals.h.
public extension El {
    static func ms2samps(_ t: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.ms2samps(t.toElemNode()))
    }

    static func tau2pole(_ t: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.tau2pole(t.toElemNode()))
    }

    static func db2gain(_ db: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.db2gain(db.toElemNode()))
    }

    static func select(_ g: some ElemNodeConvertible, _ a: some ElemNodeConvertible, _ b: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.select(g.toElemNode(), a.toElemNode(), b.toElemNode()))
    }

    static func gain2db(_ gain: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.gain2db(gain.toElemNode()))
    }

    static func hann(_ t: some ElemNodeConvertible) -> NodeRepr {
        return NodeRepr(elemswift.lib.hann(t.toElemNode()))
    }
}
