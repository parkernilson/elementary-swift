import AVFoundation
import Elementary
import ElementaryWrapper

/// Owns the `AVAudioEngine`/`Runtime` pair and wires a real-time
/// `AVAudioSourceNode` render callback directly into `Runtime.process`.
final class AudioPlayer: ObservableObject {
    @Published private(set) var isRunning = false

    private let engine = AVAudioEngine()
    private let runtime: Elementary.Runtime
    private let renderer: Elementary.Renderer

    init(sampleRate: Double = 44_100, blockSize: Int32 = 4_096) {
        runtime = Elementary.Runtime(CustomRuntime.makeElementaryRuntime(sampleRate, blockSize))
        renderer = Elementary.Renderer(runtime)

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!
        let sourceNode = AVAudioSourceNode(format: format) { [runtime] _, _, frameCount, audioBufferList in
            let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)
            withUnsafeTemporaryAllocation(of: UnsafeMutablePointer<Float>?.self, capacity: abl.count) { pointers in
                for i in 0..<abl.count {
                    pointers[i] = abl[i].mData?.assumingMemoryBound(to: Float.self)
                }
                runtime.process(
                    outputChannelData: pointers.baseAddress!,
                    numChannels: abl.count,
                    numFrames: Int(frameCount)
                )
            }
            return noErr
        }

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: engine.mainMixerNode, format: format)
    }

    func start() throws {
        try engine.start()
        isRunning = true
    }

    func stop() {
        engine.stop()
        isRunning = false
    }
}
