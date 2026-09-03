#include "ElementaryWrapper/CustomRuntime.h"
#include "ElementaryWrapper/CustomGainNode.h"

namespace CustomRuntime 
{

    elemswift::Runtime makeElementaryRuntime(double sampleRate, int blockSize)
    {
        elemswift::Runtime runtime(sampleRate, blockSize);

        runtime.registerNodeType("customGain", [](elemswift::NodeId const id, double sr, int bs) {
            return std::make_shared<CustomNodes::CustomGainNode>(id, sr, static_cast<size_t>(bs));
        });

        return runtime;
    }

} // namespace CustomNodes
