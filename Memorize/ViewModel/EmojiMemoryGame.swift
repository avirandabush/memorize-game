//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by aviran dabush on 19/09/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    static var currentTheme: Theme?

    private static var themes : Array<Theme> = [
        Theme(name: "Emojies", color: Color.green, numberOfPairs: 8,
              emoji: ["😀", "😃", "😄", "😁", "😆", "🥹", "😅", "😂","🤣", "🥲", "☺️", "😊"].shuffled()),
        Theme(name: "Vehicles", color: Color.blue, numberOfPairs: 11,
              emoji: ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒","🚜", "🛻", "🚚"]),
        Theme(name: "Flags", color: Color.red, numberOfPairs: 10,
              emoji: ["🇲🇨", "🇲🇳", "🇲🇪", "🇲🇸", "🇲🇿", "🇲🇲", "🇳🇪", "🇵🇰", "🇸🇴", "🇸🇲"]),
        Theme(name: "Symbols", color: Color.pink, numberOfPairs: 10,
              emoji: ["☮️", "♊️", "🆔", "🕉", "☸️", "✡️", "🔯", "🕎", "☯️", "⛎"]),
        Theme(name: "Buildings", color:Color.purple, numberOfPairs: 7,
              emoji: ["🏡", "🏘", "🏚", "🏗", "🏭", "🏢", "🏬"]),
        Theme(name: "View", color: Color.cyan, numberOfPairs: 7,
              emoji: ["🌅", "🌄", "🌠", "🎇", "🎆", "🌇", "🌃"])
    ]
    
    private static func createEmojiGame() -> MemoryGmae<String> {
        // Get random theme
        currentTheme = themes.randomElement()!
        
        return MemoryGmae<String>(numbersOfPairs: currentTheme!.numberOfPairs) { pairIndex in
            currentTheme!.emoji[pairIndex]
        }
    }
    
    @Published private var model = createEmojiGame()
    
    var cards: Array<MemoryGmae<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent
    
    func choose(_ card: MemoryGmae<String>.Card) {
        model.choose(card)
    }
    
    func getColor() -> Color {
        EmojiMemoryGame.currentTheme!.color
    }
    
    func getThemeName() -> String {
        EmojiMemoryGame.currentTheme!.name
    }
    
    func getScore() -> String {
        String(model.score)
    }

    func newGame() {
        model = EmojiMemoryGame.createEmojiGame()
    }
    
    func shuffle() {
        model.shuffle()
    }
}
