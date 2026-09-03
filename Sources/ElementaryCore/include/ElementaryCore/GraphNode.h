#pragma once

#include "../../../../Vendor/elementary/runtime/elem/GraphNode.h"

namespace ElementaryCore {

// ElementaryCore::Runtime and ElementaryCore::Renderer are hard-coded to
// elem's `float` instantiation, so these aliases give custom node authors
// the matching concrete types to subclass/reference, under the
// ElementaryCore namespace, without needing to reach into `elem::` or
// depend on anything beyond the ElementaryCore product.
using NodeId = elem::NodeId;
using GraphNode = elem::GraphNode<float>;
using BlockContext = elem::BlockContext<float>;
using Number = elem::js::Number;

} // namespace ElementaryCore
