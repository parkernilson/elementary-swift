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
        .executableTarget(
            name: "ElementaryExample",
            dependencies: [
                .product(name: "Elementary", package: "elementary-swift"),
            ]
        ),
    ]
)
