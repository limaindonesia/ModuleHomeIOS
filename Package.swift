// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HomeFlow",
  platforms: [.iOS(.v15)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HomeFlow",
      targets: ["HomeFlow"])
  ],
  dependencies: [
    .package(path: "AprodhitKit"),
    .package(
      url: "https://gitlab.com/pixelheart/gndkit.git",
      branch: "develop"
    ),
    .package(
      url: "https://github.com/airbnb/lottie-ios.git",
      .upToNextMajor(from: "4.5.0")
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "HomeFlow",
      dependencies: [
        "AprodhitKit",
        .product(name: "GnDKit", package: "gndkit"),
        .product(name: "Lottie", package: "lottie-ios"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "HomeFlowTests",
      dependencies: [
        "HomeFlow"
      ]
    ),
  ]
)
