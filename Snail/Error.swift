//
//  Error.swift
//  Snail
//
//  Created by Solution on 14/10/22.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class Error{
    var errorCode: Int
    var errorMsg: String!
    
    init(errorCode: Int, errorMsg: String?){
        self.errorCode = errorCode
        self.errorMsg = errorMsg
    }
}

extension NSError{
    var snailError: Error{
        return Error(errorCode: -1, errorMsg: self.description)
    }
}