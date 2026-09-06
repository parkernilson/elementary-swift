internal import ElementaryCore

public final class Runtime {
    internal var coreRuntime: elemswift.RuntimeRef

    public init(sampleRate: Double, blockSize: Int32) {
        coreRuntime = elemswift.makeRuntime(sampleRate, blockSize)
    }

    /**
     * Construct this runtime from a custom runtime.
     * This can be used to set up the runtime with c++ methods like
     * custom nodes, etc. and then construct a Swift Runtime
     */
    public init(_ runtime: elemswift.RuntimeRef) {
        coreRuntime = runtime
    }

    /// Processes one block of audio in place, using non-interleaved buffers.
    public func process(
        outputChannelData: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>,
        numChannels: Int,
        numFrames: Int
    ) {
        elemswift.process(coreRuntime, nil, 0, outputChannelData, numChannels, numFrames)
    }

    public func reset() {
        elemswift.reset(coreRuntime)
    }

    public func processQueuedEvents(eventCallback: @escaping (_ name: String, _ payload: Value) -> Void) -> Void {
        // TODO: Optimization, currently the event name and payload are copied out into the Swift layer
        // we may be able to find a way to call the reference returning methods on elem.js.Value and
        // instead provide a Swift friendly const view into them without copying into Swift.
        elemswift.processQueuedEvents(coreRuntime, elemswift.ProcessEventsCallbackFn { eventName, eventPayload in
            eventCallback(String(eventName), Value(fromCore: eventPayload))
        })
    }

    /// Releases unused graph nodes, returning the ids of the nodes that were cleared.
    @discardableResult
    public func gc() -> [Int32] {
        Array(elemswift.gc(coreRuntime))
    }

    /// Registers an already-decoded audio buffer as a shared resource under `name`.
    ///
    /// This is `internal` — app code should use `addAudioResource(name:fileURL:)` instead.
    /// Returns `false` if `name` is already registered (existing entries are never overwritten,
    /// since an active graph node may hold a reference to them).
    @discardableResult
    internal func addSharedResource(name: String, resource: elem.AudioBufferResource) -> Bool {
        elemswift.addSharedResource(coreRuntime, std.string(name), resource)
    }

    /// Removes shared resources that are no longer referenced by any active graph node.
    ///
    /// Must be called from the same non-realtime thread that drives graph mutation/rendering,
    /// since the underlying shared resource map is not synchronized.
    public func pruneSharedResources() {
        elemswift.pruneSharedResources(coreRuntime)
    }

    /// Returns the names of all currently registered shared resources.
    public func sharedResourceKeys() -> [String] {
        elemswift.getSharedResourceMapKeys(coreRuntime).map { String($0) }
    }
}
