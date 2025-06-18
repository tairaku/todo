// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TodoApp",
    platforms: [
        .iOS(.v17) // Specify iOS 17 as a minimum deployment target, aligning with Xcode 16.2 expectations
    ],
    products: [
        .executable(
            name: "TodoApp",
            targets: ["TodoApp"])
    ],
    dependencies: [
        // No external dependencies for now
    ],
    targets: [
        // Main application target
        .executableTarget(
            name: "TodoApp",
            dependencies: [],
            path: "Sources/TodoApp", // Specify path to source files
            resources: [] // If you add assets like .xcassets, they should be listed here
        ),
        // Test target
        .testTarget(
            name: "TodoAppTests",
            dependencies: ["TodoApp"], // Test target depends on the main app target
            path: "Tests/TodoAppTests" // Specify path to test files
        )
    ]
)
