// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CheckJailBreakDevice",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "CheckJailBreakDevice", targets: ["CheckJailBreakDevice"]),
    ],
    targets: [
        .target(name: "CheckJailBreakDevice", path: "Sources"),
    ]
)

