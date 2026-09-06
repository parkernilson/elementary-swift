#include "ElementaryCore/Renderer.h"

namespace elemswift {

RenderResult renderGraph(Renderer& renderer, lib::NodeReprSPtrVector graphs, elem::RenderOptions options) {
    return renderer.renderGraph(std::move(graphs), std::move(options));
}

NodeRef createRef(Renderer& renderer, std::string kind, elem::js::Object props, lib::NodeReprSPtrVector children) {
    return renderer.createRef(std::move(kind), std::move(props), std::move(children));
}

} // namespace elemswift
