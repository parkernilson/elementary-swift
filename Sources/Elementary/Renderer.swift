internal import ElementaryCore

public final class Renderer {
    public struct Options {
        public let fadeInMs: Int32
        public let fadeOutMs: Int32
        
        public init(fadeInMs: Int32, fadeOutMs: Int32) {
            self.fadeInMs = fadeInMs
            self.fadeOutMs = fadeOutMs
        }
        
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
    
    @discardableResult
    public func renderGraph(graphs: [NodeRepr], options: Options=Options(fadeInMs: 20, fadeOutMs: 20)) -> RenderResult {
        RenderResult(fromCore: coreRenderer.renderGraph(graphs.toCore(), options.toCore()))
    }

    public func createRef(kind: String, props: [String: Value], children: [NodeRepr]) -> (NodeRepr, ([String: Value]) -> RenderResult) {
        let ref = coreRenderer.createRef(std.string(kind), props.toCore(), children.toCore())
        let setter = ref.setter
        return (NodeRepr(ref.node), { newProps in
            RenderResult(fromCore: setter(newProps.toCore()))
        })
    }
}
