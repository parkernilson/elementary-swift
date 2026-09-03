#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Signals.h"

namespace elemswift::lib {

NodeReprSPtr ms2samps(ElemNodeArg t) {
    return elem::lib::ms2samps(std::move(t.value));
}

NodeReprSPtr tau2pole(ElemNodeArg t) {
    return elem::lib::tau2pole(std::move(t.value));
}

NodeReprSPtr db2gain(ElemNodeArg db) {
    return elem::lib::db2gain(std::move(db.value));
}

NodeReprSPtr select(ElemNodeArg g, ElemNodeArg a, ElemNodeArg b) {
    return elem::lib::select(std::move(g.value), std::move(a.value), std::move(b.value));
}

NodeReprSPtr gain2db(ElemNodeArg gain) {
    return elem::lib::gain2db(std::move(gain.value));
}

NodeReprSPtr hann(ElemNodeArg t) {
    return elem::lib::hann(std::move(t.value));
}
}
