//
//  ImageLoaderTests.swift
//  
//
//  Created by Igor Ferreira on 06/04/2022.
//

import XCTest
import GIFImage

extension Double {
    func equal(_ value: Double, precise: Int = 10) -> Bool {
        let denominator: Double = pow(10.0, Double(precise))
        let maxDiff: Double = 1 / denominator
        let realDiff: Double = self - value

        if fabs(realDiff) <= maxDiff {
            return true
        } else {
            return false
        }
    }
}

class ImageLoaderTests: XCTestCase {

    let url = URL(string: "https://www.test.com/image.gif")!
    var gifPath: String {
        let bundle = Bundle.module
        let path = bundle.path(forResource: "test", ofType: "gif")!
        return path
    }
    var gifData: Data {
        return FileManager.default.contents(atPath: gifPath)!
    }
    let testGIFFrameCount = 19
    let testGIFDuration = 1.90

    override func setUp() async throws {
        URLProtocol.registerClass(MockedURLProtocol.self)
        MockedURLProtocol.reset()
    }

    override func tearDown() async throws {
        URLProtocol.unregisterClass(MockedURLProtocol.self)
        MockedURLProtocol.reset()
    }

    func testFailureIfURLCannotBeFound() async throws {
        let urlSession = MockedURLProtocol.buildTestSession()
        let fileManager = MockedFileManager()

        let imageLoader = ImageLoader(session: urlSession, cache: .shared, fileManager: fileManager)

        do {
            _ = try await imageLoader.load(source: GIFSource.remote(url: url), loop: false)
            XCTFail("Sequence should throw error")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, URLError.Code.badURL)
        }
    }

    func testStaticSourceLoading() async throws {
        let urlSession = MockedURLProtocol.buildTestSession()
        let fileManager = MockedFileManager()

        let imageLoader = ImageLoader(session: urlSession, cache: .shared, fileManager: fileManager)
        let sequence = try await imageLoader.load(source: GIFSource.static(data: gifData), loop: false)

        let (frameCount, duration) = try await sequence.reduce((0, 0.0)) { partial, frame in (partial.0 + 1, partial.1 + (frame.interval ?? 0.0)) }
        XCTAssertEqual(frameCount, testGIFFrameCount)
        XCTAssertTrue(duration.equal(testGIFDuration), "\(duration) is not equal to \(testGIFDuration)")
    }

    func testFileSourceLoading() async throws {
        let urlSession = MockedURLProtocol.buildTestSession()
        let fileManager = FileManager.default

        let imageLoader = ImageLoader(session: urlSession, cache: .shared, fileManager: fileManager)
        let sequence = try await imageLoader.load(source: GIFSource.local(filePath: gifPath), loop: false)

        let (frameCount, duration) = try await sequence.reduce((0, 0.0)) { partial, frame in (partial.0 + 1, partial.1 + (frame.interval ?? 0.0)) }
        XCTAssertEqual(frameCount, testGIFFrameCount)
        XCTAssertTrue(duration.equal(testGIFDuration), "\(duration) is not equal to \(testGIFDuration)")
    }

    func testRemoteSourceLoading() async throws {
        let urlSession = MockedURLProtocol.buildTestSession()
        let fileManager = MockedFileManager()
        MockedURLProtocol.register(.success(gifData), to: url)

        let imageLoader = ImageLoader(session: urlSession, cache: .shared, fileManager: fileManager)
        let sequence = try await imageLoader.load(source: GIFSource.remote(url: url), loop: false)

        let (frameCount, duration) = try await sequence.reduce((0, 0.0)) { partial, frame in (partial.0 + 1, partial.1 + (frame.interval ?? 0.0)) }
        XCTAssertEqual(frameCount, testGIFFrameCount)
        XCTAssertTrue(duration.equal(testGIFDuration), "\(duration) is not equal to \(testGIFDuration)")
    }

    func testSequenceLoadAndPresentationTime() async throws {
        let urlSession = MockedURLProtocol.buildTestSession()
        let fileManager = MockedFileManager()

        let imageLoader = ImageLoader(session: urlSession, cache: .shared, fileManager: fileManager)

        measure {
            Task {
                let sequence = try await imageLoader.load(source: GIFSource.static(data: gifData), loop: false)
                let frameCount = try await sequence.reduce(0) { partial, _ in partial + 1 }
                XCTAssertEqual(frameCount, testGIFFrameCount)
            }
        }
    }

}
