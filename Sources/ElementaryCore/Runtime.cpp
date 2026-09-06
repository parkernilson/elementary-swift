#include "ElementaryCore/Runtime.h"

namespace elemswift {

Runtime::Runtime(double sampleRate, int blockSize): mRuntime{std::make_shared<elem::Runtime<float>>(sampleRate, blockSize)} {}

Runtime::~Runtime() = default;

Runtime::Runtime(std::shared_ptr<elem::Runtime<float>> runtime): mRuntime{std::move(runtime)} {}

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

// TODO: Add comment about why we can't pass std::shared_ptr<elem::AudioBufferResource> from Swift
bool Runtime::addSharedResource(std::string const& name, elem::AudioBufferResource resource) {
    auto ptr = std::make_unique<elem::AudioBufferResource>(std::move(resource));
    return mRuntime->addSharedResource(name, std::move(ptr));
}

bool Runtime::addSharedResource(std::string const& name, std::unique_ptr<elem::SharedResource> resource) {
    return mRuntime->addSharedResource(name, std::move(resource));
}

void Runtime::pruneSharedResources() {
    mRuntime->pruneSharedResources();
}

// TODO: Add a comment about why this signature is different between elem and elemswift
std::vector<std::string> Runtime::getSharedResourceMapKeys() {
    // `keys` is a MapKeyView whose iterator's `iterator_traits::value_type` is
    // inherited from the underlying map's iterator (a std::pair), even though
    // operator* returns a std::string&. That mismatch makes the
    // std::vector(InputIt, InputIt) range constructor's SFINAE check fail, so we
    // build the vector manually via a range-based for loop instead, which only
    // relies on operator* and not on iterator_traits.
    auto keys = mRuntime->getSharedResourceMapKeys();
    std::vector<std::string> result;
    for (auto const& key : keys) {
        result.push_back(key);
    }
    return result;
}

} // namespace ElementaryCore
