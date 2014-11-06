//
//  MessagesRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetMessagesRequestDelegate = _MessagesRequestDelegate<Array<Message>>

class _MessagesRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleMessagesResponse)
    }
    
    func handleMessagesResponse(jsonObj: JSON) -> Any? {
        var result = Array<Message>()
        
        if let appArray = jsonObj.arrayValue {
            
            for appJson in appArray{
                var msgID: String
                var title: String
                var content: String?
                var sentDate: NSDate
                var sender: String
                var isRead: Bool
                
                if let msgIDStr = appJson["id"].stringValue{
                    msgID = msgIDStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let titleStr = appJson["title"].stringValue {
                    title = titleStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                content = appJson["content"].stringValue
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                if let sentDateStr = appJson["sentDate"].stringValue{
                    if let sDate = formatter.dateFromString(sentDateStr) {
                        sentDate = sDate
                    }else{
                        return Error(errorCode: -203, errorMsg: "Invalid Date Format")
                    }
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                
                if let senderStr = appJson["sender"].stringValue{
                    sender = senderStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                isRead = appJson["isRead"].boolValue
                
                var msg = Message(id: msgID, title: title, content: content, sentDate: sentDate, sender: sender, isRead: isRead)
                
                result.append(msg)
            }
            return result;
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
    }
}