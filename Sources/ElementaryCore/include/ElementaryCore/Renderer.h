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
 */
using Renderer = elem::Renderer<float>;

} // namespace elemswift
