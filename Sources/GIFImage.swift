import SwiftUI

private let kDefaultGIFFrameInterval: TimeInterval = 1.0 / 24.0

public struct GIFImage: View {

    public let source: GIFSource
    public let loop: Bool
    public let placeholder: RawImage
    public let errorImage: RawImage?
    
    @Environment(\.imageLoader) var imageLoader
    @State private var frame: RawImage? = nil
    
    public init(source: GIFSource, loop: Bool = true, placeholder: RawImage = RawImage(), errorImage: RawImage? = nil) {
        self.source = source
        self.loop = loop
        self.placeholder = placeholder
        self.errorImage = errorImage
    }
    
    public init?(url: String, loop: Bool = true, placeholder: RawImage = RawImage(), errorImage: RawImage? = nil) {
        guard let resolvedURL = URL(string: url) else {
            return nil
        }
        let source = GIFSource.remote(url: resolvedURL)
        self.init(source: source, loop: loop, placeholder: placeholder, errorImage: errorImage)
    }
    
    public init(url: URL, loop: Bool = true, placeholder: RawImage = RawImage(), errorImage: RawImage? = nil) {
        let source = GIFSource.remote(url: url)
        self.init(source: source, loop: loop, placeholder: placeholder, errorImage: errorImage)
    }
    
    public var body: some View {
        Image.loadImage(with: frame ?? placeholder).task(id: source) { await load() }
    }
    
    func load() async -> Void {
        do {
            for try await imageFrame in try await imageLoader.load(source: source, loop: loop) {
                try await update(imageFrame)
            }
        } catch {
            frame = errorImage
        }
    }
    
    func update(_ imageFrame: ImageFrame) async throws -> Void {
        frame = RawImage.create(with: imageFrame.image)
        let interval = imageFrame.interval ?? kDefaultGIFFrameInterval
        try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000.0))
    }
}

struct GIFImage_Previews: PreviewProvider {
    static var previews: some View {
        GIFImage(url: "https://64.media.tumblr.com/eb81c4d7288732e2b6a9e63c166c623a/tumblr_mi3vj5Api71ryhf5lo1_400.gif")
    }
}
