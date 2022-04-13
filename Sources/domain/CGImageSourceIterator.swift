//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import ImageIO

public struct CGImageSourceIterator: AsyncIteratorProtocol {

    public let loop: Bool
    public let frameCount: Int
    public let source: CGImageSource
    public private(set) var currentFrame: Int

    public init(source: CGImageSource, loop: Bool) {
        self.source = source
        self.frameCount = CGImageSourceGetCount(source)
        self.currentFrame = 0
        self.loop = loop
    }

    public mutating func next() async throws -> ImageFrame? {

        if currentFrame >= frameCount {
            if loop {
                currentFrame = 0
            } else {
                return nil
            }
        }

        let frame: ImageFrame?
        if let image = CGImageSourceCreateImageAtIndex(source, currentFrame, nil) {
            frame = ImageFrame(image: image, interval: source.intervalAtIndex(currentFrame))
        } else {
            frame = nil
        }
        currentFrame += 1
        return frame
    }

    public mutating func reset() {
        currentFrame = 0
    }
}
