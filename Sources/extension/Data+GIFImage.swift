//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation
import ImageIO

extension Data {
    func imageAsyncSequence(loop: Bool) throws -> CGImageSourceFrameSequence {
        let sequence = try CGImageSourceFrameSequence(data: self, loop: loop)
        return sequence
    }
}
