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
        // C++ shim: `using` aliases over the vendored elem::Runtime<float>/
        // elem::Renderer<float> templates, plus free functions for the
        // handful of calls Swift's C++ interop can't make directly (e.g.
        // dereferencing a std::shared_ptr, passing rvalue-ref parameters).
        //
        // Critically, this target's .cpp files (Runtime.cpp, Renderer.cpp)
        // must keep existing and keep calling into these templates directly:
        // letting Swift's own C++-interop compilation be the first place a
        // template method gets instantiated can produce weak symbols that
        // get silently demoted to local linkage when this package's build
        // combines ElementaryCore's object files, causing an undefined-symbol
        // link error in `swift test`. See the header comment on
        // elemswift::renderGraph/createRef in
        // Sources/ElementaryCore/include/ElementaryCore/Renderer.h for the
        // full explanation.
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
