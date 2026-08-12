# Elementary Swift
A lightweight Swift wrapper for [Elementary Audio](https://github.com/elemaudio/elementary), a declarative Audio Graph renderer.

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

Plain `extern "C"`-style consumption (e.g. CocoaPods) is not supported.
