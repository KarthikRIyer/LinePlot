// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LinePlot",
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AGG",
            dependencies: [],
    	      path: "Sources/AGG"),
        .target(
            name: "lodepng",
            dependencies: [],
        	  path: "Sources/lodepng"),
        .target(
            name: "AGGRenderer",
            dependencies: ["AGG", "lodepng"],
            path: "Sources/AGGRenderer"),
        .target(
            name: "RendererWrapper",
            dependencies: ["AGGRenderer"],
            path: "Sources/RendererWrapper"),
	.target(
            name: "SVGRenderer",
            dependencies: [],
            path: "Sources/SVGRenderer"),
        .target(
            name: "Vectorizer",
            dependencies: ["RendererWrapper","SVGRenderer"],
            path: "Sources/Vectorizer"),
        .target(
            name: "LinePlot",
            dependencies: ["Vectorizer"],
  	        path: "Sources/LinePlot"),
        .target(
            name: "GraphPlot",
            dependencies: ["LinePlot"],
      	    path: "Sources/GraphPlot"),
    ]
)
