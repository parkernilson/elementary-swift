# Shared Audio Resources — Design

## Problem

`elem::Runtime<FloatType>` (vendored C++ engine, `Vendor/elementary/runtime/elem/Runtime.h`) supports
`addSharedResource` / `pruneSharedResources` / `getSharedResourceMapKeys`, which let a `SampleNode` (and
similar builtins) play back audio data referenced by name via its `path` property. The `elemswift::Runtime`
C++/Swift bridge (`Sources/ElementaryCore/include/ElementaryCore/Runtime.h`) has a `// TODO: Implement shared
resources` placeholder, and the public Swift `Runtime` (`Sources/Elementary/Runtime.swift`) has no shared
resource API at all.

We want Swift apps that import `Elementary` to be able to load an audio file from disk (starting with
`.wav`) and register it as a shared resource that a `Sample` node can play.

## Key finding: file type is not a C++ concept here

`elem::SharedResource` (`Vendor/elementary/runtime/elem/SharedResource.h`) is a pure abstract interface over
already-decoded PCM data:

```cpp
class SharedResource {
public:
    virtual BufferView<float> getChannelData(size_t channelIndex) = 0;
    virtual size_t numChannels() = 0;
    virtual size_t numSamples() = 0;
};
```

`elem::AudioBufferResource` (`Vendor/elementary/runtime/elem/AudioBufferResource.h`) is the only concrete
`SharedResource` in the vendored engine, and its constructors only ever accept raw `float`/`float**` buffers
— there is no file parsing anywhere in the C++ layer. `SharedResourceMap` is just `string name → shared_ptr<SharedResource>`
(`Vendor/elementary/runtime/elem/SharedResource.h`); it has no notion of "type" at all.

Consequence: **decoding a file into PCM float data must happen entirely on the Swift side**, before anything
is handed to C++. The C++ bridge's job is only to take already-decoded channel data and wrap it as a shared
resource.

## Decoding strategy: AVAudioFile

We decode using `AVAudioFile` / `AVAudioPCMBuffer` (AVFoundation), which is available since the package
already targets macOS 13+ / iOS 16+ only. `AVAudioFile(forReading:)` auto-detects the container format from
the file itself, and reading into a buffer built from `file.processingFormat` yields deinterleaved Float32
data regardless of the source encoding (e.g. 16-bit PCM `.wav`) — no manual format conversion needed.

This gets us `.wav` today, and `.aiff` / `.caf` / `.m4a` / `.mp3` etc. for free later, with no new C++ code
and no hand-written parser to maintain.

*Known limitation:* the resulting buffer is at the file's native sample rate; there is no automatic
resampling to the `Runtime`'s sample rate. This matches the existing `SampleNode` playback model, which
already exposes rate/pitch as an explicit per-node concern (not a regression, just worth noting).

## Architecture

Three layers, each with one job:

1. **`ElementaryCore` (C++ bridge)** — thin, generic: take an already-constructed
   `elem::AudioBufferResource` and hand it to the underlying `elem::Runtime`. No format awareness.
2. **`Elementary` / `Runtime.swift` (Swift bridge)** — `internal` passthrough to the C++ bridge, plus the
   two public inspection/maintenance methods (`pruneSharedResources`, `sharedResourceKeys`).
3. **`Elementary` / `AudioFileResource.swift` (Swift, public)** — the actual entry point apps use:
   `addAudioResource(name:fileURL:)`. Builds an `elem.AudioBufferResource` from a decoded `AVAudioPCMBuffer`
   and calls the internal bridge method from (2).

This keeps the public API surface on `Runtime` limited to what's actually needed today (loading audio
files), while leaving room for future resource producers (e.g. procedurally generated buffers, other
concrete `SharedResource` subtypes) to reuse the same internal bridge method without a public raw-buffer API.

## C++ bridge — `Sources/ElementaryCore/include/ElementaryCore/Runtime.h` / `Runtime.cpp`

Add an include for `AudioBufferResource.h` to the bridge header, same pattern as the existing direct
`Value.h` include:

```cpp
#include "../../../../Vendor/elementary/runtime/elem/AudioBufferResource.h"
```

New methods on `elemswift::Runtime`:

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

`Runtime.cpp`:

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

`addSharedResource` returning `false` mirrors `SharedResourceMap::add`'s `emplace(...).second` semantics —
entries are insert-only, never overwritten (existing entries may be referenced by an active graph node).

## Swift bridge — `Sources/Elementary/Runtime.swift`

```swift
@discardableResult
internal func addSharedResource(name: String, resource: elem.AudioBufferResource) -> Bool {
    coreRuntime.addSharedResource(std.string(name), resource)
}

public func pruneSharedResources() {
    coreRuntime.pruneSharedResources()
}

public func sharedResourceKeys() -> [String] {
    coreRuntime.getSharedResourceMapKeys().map { String($0) }
}
```

`addSharedResource` is `internal` (module-visible only, per `Elementary` target). It is not part of the
public API; `AudioFileResource.swift` (same module) is the only current caller.

`elem.AudioBufferResource` becomes visible to Swift automatically once `AudioBufferResource.h` is reachable
from an `ElementaryCore` public header — confirmed by precedent: other concrete `elem::` types
(`elem::js::Value`, `elem::RenderOptions`, `elem::NodeRepr`) are already constructed directly from Swift as
`elem.js.Value(...)`, `elem.RenderOptions(...)`, etc. Multi-level pointer parameters (`float**`) are also
already proven to cross the boundary directly — `Runtime.process` takes `float** outputChannelData` and
`Runtime.swift`'s existing `process(outputChannelData:numChannels:numFrames:)` passes an
`UnsafeMutablePointer<UnsafeMutablePointer<Float>?>` straight through.

## Public API — new file `Sources/Elementary/AudioFileResource.swift`

```swift
import AVFoundation

public enum AudioResourceError: Error {
    case unreadableFile(underlying: Error)
    case unsupportedFormat
    case duplicateName(String)
}

extension Runtime {
    /// Loads an audio file from disk and registers it as a shared resource under `name`,
    /// ready to be referenced by a Sample node's `path` property.
    ///
    /// Supports any format AVFoundation can decode (`.wav` today; `.aiff`, `.caf`, `.m4a`,
    /// `.mp3`, etc. work the same way with no additional code).
    @discardableResult
    public func addAudioResource(name: String, fileURL: URL) throws -> Bool {
        let file: AVAudioFile
        do {
            file = try AVAudioFile(forReading: fileURL)
        } catch {
            throw AudioResourceError.unreadableFile(underlying: error)
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
            throw AudioResourceError.unreadableFile(underlying: error)
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

`AVAudioPCMBuffer.floatChannelData` is already `float**`-shaped
(`UnsafeMutablePointer<UnsafeMutablePointer<Float>>?`), so it passes directly into
`elem.AudioBufferResource`'s `(float** data, size_t numChannels, size_t numSamples)` constructor — no manual
pointer-array construction needed.

## Naming convention

`name` is caller-chosen and must exactly match the string later set as a `Sample` node's `path` property —
this is the existing lookup contract in `Vendor/elementary/runtime/elem/builtins/Sample.h`
(`resources.get((js::String) val)`), unchanged by this work. Typically callers will use the file's path as
the name, but any unique string works.

## Testing

`ElementaryTests` is currently commented out in `Package.swift`. Plan:

1. Re-enable the `ElementaryTests` target.
2. Add a small `.wav` fixture to the test target's resources.
3. Tests:
   - `addAudioResource` successfully decodes the fixture and registers it; `sharedResourceKeys()` contains
     the name afterward.
   - Calling `addAudioResource` twice with the same `name` throws `.duplicateName`.
   - `pruneSharedResources()` removes an unreferenced resource (name no longer present in
     `sharedResourceKeys()` afterward).
   - Loading a nonexistent file throws `.unreadableFile`.

## Out of scope

- Resampling to the runtime's sample rate.
- Any resource type other than audio buffers.
- Any decoding path other than AVAudioFile (e.g. raw in-memory `Data` without a backing file URL).
