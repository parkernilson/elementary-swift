internal import ElementaryCore

public final class Renderer {
    public struct Options {
        public let fadeInMs: Int32
        public let fadeOutMs: Int32
        
        internal func toCore() -> elem.RenderOptions {
            return elem.RenderOptions(
                fadeInMs: self.fadeInMs,
                fadeOutMs: self.fadeOutMs
            )
        }
    }
    
    private var coreRenderer: elemswift.Renderer
    
    public init(_ runtime: borrowing Elementary.Runtime) {
        coreRenderer = elemswift.Renderer(runtime.coreRuntime)
    }
    
    public func renderGraph(graphs: [NodeRepr], options: Options) {
        coreRenderer.renderGraph(graphs.toCore(), options.toCore())
    }
}
