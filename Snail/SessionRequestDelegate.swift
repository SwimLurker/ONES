//
//  SessionRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias LoginRequestDelegate = _SessionRequestDelegate<Session>

class _SessionRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleSessionResponse)
    }
    
    func handleSessionResponse(jsonObj: JSON) -> Any? {
        if let sessionID = jsonObj["sessionID"].stringValue{
            var username: String
            if let usernameStr = jsonObj["user"]["username"].stringValue{
                username = usernameStr
            }else{
                return Error(errorCode: -101, errorMsg: "User not found")
            }
            
            var password = jsonObj["user"]["password"].stringValue
            
            var role: UserRole?
            
            if let roleNumber = jsonObj["user"]["role"].integerValue{
                role = UserRole.fromRaw(roleNumber)
                if role == nil{
                    return Error(errorCode: -102, errorMsg: "Invalid role number")
                }
            }else{
                return Error(errorCode: -102, errorMsg: "Invalid role number")
            }
            
            var avatarFilename = jsonObj["user"]["avatarFilename"].stringValue
            
            
            return Session(sessionID: sessionID, currentUser: User(username: username, password: password, role: role!, avatarFilename: avatarFilename))
        }else{
            return Error(errorCode: -103, errorMsg: "Session ID is null")
        }
    }
}