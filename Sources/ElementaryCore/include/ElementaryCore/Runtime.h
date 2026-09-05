#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"
#include "../../../../Vendor/elementary/runtime/elem/Value.h"
#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"
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

    // Takes ownership of an already-constructed AudioBufferResource. Intended for
    // internal use by higher-level Swift helpers that already know how to decode
    // samples into an AudioBufferResource. Returns false if `name` is already taken.
    bool addSharedResource(std::string const& name, elem::AudioBufferResource resource);

    // Takes ownership of an arbitrary SharedResource implementation. This overload
    // exists for C++ consumers linking directly against ElementaryCore that define
    // their own SharedResource subclass — Swift can't subclass a C++ type, so this
    // isn't reachable from Swift, but it's a plain forward to the underlying
    // elem::Runtime for anyone building against this library in C++. Returns false
    // if `name` is already taken.
    bool addSharedResource(std::string const& name, std::unique_ptr<elem::SharedResource> resource);

    // Removes shared resources that are no longer referenced by any active graph node.
    void pruneSharedResources();

    // Returns the names of all currently registered shared resources.
    std::vector<std::string> getSharedResourceMapKeys();

private:
    friend class Renderer;
    /// The underlying Elementary runtime. It is hardcoded to float because AVAudioEngine on Apple platforms use Float32
    std::shared_ptr<elem::Runtime<float>> mRuntime;
};
} // namespace ElementaryCore
