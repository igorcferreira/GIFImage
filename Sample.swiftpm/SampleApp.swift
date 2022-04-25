//
//  File.swift
//  
//
//  Created by Igor Ferreira on 25/04/2022.
//

import Foundation
import SwiftUI
import GIFImage

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            List {
                ContentView(
                    source: .remote(url: URL(string: "https://raw.githubusercontent.com/igorcferreira/GIFImage/main/Tests/test.gif")!),
                    placeholder: RawImage.create(symbol: "photo.circle.fill")!
                )
                ContentView(
                    source: .local(filePath: Bundle.main.path(forResource: "test", ofType: "gif")!),
                    placeholder: RawImage.create(symbol: "photo.circle.fill")!
                )
            }
        }
    }
}
