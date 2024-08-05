// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CheckJailBreakDevice",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "CheckJailBreakDevice",
            targets: ["CheckJailBreakDevice"]
        )
    ],
    targets: [
        .target(
            name: "CheckJailBreakDevice",
            path: "CheckJailBreakDevice"
        )
    ]
)

