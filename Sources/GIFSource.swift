//
//  File.swift
//  
//
//  Created by Igor Ferreira on 29/10/2020.
//

import Foundation

public enum GIFSource {
    case remote(url: URL)
    case local(filePath: String)
    case `static`(data: Data)
}
