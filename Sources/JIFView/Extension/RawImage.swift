//
//  File.swift
//  
//
//  Created by Igor Ferreira on 12/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(AppKit) && !canImport(UIKit)
import AppKit
public typealias RawImage = NSImage
#else
import UIKit
public typealias RawImage = UIImage
#endif

#if canImport(AppKit) && !canImport(UIKit)
import Foundation

extension RawImage {
    convenience init(cgImage: CGImage) {
        let size = NSSize(width: cgImage.width, height: cgImage.height)
        self.init(cgImage: cgImage, size: size)
    }
}
#endif
