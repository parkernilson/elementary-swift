#pragma once

namespace elemswift {

// Swift can't call elem::js::Value's implicit conversion operators or the
// reference-returning getArray()/getObject() accessors directly, so these
// give Swift value-returning extraction points instead.
inline bool jsValueGetBool(elem::js::Value const& v) { return static_cast<bool>(v); }
inline double jsValueGetNumber(elem::js::Value const& v) { return static_cast<double>(v); }
inline std::string jsValueGetString(elem::js::Value const& v) { return static_cast<std::string>(v); }
inline elem::js::Array jsValueGetArray(elem::js::Value const& v) { return v.getArray(); }

// std::map doesn't support for-in on this deployment target, so hand Swift a
// std::vector of entries instead, which it can iterate.
inline std::vector<std::pair<std::string, elem::js::Value>> jsValueGetObjectEntries(elem::js::Value const& v) {
    std::vector<std::pair<std::string, elem::js::Value>> entries;
    for (auto const& [key, value] : v.getObject()) {
        entries.emplace_back(key, value);
    }
    return entries;
}

}
