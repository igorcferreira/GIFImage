//
//  File.swift
//  
//
//  Created by Igor Ferreira on 12/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

extension UIImage {
    static func build(with cgImage: CGImage) -> UIImage {
        #if canImport(UIKit)
        return UIImage(cgImage: cgImage)
        #else
        let size = NSSize(width: cgImage.width, height: cgImage.height)
        return UIImage(cgImage: cgImage, size: size)
        #endif
    }
}
