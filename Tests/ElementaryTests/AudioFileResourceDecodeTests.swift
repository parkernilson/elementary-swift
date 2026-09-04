import XCTest
@testable import Elementary

final class AudioFileResourceDecodeTests: XCTestCase {
    private var stereoFixtureURL: URL {
        Bundle.module.url(forResource: "stereo-tone", withExtension: "wav", subdirectory: "Fixtures")!
    }

    // NOTE: This was intended to call `decodeAudioBufferResource(fileURL:)` directly and assert
    // on individual sample values read back via `elem.AudioBufferResource.getChannelData(_:)`, to
    // prove per-channel data survives the Swift/C++ boundary intact. That turned out to be
    // blocked by two independent Swift/C++ interop limitations — see
    // final-review-fix-report.md for the full writeup — so this test is limited to what's
    // actually possible: proving the stereo file decodes and registers successfully end-to-end
    // via the public API.
    func testAddAudioResourceDecodesAndRegistersStereoFile() throws {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        let added = try runtime.addAudioResource(name: "stereo-tone", fileURL: stereoFixtureURL)

        XCTAssertTrue(added)
        XCTAssertTrue(runtime.sharedResourceKeys().contains("stereo-tone"))
    }
}
