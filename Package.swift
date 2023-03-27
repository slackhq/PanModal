// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PanModal",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PanModal",
            targets: ["PanModal"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PanModal",
            dependencies: [],
            path: "PanModal"
        )
    ]
)