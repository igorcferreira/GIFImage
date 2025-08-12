//
//  File.swift
//  
//
//  Created by Igor Ferreira on 06/04/2022.
//

import Foundation

final class MockedURLProtocol: URLProtocol {

    nonisolated(unsafe) private static var results = [URL: Result<Data, URLError>]()

    static func register(_ result: Result<Data, URLError>, to url: URL) {
        results[url] = result
    }

    static func unregister(url: URL) {
        results.removeValue(forKey: url)
    }

    static func reset() {
        results.removeAll()
    }

    static func buildTestSession() -> URLSession {
        let baseConfiguration = URLSessionConfiguration.default
        baseConfiguration.protocolClasses = [MockedURLProtocol.self] + (baseConfiguration.protocolClasses ?? [])
        baseConfiguration.timeoutIntervalForRequest = 1.0
        baseConfiguration.timeoutIntervalForResource = 1.0
        return URLSession(configuration: baseConfiguration)
    }

    // When this protocol is active, it intercepts all requests.
    // swiftlint:disable static_over_final_class
    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    // swiftlint:enable static_over_final_class

    override func startLoading() {
        guard let url = self.request.url, let result = MockedURLProtocol.results[url] else {
            self.client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            self.client?.urlProtocolDidFinishLoading(self)
            return
        }

        switch result {
        case .success(let data): self.completeRequest(url: url, data: data)
        case .failure(let error): self.failRequest(url: url, error: error)
        }
    }

    override func stopLoading() {}

    private func failRequest(url: URL, error: URLError) {
        let response = HTTPURLResponse(url: url, statusCode: error.code.rawValue, httpVersion: nil, headerFields: nil)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    private func completeRequest(url: URL, data: Data) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        self.client?.urlProtocolDidFinishLoading(self)
    }
}
