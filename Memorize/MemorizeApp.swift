//
//  MemorizeApp.swift
//  Memorize
//
//  Created by aviran dabush on 19/09/2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    private let game = EmojiMemoryGame()
    
    
    var body: some Scene {
        WindowGroup {
            MemoryGameView(game: game)
        }
    }
}
