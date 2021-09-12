//
//  BoardGameController.swift
//  Cards
//
//  Created by Dias
//

import UIKit

class BoardGameController: UIViewController {
    var cardsPairsCount = 8
    
    lazy var game: Game = getNewGame()
    
    lazy var startButton = getStartButton()
    
    lazy var boardGameView = getBoardGameView()
    
    var cardViews = [UIView]()
    
    private var flippedCards = [UIView]()
    
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = cardsPairsCount
        game.generateCards()
        return game
    }
    
    private func getStartButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        button.center.x = view.center.x
        
        let window = UIApplication.shared.windows[0]
        button.frame.origin.y = window.safeAreaInsets.top
        
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func getBoardGameView() -> UIView {
        let margin: CGFloat = 10
        
        let boardView = UIView()
        
        boardView.frame.origin.x = margin
        
        let window = UIApplication.shared.windows[0]
        boardView.frame.origin.y = window.safeAreaInsets.top + startButton.frame.height + margin
        
        boardView.frame.size.width = UIScreen.main.bounds.width - 2 * margin
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - window.safeAreaInsets.bottom
        
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    private func getCardsBy(dataModel: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        
        let cardViewFactory = CardViewFactory()
        
        for (index, cardModel) in dataModel.enumerated() {
            let firstCard = cardViewFactory.get(cardModel.type, withSize: cardSize, andColor: cardModel.color)
            firstCard.tag = index
            
            let secondCard = cardViewFactory.get(cardModel.type, withSize: cardSize, andColor: cardModel.color)
            secondCard.tag = index
            
            cardViews.append(firstCard)
            cardViews.append(secondCard)
        }
        
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                    self.flippedCards.remove(at: cardIndex)
                }
                
                if self.flippedCards.count == 2 {
                    checkTwoFlippedCards()
                }
            }
        }
        
        
        return cardViews
    }
    
    private func checkTwoFlippedCards() {
        let firstCard = self.game.cards[self.flippedCards.first!.tag]
        let secondCard = self.game.cards[self.flippedCards.last!.tag]
        
        if firstCard == secondCard {
            UIView.animate(withDuration: 0.3, animations: {
                self.flippedCards.first!.layer.opacity = 0
                self.flippedCards.last!.layer.opacity = 0
            }, completion: { _ in
                self.flippedCards.first!.removeFromSuperview()
                self.flippedCards.last!.removeFromSuperview()
                self.flippedCards = []
            })
        } else {
            for card in self.flippedCards {
                (card as! FlippableView).flip()
            }
        }
    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        cardViews = cards
        
        for cardView in cardViews {
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            cardView.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            
            boardGameView.addSubview(cardView)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(startButton)
        view.addSubview(boardGameView)
    }
    
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardsBy(dataModel: game.cards)
        placeCardsOnBoard(cards)
    }
}
