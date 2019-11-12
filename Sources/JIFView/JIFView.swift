//
//  JIFView.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//
#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI
import Combine

#if canImport(AppKit)
public typealias UIImage = NSImage
#endif


/// JIFView is a view able to load and display GIF either from an URL, or in-memory data
@available(iOS 13, OSX 10.15, *) public struct JIFView: View {
    
    @State private(set) var image: UIImage? = nil
    @State private var subscriber: Cancellable? = nil
    
    
    private let placeholder: UIImage
    private let frameRate: TimeInterval
    private let loop: Bool
    private let source: Source
    private let dataLoader = DataLoader()
    private let viewQueue = DispatchQueue(label: "SwiftUI.View.JIFView.\(UUID().uuidString)", qos: .background)
    
    
    /// JIFView is a view able to load and display GIF either from an URL, or in-memory data
    /// - Parameters:
    ///   - source: Source of the GIF. Can be either .remote, or .local
    ///   - placeholder: UIImage that will be placed in the place of the GIF while its data is being downloaded
    ///   - frameRate: Frame rate applied to the GIF
    ///   - loop: Indication if the GIF should return the first frame at end or not
    public init(source: Source,
                placeholder: UIImage? = nil,
                frameRate: TimeInterval = 0.05,
                loop: Bool = true) {
        self.placeholder = placeholder ?? UIImage()
        self.loop = loop
        self.frameRate = frameRate
        self.source = source
    }
    
    private var imageView: some View {
        let view: Image
        if let image = image {
            view = Image(uiImage: image)
        } else {
            view = Image(uiImage: placeholder)
        }
        return view.resizable()
        .aspectRatio(contentMode: ContentMode.fit)
    }
    
    public var body: some View {
        imageView.onAppear(perform: self.load)
    }
    
    private func load() {
        
        guard subscriber == nil else {
            return
        }
        
        let basePublisher = self.dataLoader.buildDataStream(for: source)
        .subscribe(on: viewQueue)
        
        let scheduler = DispatchQueue(label: UUID().uuidString,
                                      qos: .userInteractive)
        let viewModel = basePublisher.mapToGIFStream(frameRate: frameRate,
                                                         loop: loop,
                                                         scheduleOn: scheduler)
        
        subscriber = viewModel.assign(to: \.image, on: self)
    }
}

@available(iOS 13, OSX 10.15, *)
struct JIFView_Preview: PreviewProvider {
    
    static var source: Source {
        return .remote(url: URL(string: "https://images.squarespace-cdn.com/content/v1/50ff1acce4b047a6c7999c73/1566186157381-T7WSLE7DPT8DG1VMWDBK/ke17ZwdGBToddI8pDm48kLxnK526YWAH1qleWz-y7AFZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVH-2yKxPTYak0SCdSGNKw8A2bnS_B4YtvNSBisDMT-TGt1lH3P2bFZvTItROhWrBJ0/Llama_Run_Instagram_.gif")!,
                       session: .shared,
                       cache: nil)
    }
    
    static var previews: some View {
        JIFView(source: source)
    }
}
#endif
