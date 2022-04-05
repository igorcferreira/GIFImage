//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import CoreImage

struct CGImageSourceIterator: AsyncIteratorProtocol {
    
    let loop: Bool
    let frameCount: Int
    let source: CGImageSource
    var currentFrame: Int
    
    init(source: CGImageSource, loop: Bool) {
        self.source = source
        self.frameCount = CGImageSourceGetCount(source)
        self.currentFrame = 0
        self.loop = loop
    }
    
    mutating func next() async throws -> ImageFrame? {
        
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
    
    mutating func reset() {
        currentFrame = 0
    }
}
