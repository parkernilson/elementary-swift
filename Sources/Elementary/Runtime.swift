import ElementaryCore

public final class Runtime {
    private var coreRuntime: ElementaryCore.Runtime

    public init(sampleRate: Double, blockSize: Int32) {
        coreRuntime = ElementaryCore.Runtime(sampleRate, blockSize)
    }

    /// Processes one block of audio in place, using non-interleaved buffers.
    public func process(output: inout [[Float]], numFrames: Int) {
        let numChannels = output.count
        output.withUnsafeMutableBufferPointer { channels in
            withChannelPointers(channels, index: 0, numChannels: numChannels, collected: []) { pointers in
                var pointers = pointers
                pointers.withUnsafeMutableBufferPointer { buffer in
                    coreRuntime.process(nil, 0, buffer.baseAddress, numChannels, numFrames)
                }
            }
        }
    }

    /// Recursively opens a `withUnsafeMutableBufferPointer` scope for each
    /// channel so all pointers remain valid for the duration of `body`,
    /// then hands the resulting pointer array to `body`. Operates on
    /// `channels`' buffer pointer (rather than the array directly) so
    /// recursion doesn't trip Swift's exclusivity checks on the outer array.
    private func withChannelPointers(
        _ channels: UnsafeMutableBufferPointer<[Float]>,
        index: Int,
        numChannels: Int,
        collected: [UnsafeMutablePointer<Float>?],
        _ body: ([UnsafeMutablePointer<Float>?]) -> Void
    ) {
        if index == numChannels {
            body(collected)
            return
        }
        channels[index].withUnsafeMutableBufferPointer { buffer in
            withChannelPointers(channels, index: index + 1, numChannels: numChannels, collected: collected + [buffer.baseAddress], body)
        }
    }

    public func reset() {
        coreRuntime.reset()
    }
}
