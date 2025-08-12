import SwiftUI

/// `GIFImage` is a `View` that loads a `Data` object from a source into `CoreImage.CGImageSource`, parse the image source
/// into frames and stream them based in the "Delay" key packaged on which frame item. The view will use the `ImageLoader` from the environment
/// to convert the fetch the `Data`
public struct GIFImage: View {
    public let source: GIFSource
    public let placeholder: RawImage
    public let errorImage: RawImage?
    private let presentationController: PresentationController
    
    @Environment(\.imageLoader) var imageLoader
    @State @MainActor private var frame: RawImage?
    @Binding public var loop: Bool
    @Binding public var animate: Bool
    @State private var presentationTask: Task<(), Never>?
    
    /// `GIFImage` is a `View` that loads a `Data` object from a source into `CoreImage.CGImageSource`, parse the image source
    /// into frames and stream them based in the "Delay" key packaged on which frame item.
    ///
    /// - Parameters:
    ///   - source: Source of the image. If the source is remote, the response is cached using `URLCache`
    ///   - animate: A flag to indicate that GIF should animate or not. If non-animated, the first frame will be displayed
    ///   - loop: Flag to indicate if the GIF should be played only once or continue to loop
    ///   - placeholder: Image to be used before the source is loaded
    ///   - errorImage: If the stream fails, this image is used
    ///   - frameRate: Option to control the frame rate of the animation or to use the GIF information about frame rate
    ///   - loopAction: Closure called whenever the GIF finishes rendering one cycle of the action
    public init(
        source: GIFSource,
        animate: Bool,
        loop: Bool,
        placeholder: RawImage = RawImage(),
        errorImage: RawImage? = nil,
        frameRate: FrameRate = .dynamic,
        loopAction: @Sendable @escaping (GIFSource) async throws -> Void = { _ in }
    ) {
        self.init(
            source: source,
            animate: .constant(animate),
            loop: .constant(loop),
            placeholder: placeholder,
            errorImage: errorImage,
            frameRate: frameRate,
            loopAction: loopAction
        )
    }
    
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
        animate: Binding<Bool> = Binding.constant(true),
        loop: Binding<Bool> = Binding.constant(true),
        placeholder: RawImage = RawImage(),
        errorImage: RawImage? = nil,
        frameRate: FrameRate = .dynamic,
        loopAction: @Sendable @escaping (GIFSource) async throws -> Void = { _ in }
    ) {
        self.source = source
        self._animate = animate
        self._loop = loop
        self.placeholder = placeholder
        self.errorImage = errorImage
        
        self.presentationController = PresentationController(
            source: source,
            frameRate: frameRate,
            animate: animate,
            loop: loop,
            action: loopAction
        )
    }
    
    public var body: some View {
        Image.loadImage(with: frame ?? placeholder)
            .resizable()
            .scaledToFit()
            .onChange(of: loop) { _, newValue in
                handle(loop: newValue)
            }
            .onChange(of: animate) { _, newValue in
                handle(animate: newValue)
            }
            .task(id: source, load)
    }
    
    private func handle(animate: Bool) {
        if animate {
            Task { await load() }
        } else {
            presentationTask?.cancel()
        }
    }
    
    private func handle(loop: Bool) {
        if loop { Task { await load() }}
    }
    
    @Sendable
    private func load() async {
        let fallback = errorImage ?? placeholder
        updatePresentation(task: Task { await presentationController.start(
            imageLoader: imageLoader,
            fallbackImage: fallback,
            frameUpdate: setFrame(_:)
        )})
    }
    
    private func updatePresentation(
        task: Task<(), Never>?
    ) {
        presentationTask?.cancel()
        presentationTask = task
    }
    
    @MainActor
    private func setFrame(_ frame: RawImage) async {
        self.frame = frame
    }
}

#if DEBUG
@MainActor let placeholder = RawImage.create(symbol: "photo.circle.fill")!
@MainActor let error = RawImage.create(symbol: "xmark.octagon")
@MainActor let gifURL = "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif"

#Preview("Raw URL") {
    GIFImage(url: gifURL, placeholder: placeholder, errorImage: error)
}
#Preview("Limited 5 FPS") {
    GIFImage(url: gifURL, placeholder: placeholder, errorImage: error, frameRate: .limited(fps: 5))
}
#Preview("Limited to 30 FPS") {
    GIFImage(url: gifURL, placeholder: placeholder, errorImage: error, frameRate: .static(fps: 30))
}
#endif
