#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Oscillators.h"

namespace elemswift::lib {

NodeReprSPtr train(ElemNodeArg rate) {
    return elem::lib::train(std::move(rate.value));
}

NodeReprSPtr saw(ElemNodeArg rate) {
    return elem::lib::saw(std::move(rate.value));
}

NodeReprSPtr square(ElemNodeArg rate) {
    return elem::lib::square(std::move(rate.value));
}

NodeReprSPtr triangle(ElemNodeArg rate) {
    return elem::lib::triangle(std::move(rate.value));
}

NodeReprSPtr blepsaw(ElemNodeArg rate) {
    return elem::lib::blepsaw(std::move(rate.value));
}

NodeReprSPtr blepsquare(ElemNodeArg rate) {
    return elem::lib::blepsquare(std::move(rate.value));
}

NodeReprSPtr bleptriangle(ElemNodeArg rate) {
    return elem::lib::bleptriangle(std::move(rate.value));
}

NodeReprSPtr noise(RandProps props) {
    elem::lib::RandProps coreProps{std::move(props.key), std::move(props.seed)};
    return elem::lib::noise(std::move(coreProps));
}
}
