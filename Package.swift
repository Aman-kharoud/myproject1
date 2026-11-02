// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TVDropCore",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [.library(name: "TVDropCore", targets: ["TVDropCore"])],
    targets: [
        .target(name: "TVDropCore", path: "Core"),
        .testTarget(name: "TVDropCoreTests", dependencies: ["TVDropCore"], path: "Tests")
    ]
)
