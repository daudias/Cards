//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    override func loadView() {
        setupViews()
    }
    
    private func setupViews() {
        self.view = getRootView()
        let redView = getRedView()
        let greenView = getGreenView()
        let whiteView = getWhiteView()
        let pinkView = getPinkView()
        
        redView.transform = CGAffineTransform(rotationAngle: .pi / 3)
        
        set(view: greenView, toCenterOfView: redView)
        whiteView.center = greenView.center
        //print(greenView.ce)
        self.view.addSubview(redView)
        self.view.addSubview(pinkView)
        
        redView.addSubview(greenView)
        redView.addSubview(whiteView)
    }
    
    private func getRootView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }
    
    private func getRedView() -> UIView {
        let frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }
    
    private func getGreenView() -> UIView {
        let frame = CGRect(x: 10000, y: 10000, width: 180, height: 180)
        let view = UIView(frame: frame)
        view.backgroundColor = .green
        return view
    }
    
    private func getWhiteView() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }
    
    private func getPinkView() -> UIView {
        let frame = CGRect(x: 50, y: 300, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.opacity = 0.95
        view.layer.backgroundColor = UIColor.black.cgColor
        view.backgroundColor = .systemPink
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        layer.cornerRadius = 10
        
        view.layer.addSublayer(layer)
        

        view.transform = CGAffineTransform(rotationAngle: .pi/3).scaledBy(x: 2, y: 0.8).translatedBy(x: 50, y: 50)
    
        return view
    }
    
    private func set(view: UIView, toCenterOfView baseView: UIView) {
        view.center = CGPoint(x: baseView.bounds.midX, y: baseView.bounds.midY)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
