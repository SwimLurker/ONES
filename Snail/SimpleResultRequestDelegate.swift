//
//  SimpleResultRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias LogoutRequestDelegate = _SimpleResultRequestDelegate<NullObject>

typealias CancelApplicationRequestDelegate = _SimpleResultRequestDelegate<NullObject>

typealias DeleteMessageRequestDelegate = _SimpleResultRequestDelegate<NullObject>

typealias SignApplicationRequestDelegate = _SimpleResultRequestDelegate<NullObject>

class _SimpleResultRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: (()->())?, failedCallback: ((Error)->())?){
        super.init(noArgsSucceedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleSimpleResultResponse)
    }
    
    func handleSimpleResultResponse(jsonObj: JSON) -> Any? {
        let result = jsonObj["result"].stringValue
        if result == nil || result != "Succeed" {
            return Error(errorCode: -1, errorMsg: "Unknow Error")
        }else{
            return nil
        }
    }
}