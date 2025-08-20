//
//  MemoryGame.swift
//  Memorize
//
//  Created by aviran dabush on 19/09/2022.
//

import Foundation

struct MemoryGmae<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var theFaceUpCardIndex: Int?
    
    private(set) var score: Int = 0
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
           !cards[chosenIndex].faceUp,
           !cards[chosenIndex].matched
        {
            if let potentialMatch = theFaceUpCardIndex {
                
                
                
                if cards[potentialMatch].content == cards[chosenIndex].content {
                    cards[potentialMatch].matched = true
                    cards[chosenIndex].matched = true
                    score += 2
                } else {
                    if cards[potentialMatch].wasFlipped == true {
                        score -= 1
                    }
                    if cards[chosenIndex].wasFlipped == true {
                        score -= 1
                    }
                    cards[potentialMatch].wasFlipped = true
                    cards[chosenIndex].wasFlipped = true
                }
                theFaceUpCardIndex = nil
            } else {
                for index in cards.indices {
                    cards[index].faceUp = false
                }
                theFaceUpCardIndex = chosenIndex
            }
            cards[chosenIndex].faceUp.toggle()
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numbersOfPairs: Int, createCard: (Int) -> CardContent ) {
        // Create an empty array of cards
        cards = []
        // Add numOfPairs * 2 cards to the cards array
        for pairIndex in 0..<numbersOfPairs {
            let content = createCard(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        
        var faceUp = false {
            didSet {
                if faceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var matched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var wasFlipped = false
        let content: CardContent
        let id: Int
        
        //MARK: - bonus time
        
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
         
        var hasEarnedBonus: Bool {
            matched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            faceUp && !matched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
