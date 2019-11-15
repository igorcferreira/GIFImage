# JIFView

This package contains a SwiftUI View that is able to render a GIF, either from a remote URL, or from a local Data. The component was born from the wish to try out the Combine Framework, and it is more of a learning tool than a production ready code.

## Why not a GIF?

![Hipster LLama](https://images.squarespace-cdn.com/content/v1/50ff1acce4b047a6c7999c73/1566186157381-T7WSLE7DPT8DG1VMWDBK/ke17ZwdGBToddI8pDm48kLxnK526YWAH1qleWz-y7AFZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVH-2yKxPTYak0SCdSGNKw8A2bnS_B4YtvNSBisDMT-TGt1lH3P2bFZvTItROhWrBJ0/Llama_Run_Instagram_.gif)

## Use

This package can be used with either 2 sources: remote or local;

```swift
let url = URL(string: "https://images.squarespace-cdn.com/content/v1/50ff1acce4b047a6c7999c73/1566186157381-T7WSLE7DPT8DG1VMWDBK/ke17ZwdGBToddI8pDm48kLxnK526YWAH1qleWz-y7AFZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVH-2yKxPTYak0SCdSGNKw8A2bnS_B4YtvNSBisDMT-TGt1lH3P2bFZvTItROhWrBJ0/Llama_Run_Instagram_.gif")!

var localData: Data {
    let path = Bundle.main.path(forResource: "llama", ofType: "gif")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    return data
}

var body: some View {
    List {
        JIFView(source: .remote(url: url, session: .shared, cache: nil))
        JIFView(source: .local(data: localData))
    }
}
```

The view can be configured with a placeholder image placed while the GIF is being downloaded, and have the option to change the frame rate as well.

```swift
JIFView.init(source: Source,
	placeholder: RawImage? = nil,
	frameRate: TimeInterval = 0.03,
	loop: Bool = true)
```

## License

[MIT](LICENSE)

