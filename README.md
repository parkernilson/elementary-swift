# Elementary Swift (Work In Progress)
Elementary Swift will be a lightweight Swift language binding for [Elementary Audio](https://github.com/elemaudio/elementary), a declarative Audio Graph renderer.

## Develop
Install Submodules
```
git submodule update --init --recursive
```

Then build/test with SwiftPM as usual:
```
swift build
swift test
```

## Using this package

This package uses Swift's native C++ interoperability mode. Any target that
depends on `ElementarySwift` must also enable it:

- **SwiftPM**: `swift-tools-version >= 5.9`, and `swiftSettings: [.interoperabilityMode(.Cxx)]`
  on the depending target.
- **Xcode**: enable the "C++ and Objective-C Interoperability" build setting
  on the depending target.

## Examples

`Examples/ElementaryExample` is a minimal macOS SwiftUI app that depends on
this package via a local path dependency, demonstrating how an external
project would `import ElementarySwift` and construct a runtime. Run it with:
```
cd Examples/ElementaryExample
swift run
```
