//
//  Array+JIFView.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(Combine) && canImport(ImageIO)
import Combine
import ImageIO

@available(iOS 13, OSX 10.15, *)
extension CGImageSource {
    static func getImages(_ source: CGImageSource) -> AnyPublisher<CGImage, Never> {
        let count = CGImageSourceGetCount(source)
        let range = (0..<count)
        return range.publisher.compactMap({ (index) -> CGImage? in
            CGImageSourceCreateImageAtIndex(source, index, nil)
        }).eraseToAnyPublisher()
    }
}
#endif
