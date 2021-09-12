//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        view.backgroundColor = .white
        self.view = view
        
        // createBezier(on: view)
        // duga(on: view)
        // oval(on: view)
        // krivoi(on: view)
        broccoli(on: view)
    }
    
    private func duga(on view: UIView) {
        let centerPoint = CGPoint(x: 200, y: 200)
        let path = UIBezierPath(arcCenter: centerPoint, radius: 150, startAngle: .pi/5, endAngle: .pi, clockwise: true)
        let shapeLayer = getShapeLayer()
        shapeLayer.path = path.cgPath
        view.layer.addSublayer(shapeLayer)
    }
    
    private func getShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 5
        
        shapeLayer.fillColor = UIColor.green.cgColor
        return shapeLayer
    }
    
    private func createBezier(on view: UIView) {
        let shapeLayer = getShapeLayer()
        view.layer.addSublayer(shapeLayer)
        
        //shapeLayer.lineCap = .butt
        //shapeLayer.lineCap = .square
        //shapeLayer.lineCap = .round
        
        shapeLayer.path = getPath().cgPath
        
        let shapeLayer1 = CAShapeLayer()
        view.layer.addSublayer(shapeLayer1)
        
        shapeLayer1.strokeColor = UIColor.gray.cgColor
        shapeLayer1.lineWidth = 5
        
        shapeLayer1.fillColor = UIColor.green.cgColor
        
        shapeLayer1.path = getPath1().cgPath
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.close()
        
        path.move(to: CGPoint(x: 50, y: 70))
        path.addLine(to: CGPoint(x: 150, y: 170))
        path.addLine(to: CGPoint(x: 50, y: 170))
        path.close()
        
        return path
    }
    
    private func getPath1() -> UIBezierPath {
        let rect = CGRect(x: 200, y: 50, width: 200, height: 100)
        return UIBezierPath(rect: rect)
    }
    
    private func oval(on view: UIView) {
        let rect = CGRect(x: 50, y: 50, width: 200, height: 100)
        let path = UIBezierPath(ovalIn: rect)
        let layer = getShapeLayer()
        layer.path = path.cgPath
        view.layer.addSublayer(layer)
    }
    
    private func krivoi(on view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addCurve(
            to: CGPoint(x: 200, y: 200),
            controlPoint1: CGPoint(x: 200, y: 20),
            controlPoint2: CGPoint(x: 20, y: 200)
        )
        let layer = getShapeLayer()
        layer.path = path.cgPath
        view.layer.addSublayer(layer)
    }
    
    private func broccoli(on view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 300, y: 300))
        path.addLine(to: CGPoint(x: 200, y: 300))
        path.addLine(to: CGPoint(x: 200, y: 250))
        path.addCurve(
            to: CGPoint(x: 200, y: 150),
            controlPoint1: CGPoint(x: 150, y: 250),
            controlPoint2: CGPoint(x: 150, y: 150)
        )
        path.addCurve(
            to: CGPoint(x: 300, y: 150),
            controlPoint1: CGPoint(x: 200, y: 100),
            controlPoint2: CGPoint(x: 300, y: 100)
        )
        path.addCurve(
            to: CGPoint(x: 300, y: 250),
            controlPoint1: CGPoint(x: 350, y: 150),
            controlPoint2: CGPoint(x: 350, y: 250)
        )
        path.close()
        
        let layer = getShapeLayer()
        layer.path = path.cgPath
        view.layer.addSublayer(layer)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
