# GIFImage [![Build Status](https://app.bitrise.io/app/d733d1c0249a401a/status.svg?token=4LmnxZKU0GgcdG6IehKB0Q&branch=main)](https://app.bitrise.io/app/d733d1c0249a401a)

This package contains a SwiftUI View that is able to render a GIF, either from a remote URL, or from a local Data. The component was born from the wish to try out the Combine Framework, and it is more of a learning tool than a production ready code.

## Why not a GIF?

![Hipster LLama](https://64.media.tumblr.com/eb81c4d7288732e2b6a9e63c166c623a/tumblr_mi3vj5Api71ryhf5lo1_400.gif)

## Use

This package can be used with either 3 sources: remote URL, local file path or local data;

```swift
let url = URL(string: "https://64.media.tumblr.com/eb81c4d7288732e2b6a9e63c166c623a/tumblr_mi3vj5Api71ryhf5lo1_400.gif")!

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
let urlString = "https://64.media.tumblr.com/eb81c4d7288732e2b6a9e63c166c623a/tumblr_mi3vj5Api71ryhf5lo1_400.gif"
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
    loop: Bool = true,
    placeholder: RawImage = RawImage(),
    errorImage: RawImage? = nil,
    frameRate: FrameRate = .dynamic
)
```

The project has a struct named `ImageLoader` that is responsible for parsing the source into a sequence of frames (later used in the view). This loader has a local cache using `URLCache`. The view will fetch the image loader from the view environment. So, if a different cache limits or file manager wants to be used, the `\.imageLoader` environment key can be used to override the default instance.

## License

[MIT](LICENSE)

