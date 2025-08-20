//
//  MemoryGameView.swift
//  Memorize
//
//  Created by aviran dabush on 19/09/2022.
//

import SwiftUI

struct MemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    private func deal(_ card: MemoryGmae<String>.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: MemoryGmae<String>.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: MemoryGmae<String>.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstant.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstant.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: MemoryGmae<String>.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var body: some View {
        VStack {
            gameHead
            gameBody
            deckBody
            shuffle
        }
    }
    
    var gameHead: some View {
        HStack {
            Text(game.getThemeName())
            Spacer()
            Text(game.getScore())
            Spacer()
            Button ("rematch") {
                withAnimation {
                    dealt = []
                    game.newGame()
                }
            }
        }
        .font(.title)
        .padding()
        .foregroundColor(CardConstant.color)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if isUnDealt(card) || (card.matched && !card.faceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            game.choose(card)
                        }
                    }
            }
        })
        .foregroundColor(game.getColor())
        .padding(.all)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUnDealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstant.undealtWidth, height: CardConstant.undealtHeight)
        .foregroundColor(game.getColor())
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button {
            withAnimation {
                game.shuffle()
            }
        } label: {
            Text("Shuffle")
        }
    }
    
    private struct CardConstant {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: MemoryGmae<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees:(1-animatedBonusRemaining) * 360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees:(1-card.bonusRemaining) * 360-90))
                    }
                }
                .padding(7)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.matched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever())
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect()
            }
            .cardify(faceUp: card.faceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        MemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
