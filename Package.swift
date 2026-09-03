// swift-tools-version:5.9
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
        // Exposes elem/GraphNode.h and friends, for consumers implementing
        // custom nodes.
        .library(
            name: "ElementaryRuntime",
            targets: ["ElementaryRuntime"]
        ),
    ],
    targets: [
        // Exposes a curated set of elem/*.h headers (GraphNode.h and its
        // dependencies) needed to author custom nodes, without exposing the
        // entire Vendor/elementary/runtime tree as one Clang module. That
        // distinction matters: Clang must be able to independently parse
        // every header in a module, and some files elsewhere under
        // runtime/ (e.g. elem/builtins/helpers/ValueHelpers.h) have broken
        // includes that only happen to work today because nothing
        // textually includes them.
        //
        // include/elem/*.h are small forwarding headers (one #include line
        // each) that point at the real vendored files in the Vendor/elementary
        // git submodule — not copies, and not symlinks, so the submodule
        // itself stays untouched and there's still a single source of
        // truth for the actual header content.
        .target(
            name: "ElementaryRuntime"
        ),
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
//        .testTarget(
//            name: "ElementaryTests",
//            dependencies: ["Elementary"],
//            path: "Tests/ElementaryTests",
//            swiftSettings: [
//                .interoperabilityMode(.Cxx),
//            ]
//        ),
    ],
    cxxLanguageStandard: .cxx17
)
