//
//  File.swift
//  
//
//  Created by Igor Ferreira on 29/10/2020.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct GIFFrame {
    let image: RawImage
    let delay: TimeInterval
    
    init(image: RawImage, delay: TimeInterval = Double.infinity) {
        self.image = image
        self.delay = delay
    }
}
