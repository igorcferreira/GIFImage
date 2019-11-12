//
//  Optional+JIFVIew.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Future Workshops. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Data {
    func tryUnwrap() throws -> Wrapped {
        if let value = self {
            return value
        } else {
            throw GIFError.failedToLoadCache
        }
    }
}
