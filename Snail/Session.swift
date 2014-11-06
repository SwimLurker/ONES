//
//  Session.swift
//  Snail
//
//  Created by Solution on 14/10/22.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class Session {
    var sessionID: String
    var currentUser: User
    
    class var currentSession: Session?{
        get{
           return (UIApplication.sharedApplication().delegate as AppDelegate).currentSession
        }
        set{
            (UIApplication.sharedApplication().delegate as AppDelegate).currentSession = newValue
        }
    }
    
    init(sessionID: String, currentUser: User){
        self.sessionID = sessionID
        self.currentUser = currentUser
    }
    
    
}