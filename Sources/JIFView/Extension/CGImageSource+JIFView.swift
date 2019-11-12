//
//  Array+JIFView.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(Combine)
import Combine

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@available(iOS 13, OSX 10.15, *)
extension CGImageSource {
    static func getImages(_ source: CGImageSource) -> AnyPublisher<CGImage, Never> {
        let count = CGImageSourceGetCount(source)
        return (0..<count).publisher.compactMap({ (index) -> CGImage? in
            CGImageSourceCreateImageAtIndex(source, index, nil)
        }).eraseToAnyPublisher()
    }
}
#endif
