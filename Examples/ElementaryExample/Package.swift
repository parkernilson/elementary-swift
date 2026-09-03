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
        .target(
            name: "ElementaryWrapper",
            dependencies: [
                .product(name: "ElementaryCore", package: "elementary-swift"),
            ]
        ),
        .executableTarget(
            name: "ElementaryExample",
            dependencies: [
                .product(name: "Elementary", package: "elementary-swift"),
                "ElementaryWrapper",
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
