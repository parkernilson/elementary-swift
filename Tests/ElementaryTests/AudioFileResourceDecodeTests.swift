import XCTest
@testable import Elementary

final class AudioFileResourceDecodeTests: XCTestCase {
    private var stereoFixtureURL: URL {
        Bundle.module.url(forResource: "stereo-tone", withExtension: "wav", subdirectory: "Fixtures")!
    }

    /// The stereo fixture is generated with the left channel ramping `0, 1000, 2000, 3000, ...`
    /// (mod 4) and the right channel as its exact negation, so this test can prove per-channel
    /// data survives the Swift/C++ boundary intact — not just that decoding didn't throw.
    func testDecodeAudioBufferResourcePreservesPerChannelSampleData() throws {
        let result = try __decodedAudioBufferResourceSamples(fileURL: stereoFixtureURL)

        XCTAssertEqual(result.numChannels, 2)
        XCTAssertEqual(result.numSamples, 40)
        XCTAssertEqual(result.channelSamples[0].count, 40)
        XCTAssertEqual(result.channelSamples[1].count, 40)

        // frame 0: both channels are 0 — not very discriminating on its own, but checked anyway.
        XCTAssertEqual(result.channelSamples[0][0], 0, accuracy: 0.001)
        XCTAssertEqual(result.channelSamples[1][0], 0, accuracy: 0.001)

        // frame 1: left = 1000/32768, right = -1000/32768. A tolerance this tight only passes
        // if the channels are neither swapped, aliased, nor scrambled by the pointer rebuild.
        XCTAssertEqual(result.channelSamples[0][1], 1000.0 / 32768.0, accuracy: 0.001)
        XCTAssertEqual(result.channelSamples[1][1], -1000.0 / 32768.0, accuracy: 0.001)

        // frame 2: left = 2000/32768, right = -2000/32768.
        XCTAssertEqual(result.channelSamples[0][2], 2000.0 / 32768.0, accuracy: 0.001)
        XCTAssertEqual(result.channelSamples[1][2], -2000.0 / 32768.0, accuracy: 0.001)
    }

    func testAddAudioResourceDecodesAndRegistersStereoFile() throws {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        let added = try runtime.addAudioResource(name: "stereo-tone", fileURL: stereoFixtureURL)

        XCTAssertTrue(added)
        XCTAssertTrue(runtime.sharedResourceKeys().contains("stereo-tone"))
    }
}
