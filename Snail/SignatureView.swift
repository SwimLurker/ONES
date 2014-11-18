//
//  SignatureView.swift
//  Snail
//
//  Created by Solution on 14/11/9.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class SignatureView: UIView {
    var lineWidth: CGFloat
    var lineColor: UIColor
    
    var lineArray: [Array<String>]
    var pointArray: [String]
    
    override init() {
        lineWidth = 10.0
        lineColor = UIColor.blackColor()
        lineArray = Array<Array<String>>()
        pointArray = Array<String>()
        super.init()
    }
    
    override init(frame: CGRect) {
        lineWidth = 10.0
        lineColor = UIColor.blackColor()
        lineArray = Array<Array<String>>()
        pointArray = Array<String>()
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        lineWidth = 10.0
        lineColor = UIColor.blackColor()
        lineArray = Array<Array<String>>()
        pointArray = Array<String>()
        super.init(coder: aDecoder)
    }


    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        
        CGContextBeginPath(context)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetLineJoin(context, kCGLineJoinRound)
        CGContextSetLineCap(context, kCGLineCapRound)
        
        
        for preLinePointArray in lineArray{
            if preLinePointArray.count > 0 {
                CGContextBeginPath(context)
                var startPoint = CGPointFromString(preLinePointArray[0])
                CGContextMoveToPoint(context, startPoint.x, startPoint.y)
                
                for var i = 1; i < preLinePointArray.count; ++i {
                    var endPoint = CGPointFromString(preLinePointArray[i])
                    CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
                }
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
                CGContextSetLineWidth(context, lineWidth)
                CGContextStrokePath(context)
            }
        }
        
        if pointArray.count > 0 {
            CGContextBeginPath(context)
            var startPoint = CGPointFromString(pointArray[0])
            CGContextMoveToPoint(context, startPoint.x, startPoint.y)
            let count = pointArray.count
            for var i = 1; i < count; i++ {
                var endPoint = CGPointFromString(pointArray[i])
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
            }
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
            CGContextSetLineWidth(context, lineWidth)
            CGContextStrokePath(context)
        }
    }
    
    func addPA(point: CGPoint){
        var sPoint = NSStringFromCGPoint(point)
        pointArray.append(sPoint)
    }
    
    func addLA(){
        var newArray = Array<String>()
        for point in pointArray{
            newArray.append(point)
        }
        lineArray.append(newArray)
        pointArray = Array<String>()
        //println("add Line with points :\(newArray.count)")
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            addPA(touch.locationInView(self))
            //println("add point :" + sPoint)
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        addLA()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
    }
    
    func clear(){
        lineArray.removeAll(keepCapacity: false)
        pointArray.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
}