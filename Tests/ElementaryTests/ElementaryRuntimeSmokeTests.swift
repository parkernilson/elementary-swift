import XCTest
@testable import Elementary

final class ElementaryRuntimeSmokeTests: XCTestCase {
    func testCanConstructRuntimeAndProcessSilence() {
        let runtime = Runtime(sampleRate: 44_100, blockSize: 512)
        var output: [[Float]] = [[Float](repeating: 0, count: 512), [Float](repeating: 0, count: 512)]
        runtime.process(output: &output, numFrames: 512)
        runtime.reset()
    }
}
