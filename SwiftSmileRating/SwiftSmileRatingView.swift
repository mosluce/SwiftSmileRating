//
//  SwiftSmileRatingView.swift
//  SwiftSmileRating
//
//  Created by 默司 on 2016/8/3.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

@IBDesignable
class SwiftSmileRatingView: UIView {
    
    @IBInspectable
    var goodColor: UIColor = UIColor ( red: 0.6722, green: 0.8173, blue: 0.1632, alpha: 1.0 )
    @IBInspectable
    var normalColor: UIColor = UIColor ( red: 0.9908, green: 0.6046, blue: 0.2001, alpha: 1.0 )
    @IBInspectable
    var badColor: UIColor = UIColor ( red: 0.9132, green: 0.2553, blue: 0.2048, alpha: 1.0 )
    @IBInspectable
    var lineWidth: CGFloat = 5
    @IBInspectable
    var maxScore: Int = 100 {
        didSet {
            score = maxScore / 2
        }
    }
    
    private var score: Int = 50
    private var controlPoint: CGPoint!
    private var touchStartPoint: CGPoint!
    private var maxOffset: CGFloat!
    private var minOffset: CGFloat!
    
    private let circleShapeLayer = CAShapeLayer()
    private let lineShapeLayer = CAShapeLayer()
    
    var currentScore: Int! {
        get {
            return score
        }
    }
    
    var delegate: SwiftSmileRatingViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    
    func setup() {
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))
        self.userInteractionEnabled = true
        
        score = maxScore / 2
    }
    
    func panGestureRecognizerHandler(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Began {
            touchStartPoint = gesture.translationInView(self)
        } else if gesture.state == .Changed {
            let point = gesture.translationInView(self)
            let offset = point.y - touchStartPoint.y
            
            var y = controlPoint.y + offset
            
            if y < minOffset {
                y = minOffset
            }
            
            if y > maxOffset {
                y = maxOffset
            }
            
            let score = Int((y-minOffset)/((maxOffset-minOffset)/CGFloat(maxScore)))
            
            if self.score != score {
                self.score = score
                delegate?.smileRatingView(self, didScoreChange: self.score)
            }
            
            controlPoint = CGPointMake(controlPoint.x, y)
            
            updatePathes()
            
            touchStartPoint = point
        }
    }
    
    func updatePathes() {
        
        if score > Int(Double(maxScore) * 0.8) {
            circleShapeLayer.strokeColor = goodColor.CGColor
            lineShapeLayer.strokeColor = goodColor.CGColor
        } else if score < Int(Double(maxScore) * 0.2) {
            circleShapeLayer.strokeColor = badColor.CGColor
            lineShapeLayer.strokeColor = badColor.CGColor
        } else {
            circleShapeLayer.strokeColor = normalColor.CGColor
            lineShapeLayer.strokeColor = normalColor.CGColor
        }
        
        lineShapeLayer.path = drawSmile(self.bounds)
    }
    
    func drawSmile(rect: CGRect) -> CGPath {
        let innerSize = rect.width * 0.6
        let angle = CGFloat(M_PI)/180 * 45
        let hoffset = innerSize/2 * sin(angle)
        let woffset = innerSize/2 * cos(angle)
        let startPoint = CGPointMake(rect.width/2 - woffset, rect.width/2 + hoffset)
        let endPoint = CGPointMake(rect.width/2 + woffset, rect.width/2 + hoffset)
        
        maxOffset = rect.width/2 + hoffset + rect.width * 0.20
        minOffset = rect.width/2 + hoffset - rect.width * 0.20
        
        if controlPoint == nil {
            controlPoint = CGPoint(x: rect.width/2, y: rect.width/2 + hoffset)
        }
        
        let line = UIBezierPath()
        line.moveToPoint(startPoint)
        line.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        
        return line.CGPath
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        lineShapeLayer.frame = rect
        lineShapeLayer.lineWidth = lineWidth
        lineShapeLayer.fillColor = UIColor.clearColor().CGColor
        lineShapeLayer.strokeColor = normalColor.CGColor
        lineShapeLayer.lineCap = kCALineCapRound
        
        circleShapeLayer.frame = rect
        circleShapeLayer.lineWidth = lineWidth
        circleShapeLayer.fillColor = UIColor.clearColor().CGColor
        circleShapeLayer.strokeColor = normalColor.CGColor
        circleShapeLayer.path = UIBezierPath(
            arcCenter: CGPointMake(rect.width/2, rect.width/2), radius: rect.width/2 - lineWidth, startAngle: 0, endAngle: CGFloat(M_PI)*2, clockwise: true).CGPath
        
        lineShapeLayer.path = drawSmile(rect)
        
        self.layer.addSublayer(circleShapeLayer)
        self.layer.addSublayer(lineShapeLayer)
    }
    
    
}

protocol SwiftSmileRatingViewDelegate {
    func smileRatingView(view: SwiftSmileRatingView, didScoreChange score: Int)
}
