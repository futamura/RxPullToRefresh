// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RxPullToRefresh",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RxPullToRefresh",
            targets: ["RxPullToRefresh"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "RxPullToRefresh",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Sources",
            exclude: [
                "Info.plist",
                "RxPullToRefresh.h"
            ],
            resources: [
                .process("RxPullToRefresh.docc")
            ]
        )
    ]
)
