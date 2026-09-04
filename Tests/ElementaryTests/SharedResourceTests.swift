import XCTest
import ElementaryCore
@testable import Elementary

final class SharedResourceTests: XCTestCase {
    private func makeMonoResource(_ samples: [Float]) -> elem.AudioBufferResource {
        var samples = samples
        return samples.withUnsafeMutableBufferPointer { buf in
            elem.AudioBufferResource(buf.baseAddress, buf.count)
        }
    }

    func testAddSharedResourceRegistersName() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        let added = runtime.addSharedResource(name: "test-buffer", resource: makeMonoResource([0.0, 0.25, 0.5, 0.75]))

        XCTAssertTrue(added)
        XCTAssertTrue(runtime.sharedResourceKeys().contains("test-buffer"))
    }

    func testAddSharedResourceRejectsDuplicateName() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        XCTAssertTrue(runtime.addSharedResource(name: "dup", resource: makeMonoResource([0.0])))
        XCTAssertFalse(runtime.addSharedResource(name: "dup", resource: makeMonoResource([1.0])))
    }

    func testPruneSharedResourcesRemovesUnreferenced() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)
        runtime.addSharedResource(name: "unreferenced", resource: makeMonoResource([0.0]))

        runtime.pruneSharedResources()

        XCTAssertFalse(runtime.sharedResourceKeys().contains("unreferenced"))
    }
}
