//
//  Cards.swift
//  Cards
//
//  Created by Dias
//

import UIKit

protocol FlippableView: UIView {
    
    var isFlipped: Bool { get set }
    
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    var cornerRadius = 20
    
    private var startTouchPoint: CGPoint!
    
    var isFlipped: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var flipCompletionHandler: ((FlippableView) -> Void)?
    
    private let margin: Int = 10
    
    lazy var frontSideView: UIView = getFrontSideView()
    
    lazy var backSideView: UIView = getBackSideView()
    
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }

    private func getFrontSideView() -> UIView {
        let view = UIView(frame: bounds)
        view.backgroundColor = .white
        
        let shapeView = UIView(
            frame: CGRect(
                x: margin,
                y: margin,
                width: Int(bounds.width) - 2 * margin,
                height: Int(bounds.height) - 2 * margin
            )
        )
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    private func getBackSideView() -> UIView {
        let view = UIView(frame: bounds)
        view.backgroundColor = .white
    
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = RandomCirclesShape(size: view.frame.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = RandomLinesShape(size: view.frame.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        UIView.transition(
            from: fromView,
            to: toView,
            duration: 0.5,
            options: [.transitionFlipFromTop]
        ) { _ in
            self.flipCompletionHandler?(self)
        }
        isFlipped = !isFlipped
    }
    
    var color: UIColor!
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    
    private func setupBorders() {
        clipsToBounds = true
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
    }
}
