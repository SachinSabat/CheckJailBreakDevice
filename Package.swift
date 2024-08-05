// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CheckJailBreakDevice",
    products: [
        .library(
            name: "CheckJailBreakDevice",
            targets: ["CheckJailBreakDevice"]),
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .target(
            name: "CheckJailBreakDevice",
            dependencies: []),
        .testTarget(
            name: "CheckJailBreakDeviceTests",
            dependencies: ["CheckJailBreakDevice"]),
    ]
)

