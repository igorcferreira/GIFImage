import SwiftUI

private let kDefaultGIFFrameInterval: TimeInterval = 1.0 / 24.0

/// `GIFImage` is a `View` that loads a `Data` object from a source into `CoreImage.CGImageSource`, parse the image source
/// into frames and stream them based in the "Delay" key packaged on which frame item. The view will use the `ImageLoader` from the environment
/// to convert the fetch the `Data`
public struct GIFImage: View {

    private let action: (GIFSource) async throws -> Void
    public let source: GIFSource
    public let placeholder: RawImage
    public let errorImage: RawImage?
    public let frameRate: FrameRate

    @Environment(\.imageLoader) var imageLoader
    @State private var frame: RawImage?
    @State public var loop: Bool = true

    /// `GIFImage` is a `View` that loads a `Data` object from a source into `CoreImage.CGImageSource`, parse the image source
    /// into frames and stream them based in the "Delay" key packaged on which frame item.
    ///
    /// - Parameters:
    ///   - source: Source of the image. If the source is remote, the response is cached using `URLCache`
    ///   - loop: Flag to indicate if the GIF should be played only once or continue to loop
    ///   - placeholder: Image to be used before the source is loaded
    ///   - errorImage: If the stream fails, this image is used
    ///   - frameRate: Option to control the frame rate of the animation or to use the GIF information about frame rate
    ///   - loopAction: Closure called whenever the GIF finishes rendering one cycle of the action
    public init(
        source: GIFSource,
        loop: Bool = true,
        placeholder: RawImage = RawImage(),
        errorImage: RawImage? = nil,
        frameRate: FrameRate = .dynamic,
        loopAction: @Sendable @escaping (GIFSource) async throws -> Void = { _ in }
    ) {
        self.source = source
        self.placeholder = placeholder
        self.errorImage = errorImage
        self.frameRate = frameRate
        self.action = loopAction
        self.loop = loop
    }

    public var body: some View {
        Image.loadImage(with: frame ?? placeholder)
            .resizable()
            .scaledToFit()
            .task(id: source, load)
    }

    @Sendable
    private func load() async {
        do {
            while(self.loop) {
                for try await imageFrame in try await imageLoader.load(source: source) {
                    try await update(imageFrame)
                }
                try await action(source)
            }
        } catch {
            frame = errorImage ?? placeholder
        }
    }

    @Sendable
    private func update(_ imageFrame: ImageFrame) async throws {
        frame = RawImage.create(with: imageFrame.image)
        let calculatedInterval = imageFrame.interval ?? kDefaultGIFFrameInterval
        let interval: Double
        switch frameRate {
        case .static(let fps):
            interval = (1.0 / Double(fps))
        case .limited(let fps):
            let intervalLimit = (1.0 / Double(fps))
            interval = max(calculatedInterval, intervalLimit)
        case .dynamic:
            interval = imageFrame.interval ?? kDefaultGIFFrameInterval
        }
        try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000.0))
    }
}

struct GIFImage_Previews: PreviewProvider {
    static let gifURL = "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif"
    static let placeholder = RawImage.create(symbol: "photo.circle.fill")!
    static let error = RawImage.create(symbol: "xmark.octagon")

    static var previews: some View {
        Group {
            GIFImage(url: gifURL, placeholder: placeholder, errorImage: error)
                .frame(width: 350.0, height: 197.0, alignment: .center)
            GIFImage(url: gifURL, placeholder: placeholder, errorImage: error, frameRate: .limited(fps: 5))
                .frame(width: 350.0, height: 197.0, alignment: .center)
            GIFImage(url: gifURL, placeholder: placeholder, errorImage: error, frameRate: .static(fps: 30))
                .frame(width: 350.0, height: 197.0, alignment: .center)
        }
    }
}
