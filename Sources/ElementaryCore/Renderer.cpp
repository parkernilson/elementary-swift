#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"

namespace ElementaryCore {

Renderer::Renderer(const Runtime& runtime)
    : mRenderer{std::make_unique<elem::Renderer<float>>(runtime.mRuntime)} {}

//void Renderer::renderGraph(std::vector<elem::SymbolicGraphNode> graphs,
//                           elem::RenderOptions options) {
//    return mRenderer->renderGraph(std::move(graphs), std::move(options));
//}

} // namespace ElementaryCore
