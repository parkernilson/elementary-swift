#pragma once

// Demonstrates including a vendored elementary runtime header from a
// dependent SwiftPM package, via the ElementaryRuntime product.
#include "elem/GraphNode.h"

namespace CustomNodes
{

    // A minimal custom GraphNode: applies a constant "gain" property to the
    // first input channel.
    template <typename FloatType>
    struct CustomGainNode : public elem::GraphNode<FloatType>
    {
        using elem::GraphNode<FloatType>::GraphNode;

        void process(elem::BlockContext<FloatType> const& ctx) override
        {
            auto const gain = this->template getPropertyWithDefault<elem::js::Number>("gain", 1.0);

            for (size_t i = 0; i < ctx.numSamples; ++i)
            {
                auto const in = (ctx.numInputChannels > 0) ? ctx.inputData[0][i] : FloatType(0);

                for (size_t j = 0; j < ctx.numOutputChannels; ++j)
                    ctx.outputData[j][i] = static_cast<FloatType>(gain) * in;
            }
        }
    };

} // namespace CustomNodes
