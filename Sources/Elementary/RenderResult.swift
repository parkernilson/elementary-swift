internal import ElementaryCore

/// The outcome of a graph mutation (`Renderer.renderGraph` or a ref's setter),
/// mirroring the underlying `elem::RenderResult` and its `elem::ReturnCode` values.
public struct RenderResult {
    public enum ReturnCode: Int32 {
        case ok = 0
        case unknownNodeType = 1
        case nodeNotFound = 2
        case nodeAlreadyExists = 3
        case nodeTypeAlreadyExists = 4
        case invalidPropertyType = 5
        case invalidPropertyValue = 6
        case invariantViolation = 7
        case invalidInstructionFormat = 8
        case runtimeExpired = 9

        /// A code reported by the underlying runtime that this enum doesn't (yet) recognize.
        case unrecognized = -1

        public var description: String {
            self == .unrecognized
                ? "Return code not recognized"
                : String(elem.ReturnCode.describe(rawValue))
        }
    }

    public let returnCode: ReturnCode
    public let nodesAdded: Int32
    public let edgesAdded: Int32
    public let propsWritten: Int32
    public let elapsedTimeMs: Double

    public var isOk: Bool { returnCode == .ok }

    internal init(fromCore core: elem.RenderResult) {
        self.returnCode = ReturnCode(rawValue: Int32(core.result)) ?? .unrecognized
        self.nodesAdded = core.nodesAdded
        self.edgesAdded = core.edgesAdded
        self.propsWritten = core.propsWritten
        self.elapsedTimeMs = core.elapsedTimeMs
    }
}
