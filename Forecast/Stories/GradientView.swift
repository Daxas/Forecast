//
//  File.swift
//  AuthorizationService
//

import UIKit

typealias GradientColors = (start: UIColor, end: UIColor)
private typealias GradientPoints = (start: CGPoint, end: CGPoint)

@IBDesignable

public class GradientView: UIView {
    
    @IBInspectable var isHorizontal: Bool = false {
        didSet {
            prepareGradientLayer()
        }
    }
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) {
        didSet {
            prepareGradientLayer()
        }
    }
    
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) {
        didSet {
            prepareGradientLayer()
        }
    }
    
    fileprivate var gradientColors: GradientColors {
        return (startColor, endColor)
    }
    
    fileprivate var colors: [CGColor] {
        return [startColor.cgColor, endColor.cgColor]
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        prepareGradientLayer()
    }
    
    func updateGradientColors(_ colors: GradientColors, animated: Bool = true) {
        
        if animated {
            animateGradient(from: gradientColors, to: colors)
        } 
    
        startColor = colors.start
        endColor = colors.end
        prepareGradientLayer()
    }
    
    private func animateGradient(from: GradientColors, to: GradientColors) {
    
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = [from.start.cgColor, from.end.cgColor]
        animation.toValue = [to.start.cgColor, to.end.cgColor]
        animation.duration = 0.50
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.add(animation, forKey:"animateGradient")
    }
    
    // MARK: - Configuration
    
    func prepareGradientLayer() {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        preparePoints(in: gradientLayer)
    }
    
    private func preparePoints(in layer: CAGradientLayer) {
        let gradientPoints = isHorizontal ? horizontalPoints() : verticalPoints()
        layer.startPoint = gradientPoints.start
        layer.endPoint = gradientPoints.end
    }
    
    
    // MARK: - Public
    
    
    // MARK: - Helpers
    
    private func horizontalPoints() -> GradientPoints {
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        return GradientPoints(start: startPoint, end: endPoint)
    }
    
    private func verticalPoints() -> GradientPoints {
        let startPoint = CGPoint(x: 0.5, y: 0.0)
        let endPoint = CGPoint(x: 0.5, y: 1.0)
        return GradientPoints(start: startPoint, end: endPoint)
    }
    
    // MARK: - Live rendering
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        prepareGradientLayer()
    }
    
    // MARK: - Override
    
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
}
