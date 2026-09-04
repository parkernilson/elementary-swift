#include "ElementaryCore/Runtime.h"

namespace elemswift {

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

void Runtime::processQueuedEvents(ProcessEventsCallbackFn evtCallback) {
    mRuntime->processQueuedEvents(std::move(evtCallback));
}

void Runtime::reset() {
    mRuntime.reset();
}

int Runtime::registerNodeType(std::string const& type, NodeFactoryFn&& fn) {
    return mRuntime->registerNodeType(type, std::move(fn));
}

std::vector<elem::NodeId> Runtime::gc() {
    auto const removed = mRuntime->gc();
    return std::vector<elem::NodeId>(removed.begin(), removed.end());
}

} // namespace ElementaryCore
