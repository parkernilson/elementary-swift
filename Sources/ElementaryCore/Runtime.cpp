#include "ElementaryCore/Runtime.h"

namespace elemswift {

RuntimeRef makeRuntime(double sampleRate, int blockSize) {
    return std::make_shared<Runtime>(sampleRate, blockSize);
}

int registerNodeType(Runtime& runtime, std::string const& type, Runtime::NodeFactoryFn fn) {
    return runtime.registerNodeType(type, std::move(fn));
}

void processQueuedEvents(Runtime& runtime, ProcessEventsCallbackFn evtCallback) {
    runtime.processQueuedEvents([evtCallback = std::move(evtCallback)](std::string const& name, elem::js::Value value) {
        evtCallback(name, std::move(value));
    });
}

std::vector<NodeId> gc(Runtime& runtime) {
    auto const removed = runtime.gc();
    return std::vector<NodeId>(removed.begin(), removed.end());
}

bool addSharedResource(Runtime& runtime, std::string const& name, elem::AudioBufferResource resource) {
    auto ptr = std::make_unique<elem::AudioBufferResource>(std::move(resource));
    return runtime.addSharedResource(name, std::move(ptr));
}

std::vector<std::string> getSharedResourceMapKeys(Runtime& runtime) {
    // `keys` is a MapKeyView whose iterator's `iterator_traits::value_type` is
    // inherited from the underlying map's iterator (a std::pair), even though
    // operator* returns a std::string&. That mismatch makes the
    // std::vector(InputIt, InputIt) range constructor's SFINAE check fail, so we
    // build the vector manually via a range-based for loop instead, which only
    // relies on operator* and not on iterator_traits.
    auto keys = runtime.getSharedResourceMapKeys();
    std::vector<std::string> result;
    for (auto const& key : keys) {
        result.push_back(key);
    }
    return result;
}

} // namespace elemswift
