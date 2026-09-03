#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"

#include <cstddef>
#include <memory>
#include <string>

namespace ElementaryCore {

class Runtime {
public:
    Runtime(double sampleRate, int blockSize);
    ~Runtime();

    Runtime(const Runtime&) = delete;
    Runtime& operator=(const Runtime&) = delete;
    Runtime(Runtime&&);
    Runtime& operator=(Runtime&&);

    void process(
        const float** inputChannelData, size_t numInputChannels,
        float** outputChannelData, size_t numOutputChannels,
        size_t numSamples);
    
    // TODO: Implement event processing
    
    // TODO: Implement createRef (or similar feature)
    
    void reset();

private:
    friend class Renderer;
    std::shared_ptr<elem::Runtime<float>> mRuntime;
};

} // namespace ElementaryCore
