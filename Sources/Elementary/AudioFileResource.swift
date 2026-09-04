import AVFoundation
internal import ElementaryCore

/// Errors thrown while loading an audio file into a shared resource.
public enum AudioResourceError: Error, Equatable {
    case unreadableFile(underlying: NSError)
    case unsupportedFormat
    case duplicateName(String)
}

extension Runtime {
    /// Loads an audio file from disk and registers it as a shared resource under `name`,
    /// ready to be referenced by a Sample node's `path` property.
    ///
    /// Supports any format AVFoundation can decode (`.wav` today; `.aiff`, `.caf`, `.m4a`,
    /// `.mp3`, etc. work the same way with no additional code). The resulting buffer is at
    /// the file's native sample rate — there is no automatic resampling to the runtime's
    /// sample rate.
    @discardableResult
    public func addAudioResource(name: String, fileURL: URL) throws -> Bool {
        let file: AVAudioFile
        do {
            file = try AVAudioFile(forReading: fileURL)
        } catch {
            throw AudioResourceError.unreadableFile(underlying: error as NSError)
        }

        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: file.processingFormat,
            frameCapacity: AVAudioFrameCount(file.length)
        ) else {
            throw AudioResourceError.unsupportedFormat
        }

        do {
            try file.read(into: buffer)
        } catch {
            throw AudioResourceError.unreadableFile(underlying: error as NSError)
        }

        guard let channelData = buffer.floatChannelData else {
            throw AudioResourceError.unsupportedFormat
        }

        // `elem.AudioBufferResource`'s C++ `float**` constructor imports into Swift as
        // `UnsafeMutablePointer<UnsafeMutablePointer<Float>?>` (the C importer adds
        // Optional to the pointee of a pointer-to-pointer), whereas
        // `AVAudioPCMBuffer.floatChannelData` bridges as
        // `UnsafeMutablePointer<UnsafeMutablePointer<Float>>?` (only the outer pointer is
        // optional). Rebuild an array of optional inner pointers so the shapes line up.
        let numChannels = Int(buffer.format.channelCount)
        var channelPointers: [UnsafeMutablePointer<Float>?] =
            (0..<numChannels).map { channelData[$0] }

        let resource = channelPointers.withUnsafeMutableBufferPointer { pointer in
            elem.AudioBufferResource(
                pointer.baseAddress,
                numChannels,
                Int(buffer.frameLength)
            )
        }

        guard addSharedResource(name: name, resource: resource) else {
            throw AudioResourceError.duplicateName(name)
        }

        return true
    }
}
