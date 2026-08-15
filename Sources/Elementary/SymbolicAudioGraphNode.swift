//
//  AudioGraphNode.swift
//  ElementarySwift
//
//  Created by Parker Nilson on 8/13/26.
//
import ElementaryCore

struct AudioGraphNode {
    public let hash: Int32
    public let kind: String
    // TODO: JSON type or AnyMap or something
    public let params: [String: Any]
    public let outputChannel: Int8
    public let children: [Int32]
    
    internal static func fromCore(node: elem.SymbolicGraphNode) -> AudioGraphNode {
        // TODO: Map props
        // TODO: Map broken conversions
        return AudioGraphNode(hash: node.hash, kind: node.kind, params: node.props, outputChannel: node.outputChannel, children: node.children)
    }
    
    internal static func createNode(kind: String, params: [String: Any], children: [AudioGraphNode]) -> AudioGraphNode {
        return fromCore(elem.SymbolicGraph.createNode(kind, params, children))
    }
}
