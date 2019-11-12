//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

@available(iOS 13, OSX 10.15, *)
extension Image {
    static func build(with image: UIImage) -> some View {
        #if canImport(UIKit)
        return Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: ContentMode.fit)
        #else
        return Image(nsImage: image)
            .resizable()
            .aspectRatio(contentMode: ContentMode.fit)
        #endif
    }
}

#endif
