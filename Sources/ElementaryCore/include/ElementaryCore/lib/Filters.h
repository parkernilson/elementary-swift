#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Filters.h"

namespace elemswift::lib {

NodeReprSPtr smooth(ElemNodeArg p, ElemNodeArg x) {
    return elem::lib::smooth(std::move(p.value), std::move(x.value));
}

NodeReprSPtr sm(ElemNodeArg x) {
    return elem::lib::sm(std::move(x.value));
}

NodeReprSPtr zero(ElemNodeArg b0, ElemNodeArg b1, ElemNodeArg x) {
    return elem::lib::zero(std::move(b0.value), std::move(b1.value), std::move(x.value));
}

NodeReprSPtr dcblock(ElemNodeArg x) {
    return elem::lib::dcblock(std::move(x.value));
}

NodeReprSPtr df11(ElemNodeArg b0, ElemNodeArg b1, ElemNodeArg a1, ElemNodeArg x) {
    return elem::lib::df11(std::move(b0.value), std::move(b1.value), std::move(a1.value), std::move(x.value));
}

NodeReprSPtr lowpass(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg x) {
    return elem::lib::lowpass(std::move(fc.value), std::move(q.value), std::move(x.value));
}

NodeReprSPtr highpass(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg x) {
    return elem::lib::highpass(std::move(fc.value), std::move(q.value), std::move(x.value));
}

NodeReprSPtr bandpass(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg x) {
    return elem::lib::bandpass(std::move(fc.value), std::move(q.value), std::move(x.value));
}

NodeReprSPtr notch(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg x) {
    return elem::lib::notch(std::move(fc.value), std::move(q.value), std::move(x.value));
}

NodeReprSPtr allpass(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg x) {
    return elem::lib::allpass(std::move(fc.value), std::move(q.value), std::move(x.value));
}

NodeReprSPtr peak(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg gainDecibels, ElemNodeArg x) {
    return elem::lib::peak(std::move(fc.value), std::move(q.value), std::move(gainDecibels.value), std::move(x.value));
}

NodeReprSPtr lowshelf(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg gainDecibels, ElemNodeArg x) {
    return elem::lib::lowshelf(std::move(fc.value), std::move(q.value), std::move(gainDecibels.value), std::move(x.value));
}

NodeReprSPtr highshelf(ElemNodeArg fc, ElemNodeArg q, ElemNodeArg gainDecibels, ElemNodeArg x) {
    return elem::lib::highshelf(std::move(fc.value), std::move(q.value), std::move(gainDecibels.value), std::move(x.value));
}

NodeReprSPtr pink(ElemNodeArg x) {
    return elem::lib::pink(std::move(x.value));
}
}
