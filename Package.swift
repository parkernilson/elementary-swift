// swift-tools-version:5.9
import PackageDescription
import Foundation

// TODO: Is there a better way to do this??
let elementaryRuntimeIncludePath = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .appendingPathComponent("Vendor/elementary/runtime")
    .path

let package = Package(
    name: "Elementary",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Elementary",
            targets: ["Elementary"]
        ),
    ],
    targets: [
        // C++ shim: hand-written, non-template wrapper around elem::Runtime<float>.
        // Swift's C++ importer needs a concrete API surface since it can't
        // import C++ class templates directly.
        .target(
            name: "ElementaryCore",
            path: "Sources/ElementaryCore",
            cxxSettings: [
                .headerSearchPath("../../Vendor/elementary/runtime"),
            ]
        ),
        .target(
            name: "Elementary",
            dependencies: ["ElementaryCore"],
            path: "Sources/Elementary",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(["-Xcc", "-I\(elementaryRuntimeIncludePath)"]),
            ]
        ),
        .testTarget(
            name: "ElementaryTests",
            dependencies: ["Elementary"],
            path: "Tests/ElementaryTests",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(["-Xcc", "-I\(elementaryRuntimeIncludePath)"]),
            ]
        ),
    ],
    // TODO: Should we target cxx17 language standard since the CLI and wasm targets in Elementary Core
    // are cxx17? Or can we do cxx2b since they don't need the Renderer and the Renderer is built to be used
    // only in native targets?
    cxxLanguageStandard: .cxx2b
)
