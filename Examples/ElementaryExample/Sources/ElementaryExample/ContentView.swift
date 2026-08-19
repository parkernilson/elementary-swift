import SwiftUI

struct ContentView: View {
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Elementary Swift Example")
                .font(.title)
            Text(statusMessage)
                .foregroundStyle(.secondary)
            Button(audioPlayer.isRunning ? "Stop" : "Start") {
                toggle()
            }
        }
        .padding(40)
        .frame(minWidth: 360, minHeight: 200)
    }

    private var statusMessage: String {
        if let errorMessage {
            return "Failed to start engine: \(errorMessage)"
        }
        return audioPlayer.isRunning ? "Engine running" : "Engine stopped"
    }

    private func toggle() {
        if audioPlayer.isRunning {
            audioPlayer.stop()
            errorMessage = nil
            return
        }
        do {
            try audioPlayer.start()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
