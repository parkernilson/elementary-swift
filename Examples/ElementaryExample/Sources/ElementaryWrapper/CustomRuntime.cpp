#include "ElementaryWrapper/CustomRuntime.h"
#include "ElementaryWrapper/CustomGainNode.h"

namespace CustomRuntime 
{

    elemswift::RuntimeRef makeElementaryRuntime(double sampleRate, int blockSize)
    {
        auto runtime = elemswift::makeRuntime(sampleRate, blockSize);

        elemswift::registerNodeType(runtime, "customGain", [](elemswift::NodeId const id, double sr, int bs) {
            return std::make_shared<CustomNodes::CustomGainNode>(id, sr, static_cast<size_t>(bs));
        });

        return runtime;
    }

} // namespace CustomNodes
