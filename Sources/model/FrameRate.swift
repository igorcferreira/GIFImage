//
//  File.swift
//  
//
//  Created by Igor Ferreira on 06/04/2022.
//

import Foundation

public enum FrameRate : Sendable {
    case dynamic
    case limited(fps: Int)
    case `static`(fps: Int)
}
