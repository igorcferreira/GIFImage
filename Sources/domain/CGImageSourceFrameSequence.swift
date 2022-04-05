//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import CoreImage

public struct CGImageSourceFrameSequence: AsyncSequence {
    public typealias Element = ImageFrame
    
    public let source: CGImageSource
    public let loop: Bool
    
    public init(source: CGImageSource, loop: Bool) {
        self.source = source
        self.loop = loop
    }
    
    public func makeAsyncIterator() -> CGImageSourceIterator {
        CGImageSourceIterator(source: source, loop: loop)
    }
}
