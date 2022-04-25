//
//  SwiftUIView.swift
//  
//
//  Created by Igor Ferreira on 25/04/2022.
//

import SwiftUI
import GIFImage

struct ContentView: View {

    @State var source: GIFSource
    @State var placeholder: RawImage
    @State var error: RawImage?

    var body: some View {
        GIFImage(
            source: source,
            loop: true,
            placeholder: placeholder,
            errorImage: error,
            frameRate: .dynamic
        ).frame(width: 350.0, height: 197.0, alignment: .center)
    }
}
