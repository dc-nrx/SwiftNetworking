// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetworking",
	platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        .library(
            name: "SwiftNetworking",
            targets: ["SwiftNetworking"]),
		.library(
			name: "SwiftNetworkingMocks",
			targets: ["SwiftNetworkingMocks"]),
    ],
    dependencies: [
		.package(url: "https://github.com/dc-nrx/SwiftSerialize.git", .upToNextMinor(from: "0.2.0")),
	],
    targets: [
        .target(
			name: "SwiftNetworking",
			dependencies: ["SwiftSerialize"]
		),
		.target(
			name: "SwiftNetworkingMocks",
			dependencies: ["SwiftNetworking"]
		),
        .testTarget(
            name: "SwiftNetworkingTests",
            dependencies: ["SwiftNetworking", "SwiftNetworkingMocks"],
			resources: [.process("MockedResponses")]
		),
    ]
)
