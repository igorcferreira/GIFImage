//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

@available(iOS 13, OSX 10.15, *)
extension Image {
    static func build(with image: UIImage) -> Image {
        #if canImport(UIKit)
        return Image(uiImage: image)
        #else
        return Image(nsImage: image)
        #endif
    }
}

#endif
