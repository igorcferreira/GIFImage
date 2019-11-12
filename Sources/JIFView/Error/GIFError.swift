//
//  GIFError.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

import Foundation

enum GIFError: Error {
    case failedToLoadCache
    case failedToLoadContent(error: Error)
    case failedToParseDataToImage(index: Int)
}
