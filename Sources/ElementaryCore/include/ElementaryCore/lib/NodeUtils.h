#pragma once

#include "../Vendor/elementary/runtime/elem/lib/NodeUtils.h"

namespace ElementaryCore {
// TODO: Do we need these?
using NodeReprSPtr = elem::lib::NodeReprSPtr;
using NodeReprSPtrVector = std::vector<elem::lib::NodeReprSPtr>;
using ElemNode = elem::lib::ElemNode;

// Swift can't import elem::lib::ElemNode directly: it's a std::variant<NodeReprSPtr, js::Number>,
// and Swift's importer doesn't give a usable way to construct or pattern-match a std::variant.
// This wrapper exposes two constructors instead - one per variant alternative - so a single
// function signature (e.g. `cycle(ElemNodeArg)`) can accept either a literal or a node from
// Swift, rather than needing separate overloads per argument.
struct ElemNodeArg {
    ElemNode value;
    ElemNodeArg(double x) : value(x) {}
    ElemNodeArg(NodeReprSPtr x) : value(std::move(x)) {}
};

// Swift's C++ interop always resolves std::vector<T>::push_back to the
// const-reference overload, which requires T to be copyable. SymbolicGraphNode
// is move-only, so Swift can't call push_back on GraphNodeVector directly.
// Taking the node by value here forces a move from the caller's temporary via
// a single, unambiguous overload that Swift can call.
inline void appendGraphNode(NodeReprSPtrVector &vec, NodeReprSPtr node) {
    vec.push_back(std::move(node));
}
}
