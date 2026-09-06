#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Renderer.h"
#include "lib/NodeUtils.h"
#include "Runtime.h"

namespace elemswift {

using NodeRef = elem::NodeRef;
using RenderResult = elem::RenderResult;

/**
 * elemswift::Renderer is a direct alias for elem::Renderer<float>. Its
 * constructor takes an elemswift::RuntimeRef (std::shared_ptr<elem::Runtime<float>>),
 * the same shared handle type a Runtime is constructed through, so a Renderer
 * shares ownership of the Runtime it renders against.
 *
 * Note: unlike the old wrapper class, this alias is copyable — copying it
 * forks its internal ref-key counter (elem::Renderer's NodeId nextRefId),
 * which can cause colliding `__refKey:N` props between copies sharing a
 * runtime. Avoid copying; treat it as move-only in practice.
 */
using Renderer = elem::Renderer<float>;

// elem::Renderer<float>::renderGraph/createRef are header-only template methods.
// If Swift called them directly, Swift's own C++-interop compilation would become
// the first (and only) place some of their internal helper templates (e.g. the
// render-sequence-building machinery used by renderGraph) get instantiated. Those
// instantiations get weak/COMDAT linkage, and this package's build combines
// ElementaryCore's translation units into a single intermediate object before
// linking against the Elementary target — a combine step that, in this toolchain,
// silently demotes such weak template symbols to local/hidden even when a
// same-signature instantiation already exists elsewhere in ElementaryCore. The
// result is an "undefined symbol" at final link time that only reproduces once
// everything is linked together (swift test), not at compile time or at
// `swift build --target ElementaryCore`.
//
// Routing every call through these plain (non-template) free functions means the
// only place elem::Renderer<float>'s non-trivial methods (renderGraph/createRef)
// are ever called is here, inside ElementaryCore's own plain C++ compilation —
// never from Swift's interop layer — so this link failure can never happen again
// for these methods regardless of how the two targets get combined.
//
// (Renderer.swift does still call elem::Renderer<float>'s constructor directly —
// that's safe because its body is just a std::shared_ptr move and instantiates
// nothing that needs external linkage.)
RenderResult renderGraph(Renderer& renderer, lib::NodeReprSPtrVector graphs, elem::RenderOptions options);

NodeRef createRef(Renderer& renderer, std::string kind, elem::js::Object props, lib::NodeReprSPtrVector children);

} // namespace elemswift
