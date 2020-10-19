import PackageDescription


let package = Package(
    name: "SidebarOverlay",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(name: "SidebarOverlay",
            targets: ["SidebarOveerlay"]),
    ],
    targets: [
        .target(name: "SidebarOverlay",
            path: "Source/*")
    ],
    swiftLanguageVersions: [.v5]
)
