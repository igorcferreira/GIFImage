//
//  ImageCache.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

import Foundation

public protocol ImageCache {
    func load(id: String) -> Data?
    func save(data: Data, withId id: String)
}
