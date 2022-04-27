//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import ImageIO

public struct CGImageSourceFrameSequence: AsyncSequence {
    public typealias Element = ImageFrame

    public enum LoadError: Error {
        case invalidData
        case emptyData
    }

    public let source: CGImageSource
    public let loop: Bool

    public init(data: Data, loop: Bool) throws {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            throw LoadError.invalidData
        }

        switch CGImageSourceGetStatus(source) {
        case .statusComplete: break
        case .statusReadingHeader: break
        case .statusIncomplete: throw LoadError.emptyData
        case .statusInvalidData: throw LoadError.invalidData
        case .statusUnexpectedEOF: throw LoadError.invalidData
        case .statusUnknownType: throw LoadError.invalidData
        @unknown default: throw LoadError.invalidData
        }

        self.init(source: source, loop: loop)
    }

    public init(source: CGImageSource, loop: Bool) {
        self.source = source
        self.loop = loop
    }

    public func makeAsyncIterator() -> CGImageSourceIterator {
        CGImageSourceIterator(source: source, loop: loop)
    }
}
