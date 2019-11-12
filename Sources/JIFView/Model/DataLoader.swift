//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//

#if canImport(Combine)
import Foundation
import Combine

@available(iOS 13, OSX 10.15, *)
struct DataLoader {
    func buildDataStream(for source: Source) -> AnyPublisher<Data, Never> {
        switch source {
        case .local(let data):
            return self.buildLocalDataStream(for: data)
        case .remote(let url, let session, let cache):
            return self.buildRemoteDataStream(for: url, session: session, cache: cache)
        }
    }
    
    private func buildLocalDataStream(for data: Data) -> AnyPublisher<Data, Never> {
        return Just(data).eraseToAnyPublisher()
    }
    
    private func buildRemoteDataStream(for url: URL, session: URLSession, cache: ImageCache?) -> AnyPublisher<Data, Never> {
        
        let id = url.pathComponents.last ?? url.host ?? UUID().uuidString
        
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
