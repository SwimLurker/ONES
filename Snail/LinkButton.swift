//
//  LinkButton.swift
//  ONES
//
//  Created by Solution on 14/9/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import UIKit

class LinkButton: UIButton{
    
    var lineColor: UIColor?
    
    func setColor(color: UIColor){
        self.lineColor = color
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        var ctx = UIGraphicsGetCurrentContext()
        let textRect = self.titleLabel!.frame
        let descender = self.titleLabel!.font.descender
        
        CGContextSetStrokeColorWithColor(ctx, lineColor?.CGColor)
        
        CGContextMoveToPoint(ctx, textRect.origin.x , textRect.origin.y + textRect.size.height + descender + 4)
        CGContextAddLineToPoint(ctx, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + 4)
        
        CGContextClosePath(ctx)
        CGContextDrawPath(ctx, kCGPathStroke)
    }
}
