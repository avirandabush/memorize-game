//
//  Theme.swift
//  Memorize
//
//  Created by aviran dabush on 20/09/2022.
//

import SwiftUI

struct Theme {
    var name: String
    var color: Color
    var numberOfPairs: Int
    var emoji: [String]
    
    init(name: String, color: Color, numberOfPairs: Int, emoji: [String]) {
        self.name = name
        self.color = color
        if numberOfPairs > emoji.count {
            self.numberOfPairs = emoji.count
        } else {
            self.numberOfPairs = numberOfPairs
        }
        self.emoji = emoji
    }
}
