//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Jessica Bigal on 12/04/23.
//

import SwiftUI

//viewmodel

class EmojiArtDocument: ObservableObject {
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            autosave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private struct Autosave {
        static let  filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            print("\(thisFunction) json =  \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
            print("\(thisFunction) success!")
        } catch let encondingError where encondingError is EncodingError {
            print("\(thisFunction) couldn't encode EmojiArt as JSON because \(encondingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }
    
    init() {
        emojiArt = EmojiArtModel()
        //        emojiArt.addEmoji("🥹", at: (x: -200, y: -100), size: 80)
        //        emojiArt.addEmoji("🇧🇷", at: (x: 50, y: 100), size: 40)
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            //fetch url
            // try? means if it doesn't work bring it nil
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    //MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
        print("background set to \(background)")
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize){
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}