# GIFImage

This package contains a SwiftUI View that is able to render a GIF, either from a remote URL, or from a local Data. The component was born from the wish to try out the Combine Framework, and it is more of a learning tool than a production ready code.

## Why not a GIF?

![Hipster LLama](Tests/test.gif)

## Usage

This package can be used with either 3 sources: remote URL, local file path or local data;

```swift
let url = URL(string: "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif")!

var localPath: String {
	let path = Bundle.main.path(forResource: "llama", ofType: "gif")!
	return path
}

var localData: Data {
    let data = try! Data(contentsOf: URL(fileURLWithPath: localPath))
    return data
}

var body: some View {
    List {
        GIFImage(source: .remote(url: url))
        GIFImage(source: .local(filePath: localPath))
        GIFImage(source: .static(data: localData))
    }
}
```

To help with general cases, the `GIFImage` can also be created using an URL string or a plain URL:

```swift
let urlString = "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif"
let url = URL(string: urlString)!

var body: some View {
    List {
        GIFImage(url: urlString)
        GIFImage(url: url)
    }
}
```

## Configuration

The view can be configured with a placeholder image placed while the GIF is being downloaded, and have the option to change the frame rate as well. An optional error image can also be set. If the error image is not passed, the placeholder will also be used in the case of errors.

```swift
GIFImage.init(
    source: GIFSource,
    animate: Bool = true,
    loop: Bool = true,
    placeholder: RawImage = RawImage(),
    errorImage: RawImage? = nil,
    frameRate: FrameRate = .dynamic,
    loopAction: @Sendable @escaping (GIFSource) async throws -> Void = { _ in }
)
```

The project has a struct named `ImageLoader` that is responsible for parsing the source into a sequence of frames (later used in the view). This loader has a local cache using `URLCache`. The view will fetch the image loader from the view environment. So, if a different cache limits or file manager wants to be used, the `\.imageLoader` environment key can be used to override the default instance.

## Parameters

- source: Source of the image. If the source is remote, the response is cached using `URLCache`
- animate: A flag to indicate that GIF should animate or not. If non-animated, the first frame will be displayed. Default: true. It is possible to use a `Binding` to be able to toggle this property.
- loop: Flag to indicate if the GIF should be played only once or continue to loop. Default: true. It is possible to use a `Binding` to be able to toggle this property.
- placeholder: Image to be used before the source is loaded
- errorImage: If the stream fails, this image is used
- frameRate: Option to control the frame rate of the animation or to use the GIF information about frame rate
- loopAction: Closure called whenever the GIF finishes rendering one cycle of the action

## Sample Project

A sample project can be found as a Swift Playground app on [Sample.swiftpm](Sample.swiftpm). This playground app is configured with the GIFImage package as a local dependency for better development/test, to run it on iPad's Playground app, the package reference may need to be updated.

## License

[MIT](LICENSE)

