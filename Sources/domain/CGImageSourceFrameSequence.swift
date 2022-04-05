//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import CoreImage

struct CGImageSourceFrameSequence: AsyncSequence {
    typealias Element = ImageFrame
    
    let source: CGImageSource
    let loop: Bool
    
    init(source: CGImageSource, loop: Bool) {
        self.source = source
        self.loop = loop
    }
    
    func makeAsyncIterator() -> CGImageSourceIterator {
        CGImageSourceIterator(source: source, loop: loop)
    }
}
