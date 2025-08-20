//
//  Cardify.swift
//  Memorize
//
//  Created by aviran dabush on 29/09/2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(faceUp: Bool) {
        rotation = faceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 5
    }
}

extension View {
    func cardify(faceUp: Bool) -> some View {
        self.modifier(Cardify(faceUp: faceUp))
    }
}
