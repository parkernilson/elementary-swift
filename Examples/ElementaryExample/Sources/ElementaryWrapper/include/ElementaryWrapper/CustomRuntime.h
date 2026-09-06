#pragma once

#include <ElementaryCore/Runtime.h>

namespace CustomRuntime
{

    // Constructs an ElementaryCore::Runtime with this example's custom node
    // types registered on it, ready to hand to an ElementaryCore::Renderer.
    elemswift::RuntimeRef makeElementaryRuntime(double sampleRate, int blockSize);

} // namespace CustomNodes
