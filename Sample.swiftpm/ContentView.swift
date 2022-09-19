//
//  SwiftUIView.swift
//  
//
//  Created by Igor Ferreira on 25/04/2022.
//

import SwiftUI
import GIFImage

struct ListItem: Identifiable {
    let id: UUID
    let source: GIFSource

    init(_ source: GIFSource) {
        self.id = UUID()
        self.source = source
    }
}

struct ContentView: View {

    @State var items: [ListItem]
    @State var placeholder = UIImage(systemName: "photo.circle.fill")!
    @State var error: UIImage?
    @State var animate: Bool = true
    @State var loop: Bool = true

    init(items: [GIFSource]? = nil) {
        self.items = items?.map { ListItem($0) } ?? [
            ListItem(.remote(url: URL(string: "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif")!)),
            ListItem(.local(filePath: Bundle.main.path(forResource: "test", ofType: "gif")!))
        ]
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle("Animate", isOn: $animate).padding([.leading, .trailing, .top])
            Toggle("Loop", isOn: $loop).padding([.leading, .trailing, .bottom])
            List(items) { item in
                GIFImage(
                    source: item.source,
                    animate: $animate,
                    loop: $loop,
                    placeholder: placeholder,
                    errorImage: error,
                    frameRate: .dynamic,
                    loopAction: loopAction(source:)
                ).frame(height: 175.0, alignment: .center)
            }
        }
    }
    
    @MainActor
    @Sendable private func loopAction(source: GIFSource) async {
        print("Loop for source: \(source)")
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.locale, .init(identifier: "en"))
            ContentView()
                .environment(\.locale, .init(identifier: "pt"))
        }
    }
}
