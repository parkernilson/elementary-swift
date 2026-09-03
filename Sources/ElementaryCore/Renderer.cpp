#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"

namespace ElementaryCore {

/**
 * Since ElementaryCore::Runtime and ElementaryCore::Renderer are just a lightweight shim layer
 * around the underlying elem::Runtime<FloatType> and elem::Renderer<FloatType> so that we can expose
 * their methods and constructors with Swift friendly types.
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

// TODO: implement createRef

void Renderer::renderGraph(NodeReprSPtrVector graphs,
                           elem::RenderOptions options) {
    mRenderer->renderGraph(std::move(graphs), std::move(options));
    
    // TODO: Return RenderStats
}

} // namespace ElementaryCore
