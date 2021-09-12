//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() can not be used to create an instance")
    }
}

class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let radius = ([size.width, size.height].min() ?? 0) / 2
        
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        let path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        
        path.close()
        
        self.path = path.cgPath
        
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let edgeSize = [size.width, size.height].min() ?? 0
        
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        let origin = CGPoint(
            x: centerX - edgeSize / 2,
            y: centerY - edgeSize / 2
        )
        
        let rect = CGRect(
            origin: origin,
            size: CGSize(width: edgeSize, height: edgeSize)
        )
        
        let path = UIBezierPath(rect: rect)
        path.close()
        
        self.path = path.cgPath
        
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FillShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RandomCirclesShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 0..<15 {
            let randomX = Int.random(in: 0...Int(size.width))
            let randomY = Int.random(in: 0...Int(size.height))
            let center = CGPoint(x: randomX, y: randomY)
            
            path.move(to: center)
            
            let radius = Int.random(in: 5...15)
            
            path.addArc(
                withCenter: center,
                radius: CGFloat(radius),
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: true
            )
            
            path.close()
        }
        
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.fillColor = fillColor
        self.lineWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RandomLinesShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 0..<15 {
            let randomXStart = Int.random(in: 0...Int(size.width))
            let randomYStart = Int.random(in: 0...Int(size.height))
            let randomXEnd = Int.random(in: 0...Int(size.width))
            let randomYEnd = Int.random(in: 0...Int(size.height))
            
            path.move(to: CGPoint(x: randomXStart, y: randomYStart
            ))
            
            path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
        }
        
        self.path = path.cgPath
        
        self.strokeColor = fillColor
        self.lineWidth = 3
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        
//        UIView.animate(withDuration: 0.5) {
//            self.frame.origin = self.startTouchPoint
//            if self.transform.isIdentity {
//                self.transform = CGAffineTransform(rotationAngle: .pi)
//            } else {
//                self.transform = .identity
//            }
//        }
    }
}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
//        view.layer.addSublayer(
//            CircleShape(
//                size: CGSize(width: 200, height: 150),
//                fillColor: UIColor.gray.cgColor
//            )
//        )
        
//        view.layer.addSublayer(
//            SquareShape(
//                size: CGSize(width: 200, height: 150),
//                fillColor: UIColor.green.cgColor
//            )
//        )
        
//        view.layer.addSublayer(
//            RandomLinesShape(
//                size: CGSize(width: 200, height: 150),
//                fillColor: UIColor.red.cgColor
//            )
//        )
        
        let firstCardView = CardView<CircleShape>(frame: CGRect(x: 0, y: 0, width: 120, height: 150), color: .red)
        self.view.addSubview(firstCardView)
        firstCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
        let secondCardView = CardView<CircleShape>(frame: CGRect(x: 30, y: 0, width: 120, height: 150), color: .red)
        secondCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
        self.view.addSubview(secondCardView)
        secondCardView.isFlipped = true
    }
}

extension UIResponder {
    func responderChain() -> String {
        let definition = String(describing: Self.self)
        if let next = next {
            return definition + " -> " + next.responderChain()
        } else {
            return definition
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
