//
//  ElementarySwift.swift
//  ElementarySwift
//
//  Created by Parker Nilson on 8/13/26.
//

#pragma once

#include <elem/SymbolicGraph.h>
#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"

namespace elem {
using GraphNodeVector = std::vector<SymbolicGraphNode>;

// Swift's C++ interop always resolves std::vector<T>::push_back to the
// const-reference overload, which requires T to be copyable. SymbolicGraphNode
// is move-only, so Swift can't call push_back on GraphNodeVector directly.
// Taking the node by value here forces a move from the caller's temporary via
// a single, unambiguous overload that Swift can call.
inline void appendGraphNode(GraphNodeVector &vec, SymbolicGraphNode node) {
    vec.push_back(std::move(node));
}
}
