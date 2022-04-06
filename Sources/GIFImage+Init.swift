//
//  File.swift
//  
//
//  Created by Igor Ferreira on 06/04/2022.
//

import SwiftUI

public extension GIFImage {
    /// `GIFImage` is a `View` that loads a `Data` object from a source into `CoreImage.CGImageSource`, parse the image source
    /// into frames and stream them based in the "Delay" key packaged on which frame item.
    ///
    /// - Parameters:
    ///   - url: URL string of the image. If the string cannot be parsed into URL, this constructor early aborts and returns `nil`
    ///   - loop: Flag to indicate if the GIF should be played only once or continue to loop
    ///   - placeholder: Image to be used before the source is loaded
    ///   - errorImage: If the stream fails, this image is used
    ///   - frameRate: Option to control the frame rate of the animation or to use the GIF information about frame rate
    init?(
        url: String,
        loop: Bool = true,
        placeholder: RawImage = RawImage(),
        errorImage: RawImage? = nil,
        frameRate: FrameRate = .dynamic
    ) {
        guard let resolvedURL = URL(string: url) else {
            return nil
        }
        self.init(
            source: GIFSource.remote(url: resolvedURL),
            loop: loop,
            placeholder: placeholder,
            errorImage: errorImage,
            frameRate: frameRate
        )
    }
    
    /// `GIFImage` is a `View` that loads a `Data` object from a source into `CoreImage.CGImageSource`, parse the image source
    /// into frames and stream them based in the "Delay" key packaged on which frame item.
    ///
    /// - Parameters:
    ///   - url: URL of the image. The response is cached using `URLCache`
    ///   - loop: Flag to indicate if the GIF should be played only once or continue to loop
    ///   - placeholder: Image to be used before the source is loaded
    ///   - errorImage: If the stream fails, this image is used
    ///   - frameRate: Option to control the frame rate of the animation or to use the GIF information about frame rate
    init(
        url: URL,
        loop: Bool = true,
        placeholder: RawImage = RawImage(),
        errorImage: RawImage? = nil,
        frameRate: FrameRate = .dynamic
    ) {
        self.init(
            source: GIFSource.remote(url: url),
            loop: loop,
            placeholder: placeholder,
            errorImage: errorImage,
            frameRate: frameRate
        )
    }
}
