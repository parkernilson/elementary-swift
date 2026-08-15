import Foundation
import ElementaryCore

/// Renders an AudioGraph to the Elementary Audio runtime
public final class AudioGraphRenderer: @unchecked Sendable {
    private let renderer: elem.Renderer
    
    // TODO: Keep this?
    /// Errors that can occur during graph rendering
    public enum RenderError: Error, CustomStringConvertible {
        case runtimeNotAvailable
        case encodingFailed(String)
        case renderFailed(Int32)

        public var description: String {
            switch self {
            case .runtimeNotAvailable:
                return "Elementary Audio runtime is not available"
            case .encodingFailed(let message):
                return "Failed to encode graph: \(message)"
            case .renderFailed(let code):
                return "Runtime render failed with code: \(code)"
            }
        }
    }

    /// Creates a new graph renderer
    // TODO: We need a `Renderer` from the c++ layer as a member created in the constructor
    public init() {
        // TODO: Implement this correctly
        self.renderer = elem.Renderer()
    }

    /// Renders an audio graph to the runtime
    ///
    /// - Parameter graph: The audio graph to render
    /// - Throws: `RenderError` if rendering fails
    public func render(_ graph: AudioGraph) throws {
        // Garbage-collect nodes from the previous render that have finished fading out
        // TODO: Should we gc less often than this? Or throttle gc for quick renders?
        gc()

        // TODO: Call this.renderer.renderGraph(graph)
        self.renderer.renderGraph(graph.toCore())
    }

    /// Runs garbage collection on the runtime, releasing unused nodes
    public func gc() {
        // TODO: this.renderer.gc()
    }

    /// Resets the runtime
    public func reset() {
        // TODO: this.renderer.reset()
    }

    // MARK: - Runtime Lifecycle & Processing

    /// Reinitializes the runtime with the given sample rate and block size
    ///
    /// Call this before rendering a graph if you need a specific sample rate
    /// or block size different from the default (44100 Hz / 512 samples).
    ///
    /// - Parameters:
    ///   - sampleRate: The sample rate in Hz
    ///   - blockSize: The processing block size in samples
    public func initialize(sampleRate: Double, blockSize: Int) {
        // TODO: this.runtime = ElementaryRuntime(...)
        // TODO: this.runtime.initialize(sampleRate, Int32(blockSize))
    }
}

// MARK: - Convenience Extensions

// TODO: DSL builder
//extension GraphRenderer {
//    /// Renders a graph built with the DSL
//    ///
//    /// - Parameter builder: A closure that builds the audio graph
//    /// - Throws: `RenderError` if rendering fails
//    public func render(@AudioGraphBuilder _ builder: () -> AudioGraph) throws {
//        let graph = builder()
//        try render(graph)
//    }
//}
