import XCTest
@testable import JIFView

final class ViewTests: XCTestCase {
    
    let sampleURL = URL(string: "https://images.squarespace-cdn.com/content/v1/50ff1acce4b047a6c7999c73/1566186157381-T7WSLE7DPT8DG1VMWDBK/ke17ZwdGBToddI8pDm48kLxnK526YWAH1qleWz-y7AFZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVH-2yKxPTYak0SCdSGNKw8A2bnS_B4YtvNSBisDMT-TGt1lH3P2bFZvTItROhWrBJ0/Llama_Run_Instagram_.gif")!
    let session = URLSession.shared
    
    func testEmptyRemote() {
        let jifView = JIFView(source: .remote(url: sampleURL, session: session, cache: nil))
        XCTAssertNil(jifView.image, "Remote image should have empty raw")
    }

    static var allTests = [
        ("testEmptyRemote", testEmptyRemote),
    ]
}
