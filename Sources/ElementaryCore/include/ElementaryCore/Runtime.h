#pragma once

#include <elem/Runtime.h>

#include <cstddef>
#include <memory>
#include <string>

// TODO: headers in include/CElementaryShim.h will auto generate mappings
// TODO: I should create mappings for 

namespace ElementaryCore {

// Concrete, non-template class -- the only thing Swift's C++ importer sees.
// Wraps elem::Runtime<float> via pimpl so the template never leaks into
// this public header. This is necessary because Swift C++ interop cannot import
// templates
class Runtime {
public:
    Runtime(double sampleRate, int blockSize);
    ~Runtime();

    Runtime(const Runtime&) = delete;
    Runtime& operator=(const Runtime&) = delete;
    Runtime(Runtime&&);
    Runtime& operator=(Runtime&&);

    // Realtime audio callback. Non-interleaved buffers, matching
    // elem::Runtime<float>::process exactly. Pointers may be null when
    // numInputChannels/numOutputChannels == 0.
    void process(
        const float** inputChannelData, size_t numInputChannels,
        float** outputChannelData, size_t numOutputChannels,
        size_t numSamples);

    void reset();

private:
    friend class Renderer;
    std::shared_ptr<elem::Runtime<float>> mRuntime;
};

} // namespace ElementaryCore
