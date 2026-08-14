#pragma once

#include <elem/Runtime.h>

#include <cstddef>
#include <memory>
#include <string>

// TODO: headers in include/CElementaryShim.h will auto generate mappings
// TODO: I should create mappings for 

namespace ElementarySwift {

// Concrete, non-template class -- the only thing Swift's C++ importer sees.
// Wraps elem::Runtime<float> via pimpl so the template never leaks into
// this public header. This is necessary because Swift C++ interop cannot import
// templates
class ElementaryRuntime {
public:
    ElementaryRuntime(double sampleRate, int blockSize);
    ~ElementaryRuntime();

    ElementaryRuntime(const ElementaryRuntime&) = delete;
    ElementaryRuntime& operator=(const ElementaryRuntime&) = delete;
    // Defined in the .cpp (not '= default' here) since Impl is incomplete
    // in this header -- unique_ptr's move operations need the full type.
    ElementaryRuntime(ElementaryRuntime&&);
    ElementaryRuntime& operator=(ElementaryRuntime&&);

    // Realtime audio callback. Non-interleaved buffers, matching
    // elem::Runtime<float>::process exactly. Pointers may be null when
    // numInputChannels/numOutputChannels == 0.
    void process(
        const float** inputChannelData, size_t numInputChannels,
        float** outputChannelData, size_t numOutputChannels,
        size_t numSamples);

    void reset();

private:
    std::unique_ptr<elem::Runtime<float>> runtime;
};

} // namespace elementary_swift
