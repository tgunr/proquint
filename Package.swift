// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Proquint",
    products: [
        .library(
            name: "Proquint",
            targets: ["Proquint"]
        ),
    ],
    targets: [
        .target(
            name: "Proquint",
            path: "Packages"
        ),
    ]
)
