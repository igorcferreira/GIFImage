import SwiftUI
import Combine

public struct GIFImageEnvironment: EnvironmentKey {
    public static var defaultValue: GIFLoader = {
        let cache: NSCache<NSString, NSData> = NSCache()
        cache.countLimit = 100
        return GIFLoader(cache: cache)
    }()
}

public extension EnvironmentValues {
    var gifLoader: GIFLoader {
        get { self[GIFImageEnvironment.self] }
        set { self[GIFImageEnvironment.self] = newValue }
    }
}

public struct GIFImage: View {

    private let source: GIFSource
    private let loop: Bool
    private let errorImage: RawImage
    
    @Environment(\.gifLoader) var loader
    
    @State private var cancellable: AnyCancellable?
    @State private var currentFrame: GIFFrame = GIFFrame(image: RawImage())
    
    public init(source: GIFSource,
                loop: Bool = true,
                placeholder: RawImage = RawImage(),
                errorImage: RawImage? = nil) {
        self.source = source
        self.loop = loop
        self.errorImage = errorImage ?? placeholder
        self.currentFrame = GIFFrame(image: placeholder)
    }
    
    public var body: some View {
        Image.loadImage(with: currentFrame.image)
            .onAppear(perform: {
            if cancellable == nil {
                load(source: source)
            }
        })
    }
    
    private func load(source: GIFSource) {
        cancellable = loader
            .loadSource(source: source)
            .replaceError(with: [GIFFrame(image: errorImage)])
            .flatMap(GIFPublisher.init(frames:))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: {
                cancellable = nil
                if case .finished = $0, loop {
                    load(source: source)
                }
            })
            .assign(to: \.currentFrame, on: self)
    }
}

struct GIFImage_Previews: PreviewProvider {
    static var previews: some View {
        GIFImage(source: .remote(url: URL(string: "https://64.media.tumblr.com/eb81c4d7288732e2b6a9e63c166c623a/tumblr_mi3vj5Api71ryhf5lo1_400.gif")!))
    }
}
