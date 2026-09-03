// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ElementaryExample",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        // Custom elem::GraphNode implementations, written directly against
        // the vendored elementary runtime headers exposed by the
        // ElementaryRuntime product.
        .target(
            name: "CustomNodes",
            dependencies: [
                .product(name: "ElementaryRuntime", package: "elementary-swift"),
            ]
        ),
        .executableTarget(
            name: "ElementaryExample",
            dependencies: [
                .product(name: "Elementary", package: "elementary-swift"),
                "CustomNodes",
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
