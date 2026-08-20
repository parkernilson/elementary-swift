#pragma once

#include "../Vendor/elementary/runtime/elem/lib/Core.h"

namespace ElementaryCore {
GraphNodeSPtr constant(const double x) {
    return elem::lib::constant(x)
}

GraphNodeSPtr cycle(double rate) {
    return elem::lib::cycle(rate)
}

GraphNodeSPtr cycle(GraphNodeSPtr rate) {
    return elem::lib::cycle(std::move(rate))
}
}
