// swift-tools-version:6.0
import PackageDescription
import Foundation

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
        // Exposes the ElementaryCore C++ shim (Runtime, Renderer, GraphNode)
        // directly, for consumers that need to construct their own Runtime
        // — e.g. to register custom node types before handing it to a
        // Renderer.
        .library(
            name: "ElementaryCore",
            targets: ["ElementaryCore"]
        ),
    ],
    targets: [
        // C++ shim: hand-written, non-template wrapper around elementary.
        // Swift's C++ importer needs a concrete API surface since it can't
        // import C++ class templates directly.
        .target(
            name: "ElementaryCore",
            path: "Sources/ElementaryCore",
            sources: [
                "Runtime.cpp",
                "Renderer.cpp",
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .define("SWIFT_BRIDGING_ENABLED", to: "1"),
                // nlohmann/json's IO-based input adapters (FILE*/std::istream)
                // use std::streambuf without directly including <streambuf>,
                // relying on it being pulled in transitively via <istream>.
                // That holds under plain textual compilation but not under
                // Swift's modular Clang build of libc++, so disable the IO
                // path entirely — we only ever parse/dump strings.
                .define("JSON_NO_IO", to: "1")
            ],
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),
        .target(
            name: "Elementary",
            dependencies: ["ElementaryCore"],
            path: "Sources/Elementary",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
        .testTarget(
            name: "ElementaryTests",
            dependencies: ["Elementary", "ElementaryCore"],
            path: "Tests/ElementaryTests",
            resources: [
                .copy("Fixtures"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
