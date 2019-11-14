//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(Combine)
import Foundation
import Combine

@available(iOS 13, OSX 10.15, *)
struct DataLoader {
    func buildDataStream(for source: Source) -> AnyPublisher<Data, Never> {
        switch source {
        case .local(let data):
            return buildLocalDataStream(for: data)
        case .remote(let url, let session, let cache):
            return buildRemoteDataStream(for: url, session: session, cache: cache)
        }
    }
    
    private func buildLocalDataStream(for data: Data) -> AnyPublisher<Data, Never> {
        return Just(data).eraseToAnyPublisher()
    }
    
    private func buildRemoteDataStream(for url: URL, session: URLSession, cache: ImageCache?) -> AnyPublisher<Data, Never> {
        
        let id = "\(url.host ?? "")_\(url.path)".replacingOccurrences(of: "/", with: "_")
        
        let cachePublisher = Just(cache?.load(id: id))
            .tryMap({ try $0.tryUnwrap() })
        
        let remotePublisher = session
            .dataTaskPublisher(for: url)
            .map({ $0.data })
            .handleEvents(receiveOutput: {
                cache?.save(data: $0, withId: id)
            })
        
        let basePublisher = cachePublisher.catch({ _ in remotePublisher })
            .replaceError(with: Data())
        
        return basePublisher.eraseToAnyPublisher()
    }
}

#endif
