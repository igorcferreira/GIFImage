//
//  File.swift
//  
//
//  Created by Igor Ferreira on 29/10/2020.
//

import ImageIO
import Foundation

public struct ImageFrame : Sendable {
    public let image: CGImage
    public let interval: TimeInterval?
}
