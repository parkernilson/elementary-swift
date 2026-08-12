import SwiftUI
import ElementarySwift

struct ContentView: View {
    @State private var statusMessage = "Not yet constructed"

    var body: some View {
        VStack(spacing: 16) {
            Text("Elementary Swift Example")
                .font(.title)
            Text(statusMessage)
                .foregroundStyle(.secondary)
            Button("Construct Runtime") {
                constructRuntime()
            }
        }
        .padding(40)
        .frame(minWidth: 360, minHeight: 200)
    }

    private func constructRuntime() {
        let runtime = ElementaryAudioRuntime(sampleRate: 44_100, blockSize: 512)
        var output: [[Float]] = [
            [Float](repeating: 0, count: 512),
            [Float](repeating: 0, count: 512),
        ]
        runtime.process(output: &output, numFrames: 512)
        statusMessage = "Runtime constructed and processed a block of silence successfully."
    }
}
