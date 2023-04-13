//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Jessica Bigal on 03/04/23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
