//
//  MessageRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias SetUserMessageReadRequestDelegate = _MessageRequestDelegate<Message>

class _MessageRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleMessageResponse)
    }
    
    func handleMessageResponse(jsonObj: JSON) -> Any? {
        var msgID: String
        var title: String
        var content: String?
        var sentDate: NSDate
        var sender: String
        var isRead: Bool
                
        if let msgIDStr = jsonObj["id"].stringValue{
            msgID = msgIDStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
                
        if let titleStr = jsonObj["title"].stringValue {
            title = titleStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
                
        content = jsonObj["content"].stringValue
                
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
        if let sentDateStr = jsonObj["sentDate"].stringValue{
            if let sDate = formatter.dateFromString(sentDateStr) {
                sentDate = sDate
            }else{
                return Error(errorCode: -203, errorMsg: "Invalid Date Format")
            }
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
                
                
        if let senderStr = jsonObj["sender"].stringValue{
            sender = senderStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
                
        isRead = jsonObj["isRead"].boolValue
                
        return Message(id: msgID, title: title, content: content, sentDate: sentDate, sender: sender, isRead: isRead)
        
    }
}