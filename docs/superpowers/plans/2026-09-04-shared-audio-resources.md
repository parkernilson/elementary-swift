# Shared Audio Resources Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let Swift apps that import `Elementary` load an audio file from disk (starting with `.wav`) and register it as a shared resource that a `Sample` node can play, via `Runtime.addAudioResource(name:fileURL:)`.

**Architecture:** Three layers — a generic C++ bridge on `elemswift::Runtime` that takes an already-built `elem::AudioBufferResource` and forwards it to the vendored `elem::Runtime`; an `internal` Swift passthrough plus two public inspection/maintenance methods (`pruneSharedResources`, `sharedResourceKeys`) on the Swift `Runtime`; and a public `addAudioResource(name:fileURL:)` extension that decodes a file with `AVAudioFile`/`AVAudioPCMBuffer` and builds the `AudioBufferResource` itself.

**Tech Stack:** Swift 6 (C++ interop mode), C++17, AVFoundation, XCTest.

## Global Constraints

- Platforms: macOS 13+, iOS 16+ (from `Package.swift`) — AVFoundation is available on both.
- C++ standard: C++17 (`cxxLanguageStandard: .cxx17` in `Package.swift`) — don't use later-standard C++ features.
- `Elementary` target builds with `.interoperabilityMode(.Cxx)`; any new Swift file in that target automatically gets this.
- `SharedResourceMap` entries are insert-only (see `Vendor/elementary/runtime/elem/SharedResource.h`): never attempt to overwrite an existing name — surface the `false`/failure instead.
- The generic `addSharedResource(name:resource:)` on the Swift `Runtime` must stay `internal` (module-visible only) — it is not public API. Only `addAudioResource(name:fileURL:)` is public.

---

### Task 1: Enable the `ElementaryTests` target

The test target exists (`Tests/ElementaryTests/ElementaryRuntimeSmokeTests.swift`) but is commented out in `Package.swift`, so there is currently no way to run any test in this package. This must be fixed before any other task can add a real test.

**Files:**
- Modify: `Package.swift`

**Interfaces:**
- Produces: a working `ElementaryTests` test target that later tasks can add test files to.

- [ ] **Step 1: Uncomment the `ElementaryTests` target in `Package.swift`**

Find this block (currently commented out at the end of the `targets` array):

```swift
//        .testTarget(
//            name: "ElementaryTests",
//            dependencies: ["Elementary"],
//            path: "Tests/ElementaryTests",
//            swiftSettings: [
//                .interoperabilityMode(.Cxx),
//            ]
//        ),
```

Replace it with:

```swift
        .testTarget(
            name: "ElementaryTests",
            dependencies: ["Elementary"],
            path: "Tests/ElementaryTests",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
```

- [ ] **Step 2: Run the existing test to confirm the target builds and runs**

Run: `swift test --filter ElementaryRuntimeSmokeTests`
Expected: 1 test run, marked as skipped (`testCanConstructRuntime` calls `XCTSkip`), overall command exits 0.

- [ ] **Step 3: Commit**

```bash
git add Package.swift
git commit -m "Enable ElementaryTests target"
```

---

### Task 2: Shared resource bridge (C++ + Swift)

Add `addSharedResource` / `pruneSharedResources` / `getSharedResourceMapKeys` to the `elemswift::Runtime` C++ bridge, and mirror them on the Swift `Runtime`. `addSharedResource` takes an already-constructed `elem::AudioBufferResource` and stays `internal` in Swift — it's not meant to be called directly by app code (see Task 3 for the public entry point).

**Files:**
- Modify: `Sources/ElementaryCore/include/ElementaryCore/Runtime.h`
- Modify: `Sources/ElementaryCore/Runtime.cpp`
- Modify: `Sources/Elementary/Runtime.swift`
- Test: `Tests/ElementaryTests/SharedResourceTests.swift` (new file)

**Interfaces:**
- Consumes: `elem::AudioBufferResource` (`Vendor/elementary/runtime/elem/AudioBufferResource.h`), specifically the `AudioBufferResource(float* data, size_t numSamples)` constructor for mono buffers.
- Produces:
  - C++: `bool elemswift::Runtime::addSharedResource(std::string const& name, elem::AudioBufferResource resource)`, `void elemswift::Runtime::pruneSharedResources()`, `std::vector<std::string> elemswift::Runtime::getSharedResourceMapKeys()`.
  - Swift: `internal func Runtime.addSharedResource(name: String, resource: elem.AudioBufferResource) -> Bool`, `public func Runtime.pruneSharedResources()`, `public func Runtime.sharedResourceKeys() -> [String]`. Task 3 calls `addSharedResource(name:resource:)` from within the same `Elementary` module.

- [ ] **Step 1: Add the `AudioBufferResource.h` include and method declarations to the C++ bridge header**

In `Sources/ElementaryCore/include/ElementaryCore/Runtime.h`, add the include alongside the existing direct vendor includes:

```cpp
#include "../../../../Vendor/elementary/runtime/elem/Runtime.h"
#include "../../../../Vendor/elementary/runtime/elem/Value.h"
#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"
#include "GraphNode.h"
```

Then replace the `// TODO: Implement shared resources` line with:

```cpp
    // Takes ownership of an already-constructed AudioBufferResource. Intended for
    // internal use by higher-level Swift helpers that already know how to decode
    // samples into an AudioBufferResource. Returns false if `name` is already taken.
    bool addSharedResource(std::string const& name, elem::AudioBufferResource resource);

    // Removes shared resources that are no longer referenced by any active graph node.
    void pruneSharedResources();

    // Returns the names of all currently registered shared resources.
    std::vector<std::string> getSharedResourceMapKeys();
```

- [ ] **Step 2: Implement the three methods in the C++ bridge source**

In `Sources/ElementaryCore/Runtime.cpp`, add after `Runtime::gc()` and before the closing `} // namespace ElementaryCore`:

```cpp
bool Runtime::addSharedResource(std::string const& name, elem::AudioBufferResource resource) {
    auto ptr = std::make_unique<elem::AudioBufferResource>(std::move(resource));
    return mRuntime->addSharedResource(name, std::move(ptr));
}

void Runtime::pruneSharedResources() {
    mRuntime->pruneSharedResources();
}

std::vector<std::string> Runtime::getSharedResourceMapKeys() {
    auto keys = mRuntime->getSharedResourceMapKeys();
    return std::vector<std::string>(keys.begin(), keys.end());
}
```

- [ ] **Step 3: Build to confirm the C++ bridge compiles**

Run: `swift build`
Expected: builds with no errors.

- [ ] **Step 4: Add the Swift bridge methods to `Runtime.swift`**

In `Sources/Elementary/Runtime.swift`, add these methods to the `Runtime` class (after `gc()`):

```swift
    /// Registers an already-decoded audio buffer as a shared resource under `name`.
    ///
    /// This is `internal` — app code should use `addAudioResource(name:fileURL:)` instead.
    /// Returns `false` if `name` is already registered (existing entries are never overwritten,
    /// since an active graph node may hold a reference to them).
    @discardableResult
    internal func addSharedResource(name: String, resource: elem.AudioBufferResource) -> Bool {
        coreRuntime.addSharedResource(std.string(name), resource)
    }

    /// Removes shared resources that are no longer referenced by any active graph node.
    public func pruneSharedResources() {
        coreRuntime.pruneSharedResources()
    }

    /// Returns the names of all currently registered shared resources.
    public func sharedResourceKeys() -> [String] {
        coreRuntime.getSharedResourceMapKeys().map { String($0) }
    }
```

- [ ] **Step 5: Write failing tests for the bridge**

Create `Tests/ElementaryTests/SharedResourceTests.swift`:

```swift
import XCTest
@testable import Elementary

final class SharedResourceTests: XCTestCase {
    private func makeMonoResource(_ samples: [Float]) -> elem.AudioBufferResource {
        var samples = samples
        return samples.withUnsafeMutableBufferPointer { buf in
            elem.AudioBufferResource(buf.baseAddress, buf.count)
        }
    }

    func testAddSharedResourceRegistersName() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        let added = runtime.addSharedResource(name: "test-buffer", resource: makeMonoResource([0.0, 0.25, 0.5, 0.75]))

        XCTAssertTrue(added)
        XCTAssertTrue(runtime.sharedResourceKeys().contains("test-buffer"))
    }

    func testAddSharedResourceRejectsDuplicateName() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        XCTAssertTrue(runtime.addSharedResource(name: "dup", resource: makeMonoResource([0.0])))
        XCTAssertFalse(runtime.addSharedResource(name: "dup", resource: makeMonoResource([1.0])))
    }

    func testPruneSharedResourcesRemovesUnreferenced() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)
        runtime.addSharedResource(name: "unreferenced", resource: makeMonoResource([0.0]))

        runtime.pruneSharedResources()

        XCTAssertFalse(runtime.sharedResourceKeys().contains("unreferenced"))
    }
}
```

- [ ] **Step 6: Run the tests to verify they pass**

Run: `swift test --filter SharedResourceTests`
Expected: all 3 tests PASS. (No separate "run to see it fail" step here — the bridge methods from Steps 1-4 must exist for this file to even compile, so red/green happens together: before Step 4 the project doesn't build at all.)

- [ ] **Step 7: Commit**

```bash
git add Sources/ElementaryCore/include/ElementaryCore/Runtime.h Sources/ElementaryCore/Runtime.cpp Sources/Elementary/Runtime.swift Tests/ElementaryTests/SharedResourceTests.swift
git commit -m "Add shared resource bridge to Runtime"
```

---

### Task 3: Public `addAudioResource(name:fileURL:)` API

Add the public, ergonomic entry point apps actually use: decode an audio file with AVFoundation and register it via the internal bridge from Task 2.

**Files:**
- Create: `Sources/Elementary/AudioFileResource.swift`
- Modify: `Package.swift` (add test fixture resource)
- Test: `Tests/ElementaryTests/AudioFileResourceTests.swift` (new file)
- Test fixture: `Tests/ElementaryTests/Fixtures/test-tone.wav` (new file)

**Interfaces:**
- Consumes: `Runtime.addSharedResource(name:resource:)` and `Runtime.sharedResourceKeys()` from Task 2; `elem.AudioBufferResource(_ data: UnsafeMutablePointer<UnsafeMutablePointer<Float>>?, _ numChannels: Int, _ numSamples: Int)` constructor (`Vendor/elementary/runtime/elem/AudioBufferResource.h`).
- Produces: `public enum AudioResourceError: Error { case unreadableFile(underlying: Error), case unsupportedFormat, case duplicateName(String) }`; `public func Runtime.addAudioResource(name: String, fileURL: URL) throws -> Bool`.

- [ ] **Step 1: Generate the `.wav` test fixture**

Run:

```bash
mkdir -p Tests/ElementaryTests/Fixtures
python3 - <<'EOF'
import wave, struct

with wave.open("Tests/ElementaryTests/Fixtures/test-tone.wav", "w") as f:
    f.setnchannels(1)
    f.setsampwidth(2)
    f.setframerate(8000)
    frames = b"".join(struct.pack("<h", int(3000 * ((i % 8) - 4))) for i in range(80))
    f.writeframes(frames)
EOF
```

Expected: `Tests/ElementaryTests/Fixtures/test-tone.wav` exists (mono, 16-bit PCM, 8kHz, 80 frames).

- [ ] **Step 2: Add the fixture as a test resource in `Package.swift`**

Change the `ElementaryTests` target (enabled in Task 1) from:

```swift
        .testTarget(
            name: "ElementaryTests",
            dependencies: ["Elementary"],
            path: "Tests/ElementaryTests",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
```

to:

```swift
        .testTarget(
            name: "ElementaryTests",
            dependencies: ["Elementary"],
            path: "Tests/ElementaryTests",
            resources: [
                .copy("Fixtures"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
```

- [ ] **Step 3: Write the failing tests**

Create `Tests/ElementaryTests/AudioFileResourceTests.swift`:

```swift
import XCTest
@testable import Elementary

final class AudioFileResourceTests: XCTestCase {
    private var fixtureURL: URL {
        Bundle.module.url(forResource: "test-tone", withExtension: "wav", subdirectory: "Fixtures")!
    }

    func testAddAudioResourceDecodesAndRegistersFile() throws {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)

        let added = try runtime.addAudioResource(name: "tone", fileURL: fixtureURL)

        XCTAssertTrue(added)
        XCTAssertTrue(runtime.sharedResourceKeys().contains("tone"))
    }

    func testAddAudioResourceRejectsDuplicateName() throws {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)
        _ = try runtime.addAudioResource(name: "tone", fileURL: fixtureURL)

        XCTAssertThrowsError(try runtime.addAudioResource(name: "tone", fileURL: fixtureURL)) { error in
            guard case AudioResourceError.duplicateName(let name) = error else {
                return XCTFail("Expected duplicateName, got \(error)")
            }
            XCTAssertEqual(name, "tone")
        }
    }

    func testAddAudioResourceThrowsForMissingFile() {
        let runtime = Runtime(sampleRate: 44100, blockSize: 512)
        let missingURL = fixtureURL.deletingLastPathComponent().appendingPathComponent("does-not-exist.wav")

        XCTAssertThrowsError(try runtime.addAudioResource(name: "missing", fileURL: missingURL)) { error in
            guard case AudioResourceError.unreadableFile = error else {
                return XCTFail("Expected unreadableFile, got \(error)")
            }
        }
    }
}
```

- [ ] **Step 4: Run the tests to verify they fail**

Run: `swift test --filter AudioFileResourceTests`
Expected: build failure — `addAudioResource` and `AudioResourceError` don't exist yet.

- [ ] **Step 5: Implement `addAudioResource`**

Create `Sources/Elementary/AudioFileResource.swift`:

```swift
import AVFoundation

/// Errors thrown while loading an audio file into a shared resource.
public enum AudioResourceError: Error, Equatable {
    case unreadableFile(underlying: NSError)
    case unsupportedFormat
    case duplicateName(String)
}

extension Runtime {
    /// Loads an audio file from disk and registers it as a shared resource under `name`,
    /// ready to be referenced by a Sample node's `path` property.
    ///
    /// Supports any format AVFoundation can decode (`.wav` today; `.aiff`, `.caf`, `.m4a`,
    /// `.mp3`, etc. work the same way with no additional code). The resulting buffer is at
    /// the file's native sample rate — there is no automatic resampling to the runtime's
    /// sample rate.
    @discardableResult
    public func addAudioResource(name: String, fileURL: URL) throws -> Bool {
        let file: AVAudioFile
        do {
            file = try AVAudioFile(forReading: fileURL)
        } catch {
            throw AudioResourceError.unreadableFile(underlying: error as NSError)
        }

        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: file.processingFormat,
            frameCapacity: AVAudioFrameCount(file.length)
        ) else {
            throw AudioResourceError.unsupportedFormat
        }

        do {
            try file.read(into: buffer)
        } catch {
            throw AudioResourceError.unreadableFile(underlying: error as NSError)
        }

        guard let channelData = buffer.floatChannelData else {
            throw AudioResourceError.unsupportedFormat
        }

        let resource = elem.AudioBufferResource(
            channelData,
            Int(buffer.format.channelCount),
            Int(buffer.frameLength)
        )

        guard addSharedResource(name: name, resource: resource) else {
            throw AudioResourceError.duplicateName(name)
        }

        return true
    }
}
```

- [ ] **Step 6: Run the tests to verify they pass**

Run: `swift test --filter AudioFileResourceTests`
Expected: all 3 tests PASS.

- [ ] **Step 7: Run the full test suite**

Run: `swift test`
Expected: all tests pass (including Task 1's smoke test and Task 2's `SharedResourceTests`).

- [ ] **Step 8: Commit**

```bash
git add Sources/Elementary/AudioFileResource.swift Package.swift Tests/ElementaryTests/AudioFileResourceTests.swift Tests/ElementaryTests/Fixtures/test-tone.wav
git commit -m "Add public addAudioResource(name:fileURL:) API"
```

---

## Post-plan verification

- [ ] Run `swift build` — succeeds with no warnings from the new code.
- [ ] Run `swift test` — full suite passes.
- [ ] Confirm `Runtime.addSharedResource(name:resource:)` is not accessible outside the `Elementary` module (e.g. by checking that an external caller can't reference it — it's `internal`, so this is guaranteed by the compiler, not something to manually verify beyond code review).
