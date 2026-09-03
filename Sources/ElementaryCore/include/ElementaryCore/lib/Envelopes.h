#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../Vendor/elementary/runtime/elem/lib/Envelopes.h"

namespace ElementaryCore {

NodeReprSPtr adsr(
    ElemNodeArg attackSec,
    ElemNodeArg decaySec,
    ElemNodeArg sustain,
    ElemNodeArg releaseSec,
    ElemNodeArg gate
) {
    return elem::lib::adsr(
        std::move(attackSec.value), std::move(decaySec.value), std::move(sustain.value),
        std::move(releaseSec.value), std::move(gate.value)
    );
}
}
