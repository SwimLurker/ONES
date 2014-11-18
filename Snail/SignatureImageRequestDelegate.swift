//
//  SignatureImageRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/11/17.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias SignatureImageRequestDelegate = _SignatureImageRequestDelegate<UIImage>

class _SignatureImageRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleImageResponse)
    }
    
    func handleImageResponse(jsonObj: JSON) -> Any? {
        var imageURL: String
        
        if let imageURLStr = jsonObj["imageURL"].stringValue{
            imageURL = imageURLStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        var error: NSError?
        if let data = NSData.dataWithContentsOfURL(NSURL.URLWithString(imageURL), options: nil, error: &error){
            return UIImage(data: data)
        }else{
            return error!.snailError
        }
    }
}