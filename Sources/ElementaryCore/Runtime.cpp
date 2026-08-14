#include "ElementaryCore/Runtime.h"

namespace ElementaryCore {

Runtime::Runtime(double sampleRate, int blockSize): runtime{std::make_unique<elem::Runtime<float>>(sampleRate, blockSize)} {}

// TODO: Are these necessary here?
//~Runtime() = default;
//Runtime(Runtime&&) = default;
//Runtime& Runtime::operator=(Runtime&&) = default;

void Runtime::process(
    const float** inputChannelData, size_t numInputChannels,
    float** outputChannelData, size_t numOutputChannels,
    size_t numSamples)
{
    runtime->process(
        inputChannelData, numInputChannels,
        outputChannelData, numOutputChannels,
        numSamples, nullptr);
}

void Runtime::reset() {
    runtime.reset();
}

} // namespace ElementarySwift
