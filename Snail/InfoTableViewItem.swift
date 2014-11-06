//
//  InfoTableViewItem.swift
//  ONES
//
//  Created by Solution on 14/10/8.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class InfoTableViewItem: RETableViewItem{
    var lableText: String
    var valueText: String?
    
    init(lable: String, value: String?){
        lableText = lable
        valueText = value
        super.init()
    }
    
}
