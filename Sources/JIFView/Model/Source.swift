//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//

import Foundation

public enum Source {
    case remote(url: URL, session: URLSession, cache: ImageCache?)
    case local(data: Data)
}
