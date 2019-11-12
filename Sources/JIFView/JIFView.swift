//
//  JIFView.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Future Workshops. All rights reserved.
//
#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit
#else
import AppKit
public typealias UIImage = NSImage
#endif

@available(iOS 13, OSX 10.15, *)
public struct JIFView: View {
    
    @State var image: UIImage? = nil
    @State private var subscriber: Cancellable? = nil
    
    
    private let placeholder: UIImage
    private let frameRate: TimeInterval
    private let loop: Bool
    private let source: Source
    private let dataLoader = DataLoader()
    private let viewQueue = DispatchQueue(label: "SwiftUI.View.JIFView", qos: .background)
    
    public init(source: Source,
                placeholder: UIImage? = nil,
                frameRate: TimeInterval = 0.03,
                loop: Bool = true) {
        self.placeholder = placeholder ?? UIImage()
        self.loop = loop
        self.frameRate = frameRate
        self.source = source
    }
    
    private var imageView: Image {
        if let image = image {
            return Image.build(with: image)
        } else {
            return Image.build(with: placeholder)
        }
    }
    
    public var body: some View {
        imageView.onAppear(perform: {
            self.load()
        })
    }
    
    private func load() {
        
        guard subscriber == nil else {
            return
        }
        
        let basePublisher = self.dataLoader.buildDataStream(for: source)
        .subscribe(on: viewQueue)
        
        subscriber = basePublisher.mapToGIFStream(frameRate: frameRate,
                                                         loop: loop,
                                                         scheduleOn: viewQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
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
