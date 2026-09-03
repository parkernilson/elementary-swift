#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../Vendor/elementary/runtime/elem/lib/Dynamics.h"

namespace ElementaryCore {

NodeReprSPtr compress(
    ElemNodeArg attackMs,
    ElemNodeArg releaseMs,
    ElemNodeArg threshold,
    ElemNodeArg ratio,
    ElemNodeArg sidechain,
    ElemNodeArg xn
) {
    return elem::lib::compress(
        std::move(attackMs.value), std::move(releaseMs.value), std::move(threshold.value),
        std::move(ratio.value), std::move(sidechain.value), std::move(xn.value)
    );
}

NodeReprSPtr skcompress(
    ElemNodeArg attackMs,
    ElemNodeArg releaseMs,
    ElemNodeArg threshold,
    ElemNodeArg ratio,
    ElemNodeArg kneeWidth,
    ElemNodeArg sidechain,
    ElemNodeArg xn
) {
    return elem::lib::skcompress(
        std::move(attackMs.value), std::move(releaseMs.value), std::move(threshold.value),
        std::move(ratio.value), std::move(kneeWidth.value), std::move(sidechain.value), std::move(xn.value)
    );
}
}
