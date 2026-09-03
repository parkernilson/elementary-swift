#include "CustomNodes/CustomRuntime.h"
#include "CustomNodes/CustomGainNode.h"

namespace CustomNodes
{

    ElementaryCore::Runtime makeElementaryRuntime(double sampleRate, int blockSize)
    {
        ElementaryCore::Runtime runtime(sampleRate, blockSize);

        runtime.registerNodeType("customGain", [](ElementaryCore::NodeId const id, double sr, int bs) {
            return std::make_shared<CustomGainNode>(id, sr, static_cast<size_t>(bs));
        });

        return runtime;
    }

} // namespace CustomNodes
