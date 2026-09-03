internal import ElementaryCore

/// Envelope generators, matching vendor `elem::lib` Envelopes.h.
public extension El {
    static func adsr(
        attackSec: some ElemNodeConvertible,
        decaySec: some ElemNodeConvertible,
        sustain: some ElemNodeConvertible,
        releaseSec: some ElemNodeConvertible,
        gate: some ElemNodeConvertible
    ) -> NodeRepr {
        return NodeRepr(elemswift.lib.adsr(
            attackSec.toElemNode(), decaySec.toElemNode(), sustain.toElemNode(),
            releaseSec.toElemNode(), gate.toElemNode()
        ))
    }
}
