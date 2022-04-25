//
//  SwiftUIView.swift
//  
//
//  Created by Igor Ferreira on 25/04/2022.
//

import SwiftUI
import GIFImage

struct ContentView: View {

    @State var gifURL: String
    @State var placeholder: RawImage
    @State var error: RawImage?

    init() {
        self.gifURL = "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif"
        self.placeholder = RawImage.create(symbol: "photo.circle.fill")!
        self.error = RawImage.create(symbol: "xmark.octagon")
    }

    init(gifURL: String, placeholder: RawImage, error: RawImage?) {
        self.gifURL = gifURL
        self.placeholder = placeholder
        self.error = error
    }

    var body: some View {
        List {
            GIFImage(url: gifURL, placeholder: placeholder, errorImage: error)
                .frame(width: 350.0, height: 197.0, alignment: .center)
            GIFImage(url: gifURL, placeholder: placeholder, errorImage: error, frameRate: .limited(fps: 5))
                .frame(width: 350.0, height: 197.0, alignment: .center)
            GIFImage(url: gifURL, placeholder: placeholder, errorImage: error, frameRate: .static(fps: 30))
                .frame(width: 350.0, height: 197.0, alignment: .center)
        }
    }
}
