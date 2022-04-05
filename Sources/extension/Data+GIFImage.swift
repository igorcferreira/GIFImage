//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import CoreImage

extension Data {
    func imageAsyncSequence(loop: Bool) throws -> CGImageSourceFrameSequence {
        guard let source = CGImageSourceCreateWithData(self as CFData, nil) else {
            throw URLError(.badServerResponse)
        }
        return source.asyncSequence(loop: loop)
    }
}
