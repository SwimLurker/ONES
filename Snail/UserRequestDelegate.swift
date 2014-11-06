//
//  UserRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetUserRequestDelegate = _UserRequestDelegate<User>

class _UserRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleUserResponse)
    }
    
    func handleUserResponse(jsonObj: JSON) -> Any? {
        var username: String
        
        if let usernameStr = jsonObj["username"].stringValue{
            username = usernameStr
        }else{
            return Error(errorCode: -101, errorMsg: "User not found")
        }
        
        var password = jsonObj["password"].stringValue
        
        var role: UserRole?
        
        if let roleNumber = jsonObj["role"].integerValue{
            role = UserRole.fromRaw(roleNumber)
            if role == nil{
                return Error(errorCode: -102, errorMsg: "Invalid role number")
            }
        }else{
            return Error(errorCode: -102, errorMsg: "Invalid role number")
        }
        
        var avatarFilename = jsonObj["avatarFilename"].stringValue
        
        return User(username: username, password: password, role: role!, avatarFilename: avatarFilename)
    }
}