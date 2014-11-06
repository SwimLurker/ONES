//
//  InfoTableViewCell.swift
//  ONES
//
//  Created by Solution on 14/10/8.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

@objc(InfoTableViewCell)
class InfoTableViewCell: RETableViewCell{
    
     
    func heightWithItem(item: RETableViewItem?, tableViewManager:RETableViewManager?) -> CGFloat{
        return 60.0
    }
    
    override func cellDidDisappear() {
        
    }
    
}