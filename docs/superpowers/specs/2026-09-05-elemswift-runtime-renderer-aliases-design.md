# elemswift Runtime/Renderer as thin type aliases

> **Amended during implementation:** The design below turned out to have two real bugs, fixed in commit `d32ad59`. (1) Swift's C++ interop cannot dereference `std::shared_ptr<T>` (no `.pointee`/`.get()`), so free functions can't take `Runtime&` and be called via `coreRuntime.pointee` from Swift — the actual free functions in `Runtime.h` take `elemswift::RuntimeRef` (the `shared_ptr`) by value instead. (2) "`Renderer.h` becomes alias-only; `Renderer.cpp` is deleted" caused a real undefined-symbol link error at `swift test` time, root-caused to a weak template symbol getting demoted to local linkage when SwiftPM combines ElementaryCore's object files; `Renderer.cpp` was restored with plain free functions `elemswift::renderGraph`/`elemswift::createRef` instead of calling `elem::Renderer<float>`'s template methods directly from Swift. See `.superpowers/sdd/2026-09-05-elemswift-runtime-renderer-aliases/progress.md` for the full investigation. The body below is left as originally written (what was planned), not as what shipped.

## Problem

`elemswift::Runtime` and `elemswift::Renderer` (`Sources/ElementaryCore/{Runtime,Renderer}.{h,cpp}`) are hand-written wrapper classes around `elem::Runtime<float>` / `elem::Renderer<float>`. Most of their methods are pure forwards with no adaptation. This duplicates a template-instantiation-as-alias pattern that's already established elsewhere in `ElementaryCore` (`GraphNode.h`: `using GraphNode = elem::GraphNode<float>;`, `AudioBufferResource.h`: free functions for the handful of calls Swift can't make directly). Bringing `Runtime`/`Renderer` in line removes the wrapper boilerplate and re-uses more of the underlying C++ automatically via Swift's C++ interop.

## Design

### Core aliases

`Runtime.h`:
```cpp
namespace elemswift {
using Runtime = elem::Runtime<float>;
using RuntimeRef = std::shared_ptr<Runtime>;
}
```

`Renderer.h`:
```cpp
namespace elemswift {
using Renderer = elem::Renderer<float>; // ctor already takes std::shared_ptr<elem::Runtime<float>>, i.e. RuntimeRef
}
```

`elem::Renderer<FloatType>`'s constructor requires a `std::shared_ptr<elem::Runtime<FloatType>>`, so `RuntimeRef` (not a bare `Runtime` value) is the handle type that Swift and any C++ consumer hold and share between a `Runtime` and its `Renderer`.

### Free functions in `elemswift` (Runtime.h/.cpp)

Only for behavior that can't be expressed as a direct call from Swift:

- `RuntimeRef makeRuntime(double sampleRate, int blockSize)` — `std::make_shared<Runtime>(...)`.
- `int registerNodeType(Runtime&, std::string type, Runtime::NodeFactoryFn fn)` — `elem::Runtime::registerNodeType` takes `NodeFactoryFn&&`; Swift can't call rvalue-reference parameters, so this takes the factory by value and moves it into the real call.
- `void processQueuedEvents(Runtime&, std::function<void(std::string, elem::js::Value)> callback)` — adapts a by-value-name callback to elem's `std::function<void(std::string const&, js::Value)>` signature (Swift closures need value types, not `const&`).
- `std::vector<NodeId> gc(Runtime&)` — converts elem's `std::set<NodeId>` result to a `std::vector`, since Swift can't iterate `std::set`.
- `bool addSharedResource(Runtime&, std::string const& name, elem::AudioBufferResource resource)` — wraps the resource in a `unique_ptr<SharedResource>` and forwards to elem's unique_ptr-taking overload, since Swift can't construct that unique_ptr itself.
- `std::vector<std::string> getSharedResourceMapKeys(Runtime&)` — converts elem's `KeyViewType` to a `std::vector<std::string>` (iterator/value_type mismatch prevents Swift, and even a generic range-constructor, from consuming it directly).

Called **directly on `Runtime`, no wrapper**: `process(...)`, `reset()`, `pruneSharedResources()`. These are plain forwards today with no adaptation needed.

Note: the current wrapper's `reset()` incorrectly does `mRuntime.reset()` (nulling the owning `shared_ptr` rather than resetting graph state). Calling `elem::Runtime::reset()` directly fixes this as a side effect of the refactor.

### Renderer.h/.cpp

`Renderer.h` becomes alias-only; `Renderer.cpp` is deleted. `renderGraph` and `createRef` are called directly on the `elemswift::Renderer` value — the existing wrapper methods were pure forwards with no adaptation, so no free functions are needed for these.

### Swift-side changes (`Sources/Elementary`)

`Runtime.swift`:
- `coreRuntime` changes type from `elemswift.Runtime` to `elemswift.RuntimeRef`.
- `init(sampleRate:blockSize:)` calls `elemswift.makeRuntime(sampleRate, blockSize)`.
- The public `init(_ runtime:)` (used by consumers building a custom runtime in C++) takes `elemswift.RuntimeRef` instead of `consuming elemswift.Runtime`.
- `process`, `reset`, `pruneSharedResources` call directly through the shared ref.
- `processQueuedEvents`, `gc`, `addSharedResource`, `getSharedResourceMapKeys` route through the corresponding `elemswift` free functions. Exact call spelling against the imported shared_ptr API (e.g. whether `.pointee` is needed) is worked out during implementation and verified by building.

`Renderer.swift`:
- `coreRenderer: elemswift.Renderer` is constructed directly as `elemswift.Renderer(runtime.coreRuntime)`.
- `renderGraph`/`createRef` unchanged in shape, called directly on `coreRenderer`.

### Example app (`Examples/ElementaryExample`) — breaking change, confirmed acceptable

`CustomRuntime::makeElementaryRuntime` currently constructs an `elemswift::Runtime` by value and registers a node type on it before returning it by value to Swift. It changes to:
- Build via `elemswift::makeRuntime(sampleRate, blockSize)` to get an `elemswift::RuntimeRef`.
- Register the node type via the new free function `elemswift::registerNodeType(*runtime, "customGain", ...)`.
- Return `elemswift::RuntimeRef` instead of `elemswift::Runtime`.

`AudioPlayer.swift`'s call site (`Elementary.Runtime(CustomRuntime.makeElementaryRuntime(...))`) is unchanged in shape — it keeps working once `Runtime.init(_:)` accepts a `RuntimeRef`.

## Out of scope

- No changes to `GraphNode.h`, `AudioBufferResource.h`, or any other already-aliased type.
- No changes to `NodeRepr`/`NodeUtils` conversion helpers.
- No new tests — this is a build-correctness refactor with no behavior change visible to existing Swift tests (none of which touch `elemswift` types directly). Verification is `swift build` / `swift test` on the main package and the Examples package.

## Verification plan

1. `swift build` and `swift test` in the main package.
2. `swift build` (or open/build) the `Examples/ElementaryExample` package, since it's the only consumer of the `elemswift::Runtime` C++-level API surface being changed.
