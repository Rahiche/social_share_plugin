// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "social_share_plugin",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(
            name: "social-share-plugin",
            targets: ["social_share_plugin"]
        )
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "social_share_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/social_share_plugin",
            publicHeadersPath: "."
        )
    ]
)
