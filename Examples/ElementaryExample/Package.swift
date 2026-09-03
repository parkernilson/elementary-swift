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
        // Custom ElementaryCore::GraphNode implementations, plus the wiring
        // (makeElementaryRuntime) that registers them onto an
        // ElementaryCore::Runtime.
        .target(
            name: "CustomNodes",
            dependencies: [
                .product(name: "ElementaryCore", package: "elementary-swift"),
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
