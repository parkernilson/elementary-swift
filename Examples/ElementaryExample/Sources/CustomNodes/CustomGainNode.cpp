#include "CustomNodes/CustomGainNode.h"

namespace CustomNodes
{

    // Explicit instantiation to confirm CustomGainNode compiles against the
    // vendored elem::GraphNode<FloatType> from ElementaryRuntime.
    template struct CustomGainNode<float>;
    template struct CustomGainNode<double>;

} // namespace CustomNodes
