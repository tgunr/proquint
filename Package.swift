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
	dependencies: [
	    .package(url: "https://github.com/tgunr/proquint.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Proquint",
            path: "Sources"
        ),
    ]
)
 