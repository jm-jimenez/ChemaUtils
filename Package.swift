// swift-tools-version: 5.9
//
//  Package.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 19/10/24.
//
import PackageDescription

let package = Package(
    name: "ChemaUtils",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ChemaUtils",
            targets: ["DependencyResolver", "Navigation", "Utils"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DependencyResolver"
        ),
        .target(
            name: "Navigation"
        ),
        .target(
            name: "Utils",
            dependencies: ["DependencyResolver"]
        ),
        .testTarget(
            name: "DependencyResolverTests",
            dependencies: ["DependencyResolver"]),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"]),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]
        )
    ]
)
