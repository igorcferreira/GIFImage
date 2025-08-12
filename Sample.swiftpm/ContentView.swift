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
            ListItem(.remoteURL(URL(
                string: "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif")!
            )),
            ListItem(.local(
                filePath: Bundle.main.path(forResource: "test", ofType: "gif")!
            ))
        ]
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle("Animate", isOn: $animate)
                .padding(.horizontal)
            Toggle("Loop", isOn: $loop)
                .padding(.horizontal)
            adaptedList {
                ForEach(items) { item in
                    if #available(iOS 26.0, *) {
                        cell(item: item)
                            .glassEffect(in: .rect(cornerRadius: 8.0))
                            .id(item.id)
                    } else {
                        cell(item: item)
                            .id(item.id)
                    }
                }
            }
            .background(.secondary.opacity(0.8))
        }
    }
    
    @ViewBuilder
    func adaptedList(
        @ViewBuilder body: () -> some View
    ) -> some View {
        ScrollView {
            LazyVStack {
                body().padding(.top)
            }
        }
    }
    
    @ViewBuilder
    func cell(item: ListItem) -> some View {
        GIFImage(
            source: item.source,
            animate: $animate,
            loop: $loop,
            placeholder: placeholder,
            errorImage: error,
            frameRate: .dynamic,
            loopAction: loopAction(source:)
        )
        .frame(height: 200.0)
        .clipShape(.rect(cornerRadius: 8.0))
    }
    
    @Sendable
    nonisolated private func loopAction(source: GIFSource) async {
        print("Loop for source: \(source)")
    }
}

#Preview {
    ContentView()
        .environment(\.locale, .init(identifier: "en"))
    ContentView()
        .environment(\.locale, .init(identifier: "pt"))
}
