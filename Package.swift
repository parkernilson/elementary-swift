// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ElementarySwift",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "ElementarySwift",
            targets: ["ElementarySwift"]
        ),
    ],
    targets: [
        // C++ shim: hand-written, non-template wrapper around elem::Runtime<float>.
        // Swift's C++ importer needs a concrete API surface since it can't
        // import C++ class templates directly.
        .target(
            name: "CElementaryShim",
            path: "Sources/CElementaryShim",
            cxxSettings: [
                .headerSearchPath("../../Vendor/elementary/runtime"),
            ]
        ),
        .target(
            name: "ElementarySwift",
            dependencies: ["CElementaryShim"],
            path: "Sources/ElementarySwift",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
        .testTarget(
            name: "ElementarySwiftTests",
            dependencies: ["ElementarySwift"],
            path: "Tests/ElementarySwiftTests",
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
