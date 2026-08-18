#pragma once

#include <elem/SymbolicGraph.h>
#include <elem/Renderer.h>
#include "ElementaryCore/Runtime.h"

namespace ElementaryCore {

// TODO: Renderer wrapper
class Renderer {
public:
    Renderer(const ElementaryCore::Runtime& runtime);
    ~Renderer();
    
    Renderer(const Renderer&) = delete;
    Renderer& operator=(const Renderer&) = delete;
    Renderer(const Renderer&&);
    Renderer& operator=(const Renderer&&);
    
    void renderGraph(std::vector<elem::SymbolicGraphNode> graphs, elem::RenderOptions options);
    
private:
    std::unique_ptr<elem::Renderer<float>> mRenderer;
};

}
