//
//  Renderer.swift
//  Elementary
//
//  Created by Parker Nilson on 8/17/26.
//

import ElementaryCore

class Renderer {
    struct Options {
        // TODO: Maybe these should be UInt32 or Double
        // since they are converted to js::Number under the hood
        public let fadeInMs: Int32
        public let fadeOutMs: Int32
        
        internal func toCore() -> elem.RenderOptions {
            return elem.RenderOptions(
                fadeInMs: self.fadeInMs,
                fadeOutMs: self.fadeOutMs
            )
        }
    }
    
    private var coreRenderer: ElementaryCore.Renderer
    
    public init(runtime: borrowing ElementaryCore.Runtime) {
        coreRenderer = ElementaryCore.Renderer(runtime)
    }
    
    public func renderGraph(graphs: [GraphNode], options: Options) {
        return coreRenderer.renderGraph(graphs.toCore(), options.toCore())
    }
}
