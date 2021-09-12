//
//  Shapes.swift
//  Cards
//
//  Created by Dias
//

import UIKit

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
