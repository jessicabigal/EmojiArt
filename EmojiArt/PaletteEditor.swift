//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Jessica Bigal on 17/04/23.
//

import SwiftUI

struct PaletteEditor: View {
    @State private var palette: Palette = PaletteStore(named: "Test").palette(at: 0)
    
    var body: some View {
        Form {
            TextField("Name", text: $palette.name)
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor()
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
