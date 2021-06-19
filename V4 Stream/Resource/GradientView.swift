//
//  GradientView.swift
//
//  Created by Mathieu Vandeginste on 06/12/2016.
//  Copyright © 2018 Mathieu Vandeginste. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    open var shadowLayer = SwiftyInnerShadowLayer()
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var innerShadow: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        shadowLayer.cornerRadius = cornerRadius
        if innerShadow
        {
            shadowLayer.cornerRadius = cornerRadius
            shadowLayer.shadowRadius = shadowBlur
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowOffset = CGSize(width: shadowX, height: shadowY)
            self.clipsToBounds = true
            
        }
        else
        {
            self.shadowLayer.removeFromSuperlayer()
            self.layer.shadowRadius = shadowBlur
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
            self.clipsToBounds = false
        }
        
        
        
        
        
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initShadowLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initShadowLayer()
    }
    
    fileprivate func initShadowLayer() {
        layer.addSublayer(shadowLayer)
    }
    
    override open var bounds: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    override open var frame: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
}


