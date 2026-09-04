#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"
#include "../../../../Vendor/elementary/runtime/elem/Value.h"
#include "GraphNode.h"

#include <cstddef>
#include <memory>
#include <string>
#include <utility>
#include <vector>

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

    /// In order to make this swift friendly, we have to copy the event name by value instead of const&
    using ProcessEventsCallbackFn = std::function<void(std::string, elem::js::Value)>;
    void processQueuedEvents(ProcessEventsCallbackFn evtCallback);
    
    void reset();
    
    using NodeFactoryFn = elem::Runtime<float>::NodeFactoryFn;
    int registerNodeType(std::string const& type, NodeFactoryFn&& fn);
    
    // Releases unused graph nodes, returning the ids of the nodes that were cleared.
    // std::set doesn't support for-in on this deployment target, so this hands
    // back a std::vector instead, which Swift can iterate.
    std::vector<NodeId> gc();

    // TODO: Implement shared resources
    
private:
    friend class Renderer;
    /// The underlying Elementary runtime. It is hardcoded to float because AVAudioEngine on Apple platforms use Float32
    std::shared_ptr<elem::Runtime<float>> mRuntime;
};
} // namespace ElementaryCore
