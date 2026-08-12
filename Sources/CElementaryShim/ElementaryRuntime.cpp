#include "CElementaryShim/ElementaryRuntime.h"
#include <elem/Runtime.h>

namespace ElementarySwift {

// TODO: Why was the pimpl pattern necessary here?
struct ElementaryRuntime::Impl {
    elem::Runtime<float> runtime;
    Impl(double sampleRate, int blockSize) : runtime(sampleRate, blockSize) {}
};

ElementaryRuntime::ElementaryRuntime(double sampleRate, int blockSize)
    : impl_(std::make_unique<Impl>(sampleRate, blockSize)) {}

ElementaryRuntime::~ElementaryRuntime() = default;
ElementaryRuntime::ElementaryRuntime(ElementaryRuntime&&) = default;
ElementaryRuntime& ElementaryRuntime::operator=(ElementaryRuntime&&) = default;

int ElementaryRuntime::applyInstructionsJSON(const std::string& json) {
    auto parsed = elem::js::parseJSON(json);
    return impl_->runtime.applyInstructions(parsed);
}

void ElementaryRuntime::process(
    const float** inputChannelData, size_t numInputChannels,
    float** outputChannelData, size_t numOutputChannels,
    size_t numSamples)
{
    impl_->runtime.process(
        inputChannelData, numInputChannels,
        outputChannelData, numOutputChannels,
        numSamples, nullptr);
}

void ElementaryRuntime::reset() {
    impl_->runtime.reset();
}

} // namespace elementary_swift
