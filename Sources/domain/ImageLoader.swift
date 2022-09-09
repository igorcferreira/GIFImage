//
//  File.swift
//  
//
//  Created by Igor Ferreira on 05/04/2022.
//

import Foundation

/// Object responsible to load a `GIFSource` into a `ImageFrame` stream.
public struct ImageLoader {
    public let session: URLSession
    public let cache: URLCache
    public let fileManager: FileManager

    public init(session: URLSession = .shared, cache: URLCache = .shared, fileManager: FileManager = .default) {
        self.session = session
        self.cache = cache
        self.fileManager = fileManager
    }

    public func load(source: GIFSource) async throws -> CGImageSourceFrameSequence {
        let data = try await source.loadData(session: session, cache: cache, fileManager: fileManager)
        return try data.imageAsyncSequence()
    }
}

private extension GIFSource {
    func loadData(session: URLSession, cache: URLCache, fileManager: FileManager) async throws -> Data {
        switch self {
        case .static(let data): return data
        case .remote(let url): return try await url.loadData(session: session, cache: cache)
        case .local(let filePath): return try await filePath.loadData(fileManager: fileManager)
        }
    }
}

private extension String {
    func loadData(fileManager: FileManager) async throws -> Data {
        guard fileManager.fileExists(atPath: self) else {
            throw URLError(.fileDoesNotExist)
        }
        guard let data = fileManager.contents(atPath: self) else {
            throw URLError(.cannotOpenFile)
        }
        return data
    }
}

private extension URL {
    func loadData(session: URLSession, cache: URLCache) async throws -> Data {
        let request = URLRequest(url: self)
        if let cache = cache.cachedResponse(for: request) {
            return cache.data
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.isSuccess else {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
        return data
    }
}

private extension HTTPURLResponse {
    var isSuccess: Bool {
        200..<300 ~= statusCode
    }
}
