#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"

namespace elemswift {

/**
 * ElementaryCore::Renderer is just a lightweight shim layer around the underlying
 * elem::Renderer<FloatType> so that we can expose its methods and constructors with 
 * Swift friendly types.
 * 
 * We use friend class status to grab a shared_ptr to `runtime.mRuntime` So that we can wire
 * up the underlying `elem::Renderer` directly to `elem::Runtime`.
 * 
 * FloatType is hardcoded to float since AVAudioEngine uses Float32.
 */
Renderer::Renderer(const Runtime& runtime)
    : mRenderer{std::make_unique<elem::Renderer<float>>(runtime.mRuntime)} {}

Renderer::~Renderer() = default;

Renderer::Renderer(const Renderer&& other) : mRenderer{std::move(const_cast<Renderer&>(other).mRenderer)} {}

Renderer& Renderer::operator=(const Renderer&& other) {
    mRenderer = std::move(const_cast<Renderer&>(other).mRenderer);
    return *this;
}

void Renderer::renderGraph(lib::NodeReprSPtrVector graphs,
                           elem::RenderOptions options) {
    mRenderer->renderGraph(std::move(graphs), std::move(options));
    
    // TODO: Return RenderStats
}

NodeRef Renderer::createRef(std::string kind, elem::js::Object props, lib::NodeReprSPtrVector children) {
    return mRenderer->createRef(std::move(kind), std::move(props), std::move(children));
}

} // namespace ElementaryCore
