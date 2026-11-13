// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-figlet",
    products: [
        .library(
            name: "Figlet",
            targets: ["Figlet"]
        ),
    ],
    targets: [
        .target(
            name: "Figlet",
            resources: [
                .embedInCode("standard.flf")
            ]
        ),
    ]
)
