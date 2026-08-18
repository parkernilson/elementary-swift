//
//  Renderer.swift
//  Elementary
//
//  Created by Parker Nilson on 8/17/26.
//

import ElementaryCore

class Renderer {
    private var coreRenderer: ElementaryCore.Renderer
    
    public init(runtime: borrowing ElementaryCore.Runtime) {
        coreRenderer = ElementaryCore.Renderer(runtime)
    }
}
