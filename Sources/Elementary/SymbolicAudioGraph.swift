//
//  AudioGraph.swift
//  ElementarySwift
//
//  Created by Parker Nilson on 8/13/26.
//

import ElementaryCore

// TODO: This should be convertible to c++ SymbolicAudioGraph
public struct AudioGraph {
    
    public let nodes: [Int32, AudioGraphNode]
    public let roots: [Int32]
    
    // TODO: Make a static method that uses the elem::SymbolicGraph::createNode method
    // to create an AudioGraphNode
    
    init() {
        // TODO: Make a toCore() method or something that can turn this into the core type
        //        let g = elem.SymbolicAudioGraph()
    }
    
    internal func toCore() -> elem.SymbolicAudioGraph {
        // TODO: Implement me
    }
}
