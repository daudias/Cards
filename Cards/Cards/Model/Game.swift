//
//  Game.swift
//  Cards
//
//  Created by Dias
//

import UIKit

class Game {
    var cardsCount = 0
    
    var cards = [Card]()
    
    func generateCards() {
        var cards = [Card]()
        for _ in 0..<cardsCount {
            let randomCard = (
                type: CardType.allCases.randomElement()!,
                color: CardColor.allCases.randomElement()!
            )
            cards.append(randomCard)
        }
        self.cards = cards
    }
}
