#pragma once

#include <optional>
#include <string>

#include "NodeUtils.h"
#include "../Vendor/elementary/runtime/elem/lib/Core.h"
#include "../Vendor/elementary/runtime/elem/lib/Oscillators.h"

namespace ElementaryCore {
NodeReprSPtr constant(const double x) {
    return elem::lib::constant(x);
}

NodeReprSPtr cycle(double rate) {
    return elem::lib::cycle(rate);
}

NodeReprSPtr cycle(NodeReprSPtr rate) {
    return elem::lib::cycle(std::move(rate));
}

// Swift can't import elem::lib::MaxHoldProps directly: its optional fields are
// declared inline by the DEFINE_PROPS_STRUCT macro (no named specialization for
// Swift's importer to latch onto), and it relies on a consuming takeJsObject()
// that isn't idiomatic to expose to Swift. So the shim re-declares the same
// fields behind named std::optional aliases, which Swift *can* construct
// (`OptString(std.string("x"))` / `OptString()` for nil), and converts to the
// real elem::lib type at the call boundary.
using OptString = std::optional<std::string>;
using OptDouble = std::optional<double>;

struct MaxHoldProps {
    OptString key;
    OptDouble hold;
};

inline MaxHoldProps maxHoldProps(OptString key, OptDouble hold) {
    return MaxHoldProps{std::move(key), std::move(hold)};
}

NodeRepr maxhold(MaxHoldProps props, NodeReprSPtr x, NodeReprSPtr reset) {
    elem::lib::MaxHoldProps coreProps{std::move(props.key), std::move(props.hold)};
    return elem::lib::maxhold(std::move(coreProps), std::move(x), std::move(reset));
}
}
