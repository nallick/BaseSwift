// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "BaseSwift",
    platforms: [.iOS(.v10), .macOS(.v10_12)],
    products: [
        .library(
            name: "BaseSwift",
            targets: ["BaseSwift"]),
        .library(
            name: "BaseSwiftMocks",
            targets: ["BaseSwiftMocks"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BaseSwift",
            dependencies: []),
        .target(
            name: "BaseSwiftMocks",
            dependencies: ["BaseSwift"]),
        .testTarget(
            name: "BaseSwiftTests",
            dependencies: ["BaseSwift"]),
    ]
)
