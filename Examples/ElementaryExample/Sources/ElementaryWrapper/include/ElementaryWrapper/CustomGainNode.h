#pragma once

#include <ElementaryCore/GraphNode.h>

namespace CustomNodes
{

    // A minimal custom GraphNode: applies a constant "gain" property to the
    // first input channel.
    struct CustomGainNode : public elemswift::GraphNode
    {
        using elemswift::GraphNode::GraphNode;

        void process(elemswift::BlockContext const& ctx) override
        {
            auto const gain = getPropertyWithDefault<elemswift::Number>("gain", 1.0);

            for (size_t i = 0; i < ctx.numSamples; ++i)
            {
                auto const in = (ctx.numInputChannels > 0) ? ctx.inputData[0][i] : 0.0f;

                for (size_t j = 0; j < ctx.numOutputChannels; ++j)
                    ctx.outputData[j][i] = static_cast<float>(gain) * in;
            }
        }
    };

} // namespace CustomNodes
