import AVFoundation
internal import ElementaryCore

/// Errors thrown while loading an audio file into a shared resource.
public enum AudioResourceError: Error {
    case unreadableFile(underlying: Error)
    case unsupportedFormat
    case duplicateName(String)
}

/// Decodes an audio file from disk into an `elem.AudioBufferResource`, without registering it
/// with any runtime. Used internally by `Runtime.addAudioResource(name:fileURL:)`.
internal func decodeAudioBufferResource(fileURL: URL) throws -> elem.AudioBufferResource {
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
    return elemswift.makeAudioBufferResource(channelData, numChannels, Int(buffer.frameLength))
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
        let resource = try decodeAudioBufferResource(fileURL: fileURL)

        guard addSharedResource(name: name, resource: resource) else {
            throw AudioResourceError.duplicateName(name)
        }

        return true
    }
}

/// Test-support only: decodes a file via `decodeAudioBufferResource` and immediately extracts
/// its channel/sample data into plain Swift types.
///
/// `elem.AudioBufferResource` itself can't be returned from an `internal` declaration and used
/// across a module boundary — Swift's C++ interop doesn't expose that direction (return
/// position, including nested inside a closure parameter type) via `@testable import`, even
/// though passing the same type as a direct parameter works fine (as `Runtime.addSharedResource`
/// already does). Keeping this function's own signature free of any `elem` type sidesteps that,
/// so tests can verify the real decode path's output without needing the type itself.
internal func __decodedAudioBufferResourceSamples(
    fileURL: URL
) throws -> (numChannels: Int, numSamples: Int, channelSamples: [[Float]]) {
    var resource = try decodeAudioBufferResource(fileURL: fileURL)

    let numChannels = resource.numChannels()
    let numSamples = resource.numSamples()

    let channelSamples: [[Float]] = (0..<numChannels).map { channel in
        let thing = elemswift.audioBufferResourceChannelDataGet(&resource, channel)
        
        guard let data = thing.data() else {
            return []
        }
        let size = thing.size()
        return Array(UnsafeBufferPointer(start: data, count: size))
    }

    return (numChannels, numSamples, channelSamples)
}
