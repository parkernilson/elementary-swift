internal import ElementaryCore

public final class Runtime {
    private var coreRuntime: ElementaryCore.Runtime

    public init(sampleRate: Double, blockSize: Int32) {
        coreRuntime = ElementaryCore.Runtime(sampleRate, blockSize)
    }

    /**
     * Construct this runtime from a custom runtime.
     * This can be used to set up the runtime with c++ methods like
     * custom nodes, etc. and then construct a Swift Runtime
     */
    public init(_ runtime: consuming ElementaryCore.Runtime) {
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
