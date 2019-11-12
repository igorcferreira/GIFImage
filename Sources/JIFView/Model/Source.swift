//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

import Foundation

public enum Source {
    case remote(url: URL, session: URLSession, cache: ImageCache?)
    case local(data: Data)
}
