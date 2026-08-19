#include "ElementaryCore/Runtime.h"

namespace ElementaryCore {

Runtime::Runtime(double sampleRate, int blockSize): mRuntime{std::make_shared<elem::Runtime<float>>(sampleRate, blockSize)} {}

Runtime::~Runtime() = default;

Runtime::Runtime(Runtime&&) = default;
Runtime& Runtime::operator=(Runtime&&) = default;

void Runtime::process(
    const float** inputChannelData, size_t numInputChannels,
    float** outputChannelData, size_t numOutputChannels,
    size_t numSamples)
{
    mRuntime->process(
        inputChannelData, numInputChannels,
        outputChannelData, numOutputChannels,
        numSamples, nullptr);
}

void Runtime::reset() {
    mRuntime.reset();
}

} // namespace ElementaryCore
