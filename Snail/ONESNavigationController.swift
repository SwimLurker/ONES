//
//  ONESNavigationController.swift
//  ONES
//
//  Created by Solution on 14/9/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import UIKit

class ONESNavigationController: UINavigationController{
    override func viewDidLoad() {
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        
        var attrs: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0) ]
        
        
        self.navigationBar.titleTextAttributes = attrs
        

        
        
    }
}