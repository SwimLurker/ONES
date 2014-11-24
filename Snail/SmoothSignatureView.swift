//
//  SmoothSignatureView.swift
//  Snail
//
//  Created by Solution on 14/11/24.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class SmoothSignatureView: UIView {
    
    var lineWidth: CGFloat
    var lineColor: UIColor
    
    var path: UIBezierPath
    
    var previousPoint: CGPoint?
    var currentPoint: CGPoint?
    
    override init() {
        lineWidth = 10.0
        lineColor = UIColor.blackColor()
        path = UIBezierPath()
        super.init()
    }
    
    override init(frame: CGRect) {
        lineWidth = 10.0
        lineColor = UIColor.blackColor()
        path = UIBezierPath()
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        lineWidth = 10.0
        lineColor = UIColor.blackColor()
        path = UIBezierPath()
        super.init(coder: aDecoder)
    }
    
    
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        
        lineColor.setStroke()
        path.stroke()
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            currentPoint = touch.locationInView(self)
            previousPoint = currentPoint
            path.moveToPoint(currentPoint!)
            self.setNeedsDisplay()
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            currentPoint = touch.locationInView(self)
            if let prePoint = previousPoint {
                var midPoint = midpoint(prePoint, p1:currentPoint!)
                path.addQuadCurveToPoint(midPoint, controlPoint: prePoint)
            }
            previousPoint = currentPoint
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    func midpoint(p0: CGPoint, p1: CGPoint) ->CGPoint{
        return CGPoint(x: (p0.x + p1.x)/2, y: (p0.y + p1.y)/2)
    }
    
    func clear(){
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
}