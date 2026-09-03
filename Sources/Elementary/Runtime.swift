internal import ElementaryCore

public final class Runtime {
    internal var coreRuntime: elemswift.Runtime

    public init(sampleRate: Double, blockSize: Int32) {
        coreRuntime = elemswift.Runtime(sampleRate, blockSize)
    }

    // TODO: Is it okay to expose this publicly? Does the importer have to 
    // depend on the ElementaryCore package explicitly to construct
    // ElementaryCore.Runtime?
    // This constructor should only be used when they import ElementaryCore
    // and use it to add custom node types
    // We could probably add a registerCustomNode method on the swift Runtime
    // and make it so that an app can have its own c++ layer where it imports
    // ElementaryCore.GraphNode (or even elem::GraphNode) and then pass their
    // custom node to it.
    // That way we wouldn't have to expose internal types on the public interface
    /**
     * Construct this runtime from a custom runtime.
     * This can be used to set up the runtime with c++ methods like
     * custom nodes, etc. and then construct a Swift Runtime
     */
    public init(_ runtime: consuming elemswift.Runtime) {
        coreRuntime = runtime
    }

    /// Processes one block of audio in place, using non-interleaved buffers.
    /// Real-time safe: forwards directly to the underlying C++ call with no
    /// allocation, so this is fine to call from a live audio render callback.
    /// TODO: Verify this works correctly and is safe
    public func process(
        outputChannelData: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>,
        numChannels: Int,
        numFrames: Int
    ) {
        coreRuntime.process(nil, 0, outputChannelData, numChannels, numFrames)
    }

    public func reset() {
        coreRuntime.reset()
    }
}
