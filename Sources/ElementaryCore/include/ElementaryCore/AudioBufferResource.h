#pragma once

#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"

#include <cstddef>

namespace elemswift {

// A Swift function that itself calls elem::AudioBufferResource's
// (float**, size_t, size_t) constructor becomes uncallable across a module
// boundary (fails to link via @testable import even when declared
// internal), independent of any other factor. Wrapping construction in a
// plain C++ function sidesteps that: Swift only ever calls this function,
// never the constructor directly.
inline elem::AudioBufferResource makeAudioBufferResource(float** channelData, size_t numChannels, size_t numSamples) {
    return elem::AudioBufferResource(channelData, numChannels, numSamples);
}

// elem::SharedResource::getChannelData is a pure virtual method returning
// BufferView<float>, a non-trivial C++ template type. Swift's C++ interop
// can't call a pure-virtual override with that return type at all, even
// same-module. These give Swift value-returning extraction points instead.
inline float const* audioBufferResourceChannelData(elem::AudioBufferResource& resource, size_t channelIndex) {
    return resource.getChannelData(channelIndex).data();
}

inline size_t audioBufferResourceChannelSize(elem::AudioBufferResource& resource, size_t channelIndex) {
    return resource.getChannelData(channelIndex).size();
}

} // namespace elemswift
