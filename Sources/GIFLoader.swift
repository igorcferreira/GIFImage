//
//  File.swift
//  
//
//  Created by Igor Ferreira on 29/10/2020.
//

import Foundation
import Combine
import CoreImage

public struct GIFLoader {
    private let urlSession: URLSession
    private let fileManager: FileManager
    private let cache: NSCache<NSString, NSData>
    
    public init(urlSession: URLSession = .shared, fileManager: FileManager = .default, cache: NSCache<NSString, NSData> = NSCache()) {
        self.urlSession = urlSession
        self.fileManager = fileManager
        self.cache = cache
    }
    
    public func loadSource(receiveOn: DispatchQueue = .main, source: GIFSource) -> AnyPublisher<[GIFFrame], Error> {
        switch source {
        case .remote(let url):
            
            if let data = cache.object(forKey: url.absoluteString as NSString),
               let source = CGImageSourceCreateWithData(data as CFData, nil) {
                return Just(source.getGIFFrames())
                    .mapError({ $0 as Error })
                    .eraseToAnyPublisher()
            }
            
            return urlSession
                .dataTaskPublisher(for: url)
                .map({ $0.data })
                .handleEvents(receiveOutput: { cache.setObject($0 as NSData, forKey: url.absoluteString as NSString) })
                .map({ CGImageSourceCreateWithData($0 as CFData, nil) })
                .mapError({ $0 as Error })
                .receive(on: receiveOn)
                .map({ $0.getGIFFrames() })
                .eraseToAnyPublisher()
            
        case .local(let filePath):
            if let data = fileManager.contents(atPath: filePath), let source = CGImageSourceCreateWithData(data as CFData, nil) {
                return Just(source.getGIFFrames())
                    .mapError({ $0 as Error })
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: URLError(URLError.Code.unknown)).eraseToAnyPublisher()
            }
        case .static(let data):
            if let source = CGImageSourceCreateWithData(data as CFData, nil) {
                return Just(source.getGIFFrames())
                    .mapError({ $0 as Error })
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: URLError(URLError.Code.unknown)).eraseToAnyPublisher()
            }
        }
    }
}
