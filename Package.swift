// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PanModal",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "PanModal",
            targets: ["PanModal"]),
        .library(
            name: "PanModalDynamic", 
            type: .dynamic, 
            targets: ["PanModal"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PanModal",
            dependencies: [],
            path: "PanModal")
    ],
    swiftLanguageVersions: [.version("5.0")]
)
