#pragma once

#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"

#include <cstddef>

namespace elemswift {

using BufferViewFloat = elem::BufferView<float>;

// elem::AudioBufferResource's own (float**, size_t, size_t) constructor is unannotated,
// so Swift imports its parameter with an extra Optional on the inner pointer
// (UnsafeMutablePointer<UnsafeMutablePointer<Float>?>) that doesn't match
// AVAudioPCMBuffer.floatChannelData's shape (UnsafePointer<UnsafeMutablePointer<Float>>?
// — note the outer pointer is a const UnsafePointer, only the inner is mutable) — forcing
// a manual rebuild into an array of optional inner pointers on the Swift side. Explicit
// nullability + constness annotations here make this wrapper's imported parameter type
// match floatChannelData exactly (once its outer Optional is unwrapped), so it can be
// passed straight through with no rebuild.
inline elem::AudioBufferResource makeAudioBufferResource(
    float * _Nonnull const * _Nonnull channelData,
    size_t numChannels,
    size_t numSamples
) {
    return elem::AudioBufferResource(const_cast<float**>(channelData), numChannels, numSamples);
}

// elem::SharedResource::getChannelData is a pure virtual method returning
// BufferView<float>, a non-trivial C++ template type. Swift's C++ interop
// can't call a pure-virtual override with a complex return type
inline BufferViewFloat audioBufferResourceChannelDataGet(elem::AudioBufferResource& resource, size_t channelIndex) {
    return resource.getChannelData(channelIndex);
}

} // namespace elemswift
