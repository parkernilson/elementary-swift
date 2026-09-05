import AVFoundation
internal import ElementaryCore

/// Errors thrown while loading an audio file into a shared resource.
public enum AudioResourceError: Error {
    case unreadableFile(underlying: Error)
    case unsupportedFormat
    case duplicateName(String)
}

/// A decoded audio buffer, ready to be registered as a shared resource.
///
/// This wraps `elem.AudioBufferResource` rather than exposing it directly: that C++ type has
/// non-trivial copy/move/destroy semantics (it holds a `std::vector<std::vector<float>>`), and
/// Swift's C++ interop won't let a declaration return such a type across a module boundary —
/// not even an `internal` declaration accessed via `@testable import` (attempting it anyway
/// surfaces a confusing `'... is inaccessible due to internal protection level'`, or, if the
/// declaration is made `public` to work around that, a deeper `'... is inaccessible due to
/// '@_spi' protection level'` — the compiler blocks this at two independent layers). A plain
/// Swift `class` sidesteps this entirely: callers only ever hold a pointer to the heap object,
/// so the class's own ABI is trivial regardless of what non-trivial C++ value it stores
/// internally. Its methods below have plain-Swift-typed signatures, so they're freely callable
/// cross-module — including from tests.
internal final class DecodedAudioBuffer {
    fileprivate var resource: elem.AudioBufferResource

    fileprivate init(resource: elem.AudioBufferResource) {
        self.resource = resource
    }

    var numChannels: Int { resource.numChannels() }
    var numSamples: Int { resource.numSamples() }

    func samples(forChannel channel: Int) -> [Float] {
        let view = elemswift.getAudioBufferResourceChannelData(&resource, channel)
        guard let data = view.data() else { return [] }
        return Array(UnsafeBufferPointer(start: data, count: view.size()))
    }
}

/// Decodes an audio file from disk into a `DecodedAudioBuffer`, without registering it with any
/// runtime. Used internally by `Runtime.addAudioResource(name:fileURL:)`.
internal func decodeAudioBufferResource(fileURL: URL) throws -> DecodedAudioBuffer {
    let file: AVAudioFile
    do {
        file = try AVAudioFile(forReading: fileURL)
    } catch {
        throw AudioResourceError.unreadableFile(underlying: error)
    }

    guard file.length > 0 else {
        throw AudioResourceError.unsupportedFormat
    }

    guard let buffer = AVAudioPCMBuffer(
        pcmFormat: file.processingFormat,
        frameCapacity: AVAudioFrameCount(file.length)
    ) else {
        throw AudioResourceError.unsupportedFormat
    }

    do {
        // `AVAudioFile.read(into:)` is not contractually guaranteed to fill the buffer to
        // `frameCapacity` in a single call (this matters for compressed formats, where a
        // single internal packet may decode to fewer frames than requested). Keep reading
        // until the buffer is full or a read returns no additional frames (EOF reached
        // early), in which case we just use however many frames were actually read.
        while buffer.frameLength < buffer.frameCapacity {
            let frameLengthBeforeRead = buffer.frameLength
            try file.read(into: buffer)
            if buffer.frameLength == frameLengthBeforeRead {
                break
            }
        }
    } catch {
        throw AudioResourceError.unreadableFile(underlying: error)
    }

    guard let channelData = buffer.floatChannelData else {
        throw AudioResourceError.unsupportedFormat
    }

    let numChannels = Int(buffer.format.channelCount)
    let resource = elemswift.makeAudioBufferResource(channelData, numChannels, Int(buffer.frameLength))
    return DecodedAudioBuffer(resource: resource)
}

extension Runtime {
    /// Loads an audio file from disk and registers it as a shared resource under `name`,
    /// ready to be referenced by a Sample node's `path` property.
    ///
    /// Supports any format AVFoundation can decode (`.wav` today; `.aiff`, `.caf`, `.m4a`,
    /// `.mp3`, etc. work the same way with no additional code). The resulting buffer is at
    /// the file's native sample rate — there is no automatic resampling to the runtime's
    /// sample rate.
    ///
    /// Must be called from the same non-realtime thread that drives graph mutation/rendering,
    /// since the underlying shared resource map is not synchronized.
    @discardableResult
    public func addAudioResource(name: String, fileURL: URL) throws -> Bool {
        let decoded = try decodeAudioBufferResource(fileURL: fileURL)

        guard addSharedResource(name: name, resource: decoded.resource) else {
            throw AudioResourceError.duplicateName(name)
        }

        return true
    }
}
