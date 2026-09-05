#pragma once

#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"
#include "../../../../Vendor/elementary/runtime/elem/Value.h"
#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"
#include "GraphNode.h"

#include <cstddef>
#include <functional>
#include <memory>
#include <string>
#include <utility>
#include <vector>

namespace elemswift {

/**
 * elemswift::Runtime is a direct alias for elem::Runtime<float>. FloatType is
 * hardcoded to float since AVAudioEngine uses Float32.
 *
 * elemswift::RuntimeRef is the shared handle type used everywhere a Runtime
 * needs to be passed around or shared with a Renderer: elem::Renderer<float>'s
 * constructor takes exactly this type (std::shared_ptr<elem::Runtime<float>>).
 */
using Runtime = elem::Runtime<float>;
using RuntimeRef = std::shared_ptr<Runtime>;

// Constructs a new Runtime, returning a shared handle so it can be wired up
// to an elemswift::Renderer.
RuntimeRef makeRuntime(double sampleRate, int blockSize);

// elem::Runtime::registerNodeType takes its factory function by rvalue
// reference (NodeFactoryFn&&), which Swift's C++ interop can't call directly.
// This takes the factory by value and moves it into the real call.
int registerNodeType(Runtime& runtime, std::string const& type, Runtime::NodeFactoryFn fn);

/// In order to make this swift friendly, we have to copy the event name by value instead of const&
using ProcessEventsCallbackFn = std::function<void(std::string, elem::js::Value)>;
void processQueuedEvents(Runtime& runtime, ProcessEventsCallbackFn evtCallback);

// Releases unused graph nodes, returning the ids of the nodes that were cleared.
// std::set doesn't support for-in on this deployment target, so this hands
// back a std::vector instead, which Swift can iterate.
std::vector<NodeId> gc(Runtime& runtime);

// Takes ownership of an already-constructed AudioBufferResource, wrapping it in
// the unique_ptr<SharedResource> that elem::Runtime::addSharedResource requires
// - Swift can't construct that unique_ptr itself. Returns false if `name` is
// already taken.
bool addSharedResource(Runtime& runtime, std::string const& name, elem::AudioBufferResource resource);

// Returns the names of all currently registered shared resources.
std::vector<std::string> getSharedResourceMapKeys(Runtime& runtime);

} // namespace elemswift
