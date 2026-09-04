import XCTest
@testable import Elementary

final class AudioFileResourceTests: XCTestCase {
    private var fixtureURL: URL {
        Bundle.module.url(forResource: "test-tone", withExtension: "wav", subdirectory: "Fixtures")!
    }

    func testAddAudioResourceDecodesAndRegistersFile() throws {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        let added = try runtime.addAudioResource(name: "tone", fileURL: fixtureURL)

        XCTAssertTrue(added)
        XCTAssertTrue(runtime.sharedResourceKeys().contains("tone"))
    }

    func testAddAudioResourceRejectsDuplicateName() throws {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)
        _ = try runtime.addAudioResource(name: "tone", fileURL: fixtureURL)

        XCTAssertThrowsError(try runtime.addAudioResource(name: "tone", fileURL: fixtureURL)) { error in
            guard case AudioResourceError.duplicateName(let name) = error else {
                return XCTFail("Expected duplicateName, got \(error)")
            }
            XCTAssertEqual(name, "tone")
        }
    }

    func testAddAudioResourceThrowsForMissingFile() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)
        let missingURL = fixtureURL.deletingLastPathComponent().appendingPathComponent("does-not-exist.wav")

        XCTAssertThrowsError(try runtime.addAudioResource(name: "missing", fileURL: missingURL)) { error in
            guard case AudioResourceError.unreadableFile = error else {
                return XCTFail("Expected unreadableFile, got \(error)")
            }
        }
    }
}
