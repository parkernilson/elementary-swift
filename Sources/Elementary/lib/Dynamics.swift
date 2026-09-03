internal import ElementaryCore

/// Dynamics processors, matching vendor `elem::lib` Dynamics.h.
public extension El {
    static func compress(
        attackMs: some ElemNodeConvertible,
        releaseMs: some ElemNodeConvertible,
        threshold: some ElemNodeConvertible,
        ratio: some ElemNodeConvertible,
        sidechain: some ElemNodeConvertible,
        xn: some ElemNodeConvertible
    ) -> NodeRepr {
        return NodeRepr(elemswift.lib.compress(
            attackMs.toElemNode(), releaseMs.toElemNode(), threshold.toElemNode(),
            ratio.toElemNode(), sidechain.toElemNode(), xn.toElemNode()
        ))
    }

    static func skcompress(
        attackMs: some ElemNodeConvertible,
        releaseMs: some ElemNodeConvertible,
        threshold: some ElemNodeConvertible,
        ratio: some ElemNodeConvertible,
        kneeWidth: some ElemNodeConvertible,
        sidechain: some ElemNodeConvertible,
        xn: some ElemNodeConvertible
    ) -> NodeRepr {
        return NodeRepr(elemswift.lib.skcompress(
            attackMs.toElemNode(), releaseMs.toElemNode(), threshold.toElemNode(),
            ratio.toElemNode(), kneeWidth.toElemNode(), sidechain.toElemNode(), xn.toElemNode()
        ))
    }
}
