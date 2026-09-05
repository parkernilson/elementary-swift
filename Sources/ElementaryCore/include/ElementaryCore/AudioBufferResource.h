#pragma once

#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"

#include <cstddef>

namespace elemswift {

using BufferViewFloat = elem::BufferView<float>;

// elem::SharedResource::getChannelData is a pure virtual method returning
// BufferView<float>, a non-trivial C++ template type. Swift's C++ interop
// can't call a pure-virtual override with a complex return type
inline BufferViewFloat audioBufferResourceChannelDataGet(elem::AudioBufferResource& resource, size_t channelIndex) {
    return resource.getChannelData(channelIndex);
}

} // namespace elemswift
