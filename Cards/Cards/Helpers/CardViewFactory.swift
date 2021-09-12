//
//  CardViewFactory.swift
//  Cards
//
//  Created by Dias
//

import UIKit

class CardViewFactory {
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        
        let viewColor = getViewColor(from: color)
        
        var cardView: UIView
        switch shape {
        case .circle:
            cardView = CardView<CircleShape>(frame: frame, color: viewColor)
        case .cross:
            cardView = CardView<CrossShape>(frame: frame, color: viewColor)
        case .fill:
            cardView = CardView<FillShape>(frame: frame, color: viewColor)
        case .square:
            cardView = CardView<SquareShape>(frame: frame, color: viewColor)
        }
        
        return cardView
    }
    
    private func getViewColor(from colorModel: CardColor) -> UIColor {
        switch colorModel {
        case .black:
            return .black
        case .brown:
            return .brown
        case .green:
            return .green
        case .gray:
            return .gray
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        case .red:
            return .red
        }
    }
}
