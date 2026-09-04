#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Renderer.h"
#include "lib/NodeUtils.h"
#include "Runtime.h"

namespace elemswift {

using NodeRef = elem::NodeRef;

class Renderer {
public:
    explicit Renderer(const elemswift::Runtime& runtime);
    ~Renderer();
    
    Renderer(const Renderer&) = delete;
    Renderer& operator=(const Renderer&) = delete;
    Renderer(const Renderer&&);
    Renderer& operator=(const Renderer&&);
    
    void renderGraph(lib::NodeReprSPtrVector graphs, elem::RenderOptions options);
    
    NodeRef createRef(std::string kind, elem::js::Object props, lib::NodeReprSPtrVector children);
    
private:
    std::unique_ptr<elem::Renderer<float>> mRenderer;
};

}
