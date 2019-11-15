//
//  File.swift
//  
//
//  Created by Igor Ferreira on 12/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(AppKit) && !canImport(SwiftUI)
import Foundation
import AppKit

extension UIImage {
    convenience init(cgImage: CGImage) {
        let size = NSSize(width: cgImage.width, height: cgImage.height)
        self.init(cgImage: cgImage, size: size)
    }
}
#endif
