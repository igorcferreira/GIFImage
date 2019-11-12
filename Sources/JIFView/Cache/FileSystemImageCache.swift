//
//  FileSystemImageCache.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

import Foundation

public struct FileSystemImageCache: ImageCache {
    
    private var rootDir: URL? {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        return URL(fileURLWithPath: basePath, isDirectory: true)
    }
    
    public func load(id: String) -> Data? {
        
        guard let root = rootDir else {
            return nil
        }
        
        let fullPath = root.appendingPathComponent(id, isDirectory: false)
        
        if let data = try? Data(contentsOf: fullPath) {
            return Data(base64Encoded: data)
        } else {
            return nil
        }
    }
    
    public func save(data: Data, withId id: String) {
        
        guard let root = rootDir else {
            return
        }
        
        let fullPath = root.appendingPathComponent(id, isDirectory: false)
        
        let saveData = data.base64EncodedData()
        do {
            #if os(macOS)
            try saveData.write(to: fullPath, options: [.atomicWrite])
            #else
            try saveData.write(to: fullPath, options: [.atomicWrite, .completeFileProtection])
            #endif
        } catch {
            print("Error saving cache: \(error.localizedDescription)")
        }
    }
}
