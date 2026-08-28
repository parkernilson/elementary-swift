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
    ],
    targets: [
        // C++ shim: hand-written, non-template wrapper around elem::Runtime<float>.
        // Swift's C++ importer needs a concrete API surface since it can't
        // import C++ class templates directly.
        .target(
            name: "ElementaryCore",
            path: "Sources/ElementaryCore",
            exclude: [
                "Vendor/elementary/cli",
                "Vendor/elementary/js",
                "Vendor/elementary/scripts",
                "Vendor/elementary/tests",
                "Vendor/elementary/wasm",
                "Vendor/elementary/runtime/CMakeLists.txt",
                "Vendor/elementary/runtime/elem/third-party/signalsmith-stretch/LICENSE.txt",
                "Vendor/elementary/runtime/elem/third-party/signalsmith-stretch/README.md",
                "Vendor/elementary/runtime/elem/third-party/signalsmith-stretch/dsp/README.md",
                "Vendor/elementary/runtime/elem/third-party/signalsmith-stretch/dsp/LICENSE.txt",
            ],
            sources: [
                ".",
                "Vendor/elementary/runtime"
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("./Vendor/elementary/runtime"),
                .headerSearchPath("."),
                .define("SWIFT_BRIDGING_ENABLED", to: "1")
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
