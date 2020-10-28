// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GSPanModal",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "GSPanModal",
            targets: ["GSPanModal"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GSPanModal",
            dependencies: [],
            path: "GSPanModal")
    ],
    swiftLanguageVersions: [.version("5.0")]
)
