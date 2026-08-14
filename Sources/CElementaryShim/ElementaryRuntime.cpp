#include "CElementaryShim/ElementaryRuntime.h"
#include <elem/Runtime.h>

namespace ElementarySwift {

ElementaryRuntime::ElementaryRuntime(double sampleRate, int blockSize): runtime{std::make_unique<elem::Runtime<float>>(sampleRate, blockSize)} {}

ElementaryRuntime::~ElementaryRuntime() = default;
ElementaryRuntime::ElementaryRuntime(ElementaryRuntime&&) = default;
ElementaryRuntime& ElementaryRuntime::operator=(ElementaryRuntime&&) = default;

void ElementaryRuntime::process(
    const float** inputChannelData, size_t numInputChannels,
    float** outputChannelData, size_t numOutputChannels,
    size_t numSamples)
{
    runtime->process(
        inputChannelData, numInputChannels,
        outputChannelData, numOutputChannels,
        numSamples, nullptr);
}

void ElementaryRuntime::reset() {
    runtime.reset();
}

} // namespace ElementarySwift
