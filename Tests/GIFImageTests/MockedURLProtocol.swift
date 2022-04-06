//
//  File.swift
//  
//
//  Created by Igor Ferreira on 06/04/2022.
//

import Foundation

final class MockedURLProtocol: URLProtocol {
    
    private static var results = [URL: Result<Data, URLError>]()
    
    static func register(_ result: Result<Data, URLError>, to url: URL) {
        results[url] = result
    }
    
    static func unregister(url: URL) {
        results.removeValue(forKey: url)
    }
    
    static func buildTestSession() -> URLSession {
        let baseConfiguration = URLSessionConfiguration.default
        baseConfiguration.protocolClasses = [MockedURLProtocol.self] + (baseConfiguration.protocolClasses ?? [])
        return URLSession(configuration: baseConfiguration)
    }
    
    //When this protocol is active, it intercepts all requests.
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = self.request.url, let result = MockedURLProtocol.results[url] else {
            self.client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        
        switch(result) {
        case .success(let data): self.client?.urlProtocol(self, didLoad: data)
        case .failure(let error): self.client?.urlProtocol(self, didFailWithError: error)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
