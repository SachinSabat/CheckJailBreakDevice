// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "CheckJailBreakDevice",
    platforms: [
        .iOS(.v14)
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

