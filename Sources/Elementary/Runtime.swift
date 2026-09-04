internal import ElementaryCore

public final class Runtime {
    internal var coreRuntime: elemswift.Runtime

    public init(sampleRate: Double, blockSize: Int32) {
        coreRuntime = elemswift.Runtime(sampleRate, blockSize)
    }
    
    /**
     * Construct this runtime from a custom runtime.
     * This can be used to set up the runtime with c++ methods like
     * custom nodes, etc. and then construct a Swift Runtime
     */
    public init(_ runtime: consuming elemswift.Runtime) {
        coreRuntime = runtime
    }

    /// Processes one block of audio in place, using non-interleaved buffers.
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
