//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(AppKit)
import Foundation
import SwiftUI

@available(iOS 13, OSX 10.15, *)
extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
#endif
