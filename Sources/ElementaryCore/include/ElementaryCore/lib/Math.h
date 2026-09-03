#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Math.h"

namespace elemswift::lib {

struct IdentityProps {
    OptString key;
    OptDouble channel;
};

inline IdentityProps identityProps(OptString key, OptDouble channel) {
    return IdentityProps{std::move(key), std::move(channel)};
}

// The vendor overload set distinguishes "no children" (leaf node, fed by the
// host) from "explicit children" via std::optional<vector<ElemNode>>. An
// empty vector resolves identically to nullopt (both end up as `{}` children
// on the node), so a single (possibly-empty) ElemNodeArgVector covers both
// cases without needing to model the optional-vector distinction here.
NodeReprSPtr identity(IdentityProps props, ElemNodeArgVector children) {
    elem::lib::IdentityProps coreProps{std::move(props.key), std::move(props.channel)};
    std::vector<elem::lib::ElemNode> coreChildren;
    coreChildren.reserve(children.size());
    for (auto &child : children) {
        coreChildren.push_back(std::move(child.value));
    }
    return elem::lib::identity(std::move(coreProps), std::move(coreChildren));
}

NodeReprSPtr identity(IdentityProps props, ElemNodeArg x) {
    elem::lib::IdentityProps coreProps{std::move(props.key), std::move(props.channel)};
    return elem::lib::identity(std::move(coreProps), std::move(x.value));
}

// --- Unary nodes ---

NodeReprSPtr sin(ElemNodeArg x) { return elem::lib::sin(std::move(x.value)); }
NodeReprSPtr cos(ElemNodeArg x) { return elem::lib::cos(std::move(x.value)); }
NodeReprSPtr tan(ElemNodeArg x) { return elem::lib::tan(std::move(x.value)); }
NodeReprSPtr tanh(ElemNodeArg x) { return elem::lib::tanh(std::move(x.value)); }
NodeReprSPtr asinh(ElemNodeArg x) { return elem::lib::asinh(std::move(x.value)); }
NodeReprSPtr ln(ElemNodeArg x) { return elem::lib::ln(std::move(x.value)); }
NodeReprSPtr log(ElemNodeArg x) { return elem::lib::log(std::move(x.value)); }
NodeReprSPtr log2(ElemNodeArg x) { return elem::lib::log2(std::move(x.value)); }
NodeReprSPtr ceil(ElemNodeArg x) { return elem::lib::ceil(std::move(x.value)); }
NodeReprSPtr floor(ElemNodeArg x) { return elem::lib::floor(std::move(x.value)); }
NodeReprSPtr round(ElemNodeArg x) { return elem::lib::round(std::move(x.value)); }
NodeReprSPtr sqrt(ElemNodeArg x) { return elem::lib::sqrt(std::move(x.value)); }
NodeReprSPtr exp(ElemNodeArg x) { return elem::lib::exp(std::move(x.value)); }
NodeReprSPtr abs(ElemNodeArg x) { return elem::lib::abs(std::move(x.value)); }

// --- Binary nodes ---

NodeReprSPtr le(ElemNodeArg a, ElemNodeArg b) { return elem::lib::le(std::move(a.value), std::move(b.value)); }
NodeReprSPtr leq(ElemNodeArg a, ElemNodeArg b) { return elem::lib::leq(std::move(a.value), std::move(b.value)); }
NodeReprSPtr ge(ElemNodeArg a, ElemNodeArg b) { return elem::lib::ge(std::move(a.value), std::move(b.value)); }
NodeReprSPtr geq(ElemNodeArg a, ElemNodeArg b) { return elem::lib::geq(std::move(a.value), std::move(b.value)); }
NodeReprSPtr pow(ElemNodeArg a, ElemNodeArg b) { return elem::lib::pow(std::move(a.value), std::move(b.value)); }
NodeReprSPtr eq(ElemNodeArg a, ElemNodeArg b) { return elem::lib::eq(std::move(a.value), std::move(b.value)); }
// Named with trailing underscores to match the vendor spelling - "and"/"or"
// are reserved alternative operator tokens in C++, so they can't be used as
// identifiers there. The Swift-facing layer is free to call these `and`/`or`.
NodeReprSPtr and_(ElemNodeArg a, ElemNodeArg b) { return elem::lib::and_(std::move(a.value), std::move(b.value)); }
NodeReprSPtr or_(ElemNodeArg a, ElemNodeArg b) { return elem::lib::or_(std::move(a.value), std::move(b.value)); }

// --- Binary reducing nodes ---

inline std::vector<elem::lib::ElemNode> unwrapElemNodeArgs(ElemNodeArgVector xs) {
    std::vector<elem::lib::ElemNode> coreXs;
    coreXs.reserve(xs.size());
    for (auto &x : xs) {
        coreXs.push_back(std::move(x.value));
    }
    return coreXs;
}

NodeReprSPtr add(ElemNodeArgVector xs) { return elem::lib::add(unwrapElemNodeArgs(std::move(xs))); }
NodeReprSPtr sub(ElemNodeArgVector xs) { return elem::lib::sub(unwrapElemNodeArgs(std::move(xs))); }
NodeReprSPtr mul(ElemNodeArgVector xs) { return elem::lib::mul(unwrapElemNodeArgs(std::move(xs))); }
NodeReprSPtr div(ElemNodeArgVector xs) { return elem::lib::div(unwrapElemNodeArgs(std::move(xs))); }
NodeReprSPtr mod(ElemNodeArgVector xs) { return elem::lib::mod(unwrapElemNodeArgs(std::move(xs))); }
NodeReprSPtr min(ElemNodeArgVector xs) { return elem::lib::min(unwrapElemNodeArgs(std::move(xs))); }
NodeReprSPtr max(ElemNodeArgVector xs) { return elem::lib::max(unwrapElemNodeArgs(std::move(xs))); }
}
