#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"
#include "GraphNode.h"

#include <cstddef>
#include <functional>
#include <memory>
#include <string>

namespace ElementaryCore {

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

    // TODO: Implement createRef (or similar feature)

    void reset();

    // Registers a factory for a custom GraphNode subclass under the given
    // node type name, so that graphs rendered on this Runtime may
    // reference it. Must be called before rendering a graph that uses `type`.
    using NodeFactoryFn = std::function<std::shared_ptr<GraphNode>(NodeId const id, double sampleRate, int const blockSize)>;
    int registerNodeType(std::string const& type, NodeFactoryFn&& fn);

private:
    friend class Renderer;
    std::shared_ptr<elem::Runtime<float>> mRuntime;
};

} // namespace ElementaryCore
