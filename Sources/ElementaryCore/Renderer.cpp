#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"

namespace ElementaryCore {

Renderer::Renderer(const Runtime& runtime)
    : mRenderer{std::make_unique<elem::Renderer<float>>(runtime.mRuntime)} {}

Renderer::~Renderer() = default;

Renderer::Renderer(const Renderer&& other) : mRenderer{std::move(const_cast<Renderer&>(other).mRenderer)} {}

Renderer& Renderer::operator=(const Renderer&& other) {
    mRenderer = std::move(const_cast<Renderer&>(other).mRenderer);
    return *this;
}

void Renderer::renderGraph(NodeReprSPtrVector graphs,
                           elem::RenderOptions options) {
    mRenderer->renderGraph(std::move(graphs), std::move(options));
    
    // TODO: Should we return RenderStats?
}

} // namespace ElementaryCore
