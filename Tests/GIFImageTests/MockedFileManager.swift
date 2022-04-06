//
//  File.swift
//  
//
//  Created by Igor Ferreira on 06/04/2022.
//

import Foundation

class MockedFileManager: FileManager {
    private var mockedContent = [String: Data]()
    
    func register(_ data: Data, toPath path: String) {
        mockedContent[path] = data
    }
    
    func unregister(path: String) {
        mockedContent.removeValue(forKey: path)
    }
    
    override func fileExists(atPath path: String) -> Bool {
        return mockedContent.keys.contains(path)
    }
    
    override func contents(atPath path: String) -> Data? {
        return mockedContent[path]
    }
}
