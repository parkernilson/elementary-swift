#include "ElementaryWrapper/CustomRuntime.h"
#include "ElementaryWrapper/CustomGainNode.h"

namespace CustomRuntime 
{

    elemswift::Runtime makeElementaryRuntime(double sampleRate, int blockSize)
    {
        auto runtime = std::make_shared<elem::Runtime<float>>(sampleRate, blockSize);

        runtime->registerNodeType("customGain", [](elemswift::NodeId const id, double sr, int bs) {
            return std::make_shared<CustomNodes::CustomGainNode>(id, sr, static_cast<size_t>(bs));
        });

        return elemswift::Runtime(std::move(runtime));
    }

} // namespace CustomNodes
