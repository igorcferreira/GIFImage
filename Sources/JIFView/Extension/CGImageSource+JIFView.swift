//
//  Array+JIFView.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Future Workshops. All rights reserved.
//

#if canImport(UIKit) && canImport(Combine)
import SwiftUI
import UIKit
import Combine

extension CGImageSource {
    static func getImages(_ source: CGImageSource) -> AnyPublisher<CGImage, Never> {
        let count = CGImageSourceGetCount(source)
        return (0..<count).publisher.compactMap({ (index) -> CGImage? in
            CGImageSourceCreateImageAtIndex(source, index, nil)
        }).eraseToAnyPublisher()
    }
}
#endif
