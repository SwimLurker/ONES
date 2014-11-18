//
//  SnailServerRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation


class SnailServerRequestDelegate<T> {
    
    var failedCallback: ((Error) ->())!
    var succeedCallback: ((T?) ->())!
    var succeedCallback2: ((T) -> ())!
    var noArgsSucceedCallback: (() -> ())!
    var responseHandler: (JSON) -> Any?
    
    var jsonData: JSON = JSON.Null(nil)
    
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?, responseHandler: (JSON)->Any?){
        self.succeedCallback = succeedCallback
        self.failedCallback = failedCallback
        self.responseHandler = responseHandler
    }
    
    init(succeedCallback: ((T) ->())?, failedCallback: ((Error)->())?, responseHandler: (JSON)->Any?){
        self.succeedCallback2 = succeedCallback
        self.failedCallback = failedCallback
        self.responseHandler = responseHandler
    }
    
    init(noArgsSucceedCallback: (() ->())?, failedCallback: ((Error)->())?, responseHandler: (JSON)->Any?){
        self.noArgsSucceedCallback = noArgsSucceedCallback
        self.failedCallback = failedCallback
        self.responseHandler = responseHandler
    }
    
    func finished(statusCode: Int, responseData: NSData!) {
        
        if statusCode == 200{
            jsonData = JSON(data: responseData)
            
            if let errorCode = jsonData["errorCode"].integerValue{
                handleFailure(Error(errorCode: errorCode, errorMsg: jsonData["errorMsg"].stringValue))
            }else{
                let retObj = responseHandler(jsonData)
                
                if let errorObj =  retObj as? Error{
                    handleFailure(errorObj)
                }else{
                    //succeed(retObj)
                    if retObj == nil{
                        handleSucceedWithNoArgs()
                    }else if let nullObj = retObj as? NullObject{
                        handleSucceedWithNoArgs()
                    }else if let succeedObj = retObj as? T{
                        handleSucceed(succeedObj)
                    }else if let succeedArrayObj = retObj as? [T]{
                        if succeedArrayObj.count == 0{
                            handleSucceedWithNoArgs()
                        }else{
                            handleSucceed(succeedArrayObj[0])
                        }
                    }else{
                        handleFailure(Error(errorCode: -1, errorMsg: "Type error"))
                    }
                }
            }
        }else{
            handleFailure(Error(errorCode: -1, errorMsg: "ResponseCode is:\(statusCode)"))
        }
        
    }
    
    func failed(error: NSError) {
        handleFailure(error.snailError)
    }
    
    func handleFailure(error: Error){
        if failedCallback != nil{
            failedCallback(error)
        }
    }
    
    func handleSucceed(obj: T?){
        if succeedCallback != nil{
            succeedCallback(obj)
        }
        
        if succeedCallback2 != nil{
            succeedCallback2(obj!)
        }
        
        if noArgsSucceedCallback != nil{
            noArgsSucceedCallback()
        }
    }
    
    func handleSucceedWithNoArgs(){
        if noArgsSucceedCallback != nil {
            noArgsSucceedCallback()
        }else if succeedCallback != nil{
            succeedCallback(nil)
        }
    }
}
