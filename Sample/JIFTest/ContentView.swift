//
//  ContentView.swift
//  JIFTest
//
//  Created by Igor Ferreira on 08/11/2019.
//  Copyright © 2019 Future Workshops. All rights reserved.
//

import SwiftUI
import JIFView
import Combine

enum SearchError: Error {
    case search(error: Error)
    case input
}

struct GIFRow: Identifiable {
    let gif: GIFURL
    let uuid = UUID().uuidString as NSString
    
    var id: ObjectIdentifier {
        return ObjectIdentifier(uuid)
    }
}

struct GIFURL: Codable {
    let url: String
    let frames: String
    let height: String
    let width: String
    
    var size: CGSize {
        return CGSize(width: Int(width) ?? 0, height: Int(height) ?? 0)
    }
    
    var fullURL: URL {
        return URL(string: url)!
    }
}

struct GIFImage: Codable {
    let original: GIFURL
}
struct SearchItem: Codable {
    let images: GIFImage
}

struct SearchResult: Codable {
    let data: [SearchItem]
    
    init(data: [SearchItem]) {
        self.data = data
    }
}

extension String {
    func giphyQuery(key: String) -> String {
        return "https://api.giphy.com/v1/gifs/search?q=\(self)&api_key=\(key)"
    }
}

struct ContentView: View {
    
    @State var items = [GIFRow]()
    @State var input: String = "LLama"
    @State var key: String = ""
    @State var cancellable: Cancellable? = nil
    
    func search() {
        
        guard let url = URL(string: input.giphyQuery(key: key)) else {
            return
        }
        
        self.cancellable?.cancel()
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .mapError({ SearchError.search(error: $0) })
            .tryMap({ try JSONDecoder().decode(SearchResult.self, from: $0.data) })
            .replaceError(with: SearchResult(data: []))
            .flatMap({ $0.data.publisher })
            .map({ $0.images.original })
            .map({ GIFRow(gif: $0) })
            .collect()
            .assign(to: \.items, on: self)
        
    }

    var body: some View {
        VStack {
            TextField("Giphy Key", text: $key, onCommit: self.search)
                .padding(10.0)
            TextField("Search", text: $input, onCommit: self.search)
                .padding(10.0)
            
            GeometryReader { geometry in
                List(self.items) { item in
                    JIFView(source: .remote(url: item.gif.fullURL,
                                    session: .shared,
                                    cache: FileSystemImageCache()),
                            placeholder: RawImage(named: "placeholder"))
                        .frame(idealWidth: geometry.size.width,
                               idealHeight: item.gif.size.adapted(for: geometry.size).height,
                               alignment: .center)
                }
            }
            
        }.onAppear(perform: self.search)
    }
}

extension CGSize {
    func adapted(for size: CGSize) -> CGSize {
        let scale = size.width / self.width
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
