#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"

#include <cstddef>
#include <memory>
#include <string>

// TODO: We should use PIMPL pattern to hide all the internal elem headers from the ElementaryCore public interface

namespace elemswift {

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

    void reset();

    using NodeFactoryFn = elem::Runtime<float>::NodeFactoryFn;
    int registerNodeType(std::string const& type, NodeFactoryFn&& fn);

private:
    friend class Renderer;
    /// The underlying Elementary runtime. It is hardcoded to float because AVAudioEngine on Apple platforms use Float32
    std::shared_ptr<elem::Runtime<float>> mRuntime;
};
} // namespace ElementaryCore
