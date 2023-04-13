//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Jessica Bigal on 03/04/23.
//

import Foundation

struct EmojiArtModel: Codable {
    var background = Background.blank
    var emojis = [Emoji]()
    
    //Hashable is to make it selectible
    struct Emoji: Identifiable, Hashable, Codable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.id = id
            self.x = x
            self.y = y
            self.size = size
        }
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    init() { }
    
    private var uniqueEmogi = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size:Int) {
        uniqueEmogi += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id:uniqueEmogi))
    }
    
   
}
