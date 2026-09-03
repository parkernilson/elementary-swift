#pragma once

#include <optional>
#include <string>

#include "NodeUtils.h"
#include "../Vendor/elementary/runtime/elem/lib/Core.h"
#include "../Vendor/elementary/runtime/elem/lib/Oscillators.h"

// TODO: add ::lib to this namespace probably
namespace ElementaryCore {

NodeReprSPtr cycle(ElemNodeArg rate) {
    return elem::lib::cycle(std::move(rate.value));
}

struct MaxHoldProps {
    OptString key;
    OptDouble hold;
};

inline MaxHoldProps maxHoldProps(OptString key, OptDouble hold) {
    return MaxHoldProps{std::move(key), std::move(hold)};
}

NodeReprSPtr maxhold(MaxHoldProps props, ElemNodeArg x, ElemNodeArg reset) {
    elem::lib::MaxHoldProps coreProps{std::move(props.key), std::move(props.hold)};
    return elem::lib::maxhold(std::move(coreProps), std::move(x.value), std::move(reset.value));
}
}
