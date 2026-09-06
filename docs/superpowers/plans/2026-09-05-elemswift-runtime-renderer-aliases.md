# elemswift Runtime/Renderer Alias Refactor Implementation Plan

> **Amended during implementation:** The design below turned out to have two real bugs, fixed in commit `d32ad59`. (1) Swift's C++ interop cannot dereference `std::shared_ptr<T>` (no `.pointee`/`.get()`), so the plan's `Runtime&`-taking free functions and `coreRuntime.pointee` calls are wrong — the actual free functions in `Runtime.h` take `elemswift::RuntimeRef` (the `shared_ptr`) by value instead. (2) "`Renderer.h` becomes alias-only, no `.cpp` needed" caused a real undefined-symbol link error at `swift test` time, root-caused to a weak template symbol getting demoted to local linkage when SwiftPM combines ElementaryCore's object files; `Renderer.cpp` was restored with plain free functions `elemswift::renderGraph`/`elemswift::createRef`. See `.superpowers/sdd/2026-09-05-elemswift-runtime-renderer-aliases/progress.md` for the full investigation. The body below is left as originally written (what was planned), not as what shipped.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the hand-written `elemswift::Runtime`/`elemswift::Renderer` wrapper classes with thin `using` type aliases over `elem::Runtime<float>`/`elem::Renderer<float>`, plus free functions for the handful of calls Swift can't make directly.

**Architecture:** `Runtime.h`/`Renderer.h` become alias declarations (`using Runtime = elem::Runtime<float>;` etc.), matching the pattern already used in `GraphNode.h` and `AudioBufferResource.h`. `Runtime.cpp` keeps only free functions that adapt behavior elem's API can't expose to Swift directly (rvalue-ref params, `std::set` results, etc.); everything else is called straight through from Swift. `Renderer.cpp` is deleted entirely since its methods were pure forwards. The Swift classes `Runtime`/`Renderer` (in `Sources/Elementary`) hold a `std::shared_ptr<elem::Runtime<float>>` (`elemswift::RuntimeRef`) instead of the old wrapper value, since that's the exact type `elem::Renderer<float>`'s constructor requires for sharing ownership.

**Tech Stack:** Swift 6 / C++17, SwiftPM `interoperabilityMode(.Cxx)`, the vendored Elementary C++ runtime under `Vendor/elementary`.

## Global Constraints

- No new tests are added — this is a build-correctness refactor with no intended behavior change. Existing tests (`Tests/ElementaryTests/SharedResourceTests.swift`, `ElementaryRuntimeSmokeTests.swift`, `AudioFileResourceTests.swift`) must keep passing unchanged.
- Public Swift API names on `Elementary.Runtime`/`Elementary.Renderer` (`process`, `reset`, `processQueuedEvents`, `gc`, `pruneSharedResources`, `sharedResourceKeys`, `addSharedResource`, `renderGraph`, `createRef`) must keep their existing signatures — only their C++ plumbing changes.
- The example app (`Examples/ElementaryExample`) is a real consumer of the C++-level `elemswift::Runtime` API and its `CustomRuntime.cpp`/`.h` must be updated in lockstep; it's an accepted breaking change (confirmed with the user during design).
- Follow the existing `elemswift` free-function style already established in `AudioBufferResource.h` (small, explicitly commented `inline`/declared functions with a one-line rationale for why Swift can't call the underlying method directly).

---

### Task 1: `elemswift::Runtime` becomes an alias with free functions

**Files:**
- Modify: `Sources/ElementaryCore/include/ElementaryCore/Runtime.h` (full rewrite)
- Modify: `Sources/ElementaryCore/Runtime.cpp` (full rewrite)

**Interfaces:**
- Produces: `elemswift::Runtime` (= `elem::Runtime<float>`), `elemswift::RuntimeRef` (= `std::shared_ptr<Runtime>`), `elemswift::makeRuntime(double, int) -> RuntimeRef`, `elemswift::registerNodeType(Runtime&, std::string const&, Runtime::NodeFactoryFn) -> int`, `elemswift::processQueuedEvents(Runtime&, elemswift::ProcessEventsCallbackFn)`, `elemswift::gc(Runtime&) -> std::vector<NodeId>`, `elemswift::addSharedResource(Runtime&, std::string const&, elem::AudioBufferResource) -> bool`, `elemswift::getSharedResourceMapKeys(Runtime&) -> std::vector<std::string>`.
- Consumes: nothing from other tasks (this is the base layer).

- [ ] **Step 1: Rewrite `Runtime.h`**

Replace the entire file with:

```cpp
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
```

- [ ] **Step 2: Rewrite `Runtime.cpp`**

Replace the entire file with:

```cpp
#include "ElementaryCore/Runtime.h"

namespace elemswift {

RuntimeRef makeRuntime(double sampleRate, int blockSize) {
    return std::make_shared<Runtime>(sampleRate, blockSize);
}

int registerNodeType(Runtime& runtime, std::string const& type, Runtime::NodeFactoryFn fn) {
    return runtime.registerNodeType(type, std::move(fn));
}

void processQueuedEvents(Runtime& runtime, ProcessEventsCallbackFn evtCallback) {
    runtime.processQueuedEvents([evtCallback = std::move(evtCallback)](std::string const& name, elem::js::Value value) {
        evtCallback(name, std::move(value));
    });
}

std::vector<NodeId> gc(Runtime& runtime) {
    auto const removed = runtime.gc();
    return std::vector<NodeId>(removed.begin(), removed.end());
}

bool addSharedResource(Runtime& runtime, std::string const& name, elem::AudioBufferResource resource) {
    auto ptr = std::make_unique<elem::AudioBufferResource>(std::move(resource));
    return runtime.addSharedResource(name, std::move(ptr));
}

std::vector<std::string> getSharedResourceMapKeys(Runtime& runtime) {
    // `keys` is a MapKeyView whose iterator's `iterator_traits::value_type` is
    // inherited from the underlying map's iterator (a std::pair), even though
    // operator* returns a std::string&. That mismatch makes the
    // std::vector(InputIt, InputIt) range constructor's SFINAE check fail, so we
    // build the vector manually via a range-based for loop instead, which only
    // relies on operator* and not on iterator_traits.
    auto keys = runtime.getSharedResourceMapKeys();
    std::vector<std::string> result;
    for (auto const& key : keys) {
        result.push_back(key);
    }
    return result;
}

} // namespace elemswift
```

- [ ] **Step 3: Build the `ElementaryCore` target to verify the C++ compiles**

Run: `swift build --target ElementaryCore`
Expected: builds successfully. (This target has no Swift consumers yet at this point, so it only checks the C++ compiles — `Sources/Elementary` will still reference the old API and is expected to fail if built, which is fine; don't run a full `swift build` yet.)

If it fails, check:
- `elem::Runtime<float>::NodeFactoryFn` is a nested type — `Runtime::NodeFactoryFn` must resolve; if not, qualify as `elem::Runtime<float>::NodeFactoryFn`.
- `elem::js::Value` must be default-constructible/movable for the lambda capture in `processQueuedEvents` — it already was, since the old wrapper did the same forwarding.

- [ ] **Step 4: Commit**

```bash
git add Sources/ElementaryCore/include/ElementaryCore/Runtime.h Sources/ElementaryCore/Runtime.cpp
git commit -m "Replace elemswift::Runtime wrapper class with an elem::Runtime<float> alias"
```

---

### Task 2: `elemswift::Renderer` becomes an alias, `Renderer.cpp` removed

**Files:**
- Modify: `Sources/ElementaryCore/include/ElementaryCore/Renderer.h` (full rewrite)
- Delete: `Sources/ElementaryCore/Renderer.cpp`
- Modify: `Package.swift` (drop `"Renderer.cpp"` from the `ElementaryCore` target's `sources`)

**Interfaces:**
- Consumes: `elemswift::Runtime`, `elemswift::RuntimeRef` from Task 1's `Runtime.h`.
- Produces: `elemswift::Renderer` (= `elem::Renderer<float>`), `elemswift::NodeRef`, `elemswift::RenderResult` (both unchanged names/meaning from before).

- [ ] **Step 1: Rewrite `Renderer.h`**

Replace the entire file with:

```cpp
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
```

- [ ] **Step 2: Delete `Renderer.cpp`**

```bash
git rm Sources/ElementaryCore/Renderer.cpp
```

- [ ] **Step 3: Update `Package.swift`**

In the `ElementaryCore` target definition, change:

```swift
            sources: [
                "Runtime.cpp",
                "Renderer.cpp",
            ],
```

to:

```swift
            sources: [
                "Runtime.cpp",
            ],
```

- [ ] **Step 4: Build the `ElementaryCore` target to verify**

Run: `swift build --target ElementaryCore`
Expected: builds successfully.

- [ ] **Step 5: Commit**

```bash
git add Sources/ElementaryCore/include/ElementaryCore/Renderer.h Package.swift
git commit -m "Replace elemswift::Renderer wrapper class with an elem::Renderer<float> alias"
```

---

### Task 3: Update `Elementary.Runtime` (Swift) to use the new C++ API

**Files:**
- Modify: `Sources/Elementary/Runtime.swift` (full rewrite)

**Interfaces:**
- Consumes: `elemswift.RuntimeRef`, `elemswift.makeRuntime`, `elemswift.registerNodeType`, `elemswift.ProcessEventsCallbackFn`, `elemswift.processQueuedEvents`, `elemswift.gc`, `elemswift.addSharedResource`, `elemswift.getSharedResourceMapKeys` from Task 1.
- Produces: `Elementary.Runtime` — same public method signatures as before (`process`, `reset`, `processQueuedEvents`, `gc`, `pruneSharedResources`, `sharedResourceKeys`), plus `internal var coreRuntime: elemswift.RuntimeRef` (was `elemswift.Runtime`) and `internal func addSharedResource(name:resource:) -> Bool` (unchanged signature) — these are what `Sources/Elementary/AudioFileResource.swift` and `Sources/Elementary/Renderer.swift` consume.

- [ ] **Step 1: Rewrite `Runtime.swift`**

Replace the entire file with:

```swift
internal import ElementaryCore

public final class Runtime {
    internal var coreRuntime: elemswift.RuntimeRef

    public init(sampleRate: Double, blockSize: Int32) {
        coreRuntime = elemswift.makeRuntime(sampleRate, blockSize)
    }
    
    /**
     * Construct this runtime from a custom runtime.
     * This can be used to set up the runtime with c++ methods like
     * custom nodes, etc. and then construct a Swift Runtime
     */
    public init(_ runtime: elemswift.RuntimeRef) {
        coreRuntime = runtime
    }

    /// Processes one block of audio in place, using non-interleaved buffers.
    public func process(
        outputChannelData: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>,
        numChannels: Int,
        numFrames: Int
    ) {
        coreRuntime.pointee.process(nil, 0, outputChannelData, numChannels, numFrames)
    }

    public func reset() {
        coreRuntime.pointee.reset()
    }
    
    public func processQueuedEvents(eventCallback: @escaping (_ name: String, _ payload: Value) -> Void) -> Void {
        // TODO: Optimization, currently the event name and payload are copied out into the Swift layer
        // we may be able to find a way to call the reference returning methods on elem.js.Value and
        // instead provide a Swift friendly const view into them without copying into Swift.
        elemswift.processQueuedEvents(&coreRuntime.pointee, elemswift.ProcessEventsCallbackFn { eventName, eventPayload in
            eventCallback(String(eventName), Value(fromCore: eventPayload))
        })
    }

    /// Releases unused graph nodes, returning the ids of the nodes that were cleared.
    @discardableResult
    public func gc() -> [Int32] {
        Array(elemswift.gc(&coreRuntime.pointee))
    }

    /// Registers an already-decoded audio buffer as a shared resource under `name`.
    ///
    /// This is `internal` — app code should use `addAudioResource(name:fileURL:)` instead.
    /// Returns `false` if `name` is already registered (existing entries are never overwritten,
    /// since an active graph node may hold a reference to them).
    @discardableResult
    internal func addSharedResource(name: String, resource: elem.AudioBufferResource) -> Bool {
        elemswift.addSharedResource(&coreRuntime.pointee, std.string(name), resource)
    }

    /// Removes shared resources that are no longer referenced by any active graph node.
    ///
    /// Must be called from the same non-realtime thread that drives graph mutation/rendering,
    /// since the underlying shared resource map is not synchronized.
    public func pruneSharedResources() {
        coreRuntime.pointee.pruneSharedResources()
    }

    /// Returns the names of all currently registered shared resources.
    public func sharedResourceKeys() -> [String] {
        elemswift.getSharedResourceMapKeys(&coreRuntime.pointee).map { String($0) }
    }
}
```

- [ ] **Step 2: Build the full package**

Run: `swift build`
Expected: builds successfully. `Sources/Elementary/Renderer.swift` does not need edits — it already does `coreRenderer = elemswift.Renderer(runtime.coreRuntime)`, and `runtime.coreRuntime` is now exactly the `elemswift.RuntimeRef` that `elemswift.Renderer`'s constructor expects.

If it fails specifically on `coreRuntime.pointee` (e.g. "value of type 'RuntimeRef' has no member 'pointee'", or an "inout" addressability error on `&coreRuntime.pointee`), Swift's C++ interop may expose `std::shared_ptr<T>` access differently than expected. Try, in order:
1. Calling the method directly on `coreRuntime` without `.pointee` (Swift's std overlay sometimes forwards member access through smart pointers transparently for value-returning calls, e.g. `coreRuntime.process(...)`).
2. For free-function calls needing `Runtime&`, assign `coreRuntime.pointee` to a local `var` first, pass that by `&`, then nothing further needed since the free functions only read/mutate the runtime's internal state (not the shared_ptr itself) — e.g.:
   ```swift
   public func gc() -> [Int32] {
       var runtime = coreRuntime.pointee
       return Array(elemswift.gc(&runtime))
   }
   ```
   Only adjust the specific lines that fail to compile; leave working lines as-is.

- [ ] **Step 3: Run the existing test suite**

Run: `swift test`
Expected: all tests pass, in particular `SharedResourceTests` (`testAddSharedResourceRegistersName`, `testAddSharedResourceRejectsDuplicateName`, `testPruneSharedResourcesRemovesUnreferenced`) and `AudioFileResourceTests`.

- [ ] **Step 4: Commit**

```bash
git add Sources/Elementary/Runtime.swift
git commit -m "Update Elementary.Runtime to use elemswift::RuntimeRef and free functions"
```

---

### Task 4: Update the example app's custom runtime construction

**Files:**
- Modify: `Examples/ElementaryExample/Sources/ElementaryWrapper/include/ElementaryWrapper/CustomRuntime.h`
- Modify: `Examples/ElementaryExample/Sources/ElementaryWrapper/CustomRuntime.cpp`

**Interfaces:**
- Consumes: `elemswift::RuntimeRef`, `elemswift::makeRuntime`, `elemswift::registerNodeType` from Task 1.
- Produces: `CustomRuntime::makeElementaryRuntime(double, int) -> elemswift::RuntimeRef` (was `-> elemswift::Runtime`), consumed by `Examples/ElementaryExample/Sources/ElementaryExample/AudioPlayer.swift` (no change needed there — `Elementary.Runtime(CustomRuntime.makeElementaryRuntime(...))` works the same once `Runtime.init(_:)` takes a `RuntimeRef`, per Task 3).

- [ ] **Step 1: Update `CustomRuntime.h`**

Replace the `makeElementaryRuntime` declaration's return type:

```cpp
#pragma once

#include <ElementaryCore/Runtime.h>

namespace CustomRuntime
{

    // Constructs an ElementaryCore::Runtime with this example's custom node
    // types registered on it, ready to hand to an ElementaryCore::Renderer.
    elemswift::RuntimeRef makeElementaryRuntime(double sampleRate, int blockSize);

} // namespace CustomNodes
```

- [ ] **Step 2: Update `CustomRuntime.cpp`**

Replace the entire file with:

```cpp
#include "ElementaryWrapper/CustomRuntime.h"
#include "ElementaryWrapper/CustomGainNode.h"

namespace CustomRuntime 
{

    elemswift::RuntimeRef makeElementaryRuntime(double sampleRate, int blockSize)
    {
        auto runtime = elemswift::makeRuntime(sampleRate, blockSize);

        elemswift::registerNodeType(*runtime, "customGain", [](elemswift::NodeId const id, double sr, int bs) {
            return std::make_shared<CustomNodes::CustomGainNode>(id, sr, static_cast<size_t>(bs));
        });

        return runtime;
    }

} // namespace CustomNodes
```

- [ ] **Step 3: Build the example package**

Run: `cd Examples/ElementaryExample && swift build`
Expected: builds successfully with no changes needed in `AudioPlayer.swift`.

- [ ] **Step 4: Commit**

```bash
git add Examples/ElementaryExample/Sources/ElementaryWrapper/include/ElementaryWrapper/CustomRuntime.h Examples/ElementaryExample/Sources/ElementaryWrapper/CustomRuntime.cpp
git commit -m "Update ElementaryExample's CustomRuntime to build an elemswift::RuntimeRef"
```

---

### Task 5: Final full verification

**Files:** none (verification only)

**Interfaces:** none — this task only runs the build/test suite across both packages to confirm the full refactor is coherent end to end.

- [ ] **Step 1: Clean-build and test the main package**

Run: `swift build && swift test`
Expected: builds successfully, all tests pass.

- [ ] **Step 2: Clean-build the example package**

Run: `cd Examples/ElementaryExample && swift build`
Expected: builds successfully.

- [ ] **Step 3: Confirm no leftover references to the old wrapper API**

Run: `grep -rn "elemswift::Renderer(" --include=*.cpp --include=*.h . ; grep -rn "consuming elemswift.Runtime" --include=*.swift .`
Expected: no output (the old by-value `elemswift::Renderer(const Runtime&)` constructor call and the old `consuming elemswift.Runtime` init parameter no longer exist anywhere).

- [ ] **Step 4: Commit (only if Step 3 or verification required fixups)**

If everything already passed with no further edits, there's nothing to commit for this task — it's pure verification.
