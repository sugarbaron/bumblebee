// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bumblebee",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Bumblebee", targets: ["Bumblebee"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", exact: Version("2.8.1"))
    ],
    targets: [
        .target(
            name: "Bumblebee",
            dependencies: ["Swinject"],
            path: "Sources")
    ]
)
