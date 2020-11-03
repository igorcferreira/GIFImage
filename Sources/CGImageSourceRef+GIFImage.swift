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
import CoreImage

//The default interval is for a 30fps gif
private let kDefaultGIFFrameInterval: TimeInterval = (1.0 / 30.0)

fileprivate extension CFString {
    var asKey: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
}

public extension Optional where Wrapped == CGImageSource {
    func getGIFFrames() -> [GIFFrame] {
        self?.getGIFFrames() ?? []
    }
}
    
public extension CGImageSource {
    func getGIFFrames() -> [GIFFrame] {
        let count = CGImageSourceGetCount(self)
        let images = createImages(count: count)
        let delays = createDelays(count: count)
        
        guard images.count == delays.count else {
            return []
        }
        
        return zip(images, delays).compactMap { (image, delay) -> GIFFrame in
            let rawImage = RawImage.create(with: image)
            return GIFFrame(image: rawImage, delay: delay)
        }
    }
    
    private func createImages(count: Int) -> [CGImage] {
        (0..<count).compactMap { CGImageSourceCreateImageAtIndex(self, $0, nil) }
    }
    
    private func createDelays(count: Int) -> [TimeInterval] {
        (0..<count).compactMap { index -> TimeInterval? in
            guard let properties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) else {
                return nil
            }
            guard let gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary.asKey) else {
                return nil
            }
            let dictionary = unsafeBitCast(gifProperties, to: CFDictionary.self)
            var delay = CFDictionaryGetValue(dictionary, kCGImagePropertyGIFUnclampedDelayTime.asKey)
            if (delay == nil) {
                delay = CFDictionaryGetValue(dictionary, kCGImagePropertyGIFDelayTime.asKey)
            }
            let number = unsafeBitCast(delay, to: NSNumber.self)
            if number.doubleValue > 0 {
                return number.doubleValue
            } else {
                return kDefaultGIFFrameInterval
            }
        }
    }
}
