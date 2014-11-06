//
//  Message.swift
//  ONES
//
//  Created by Solution on 14/9/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class Message: Printable, Hashable{
    var id: String
    var title: String
    var content: String?
    var sentDate: NSDate
    var sender: String
    var isRead: Bool
    
    var description: String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:ss"
        
        return "Message\(id) Tilte: \(title), Sent by: \(sender), Sent At:\(formatter.stringFromDate(sentDate)), isRead:\(isRead), Content: \(content)"
    }
    
    var hashValue: Int{
        return id.hashValue
    }
    
    convenience init(id: String, title: String, content: String?, sentDate: NSDate, sender: String){
        self.init(id: id, title: title, content: content, sentDate: sentDate, sender: sender, isRead: false)
    }
    
    init(id: String, title: String, content: String?, sentDate: NSDate, sender: String, isRead: Bool){
        self.id = id
        self.title = title
        self.content = content
        self.sentDate = sentDate
        self.sender = sender
        self.isRead = isRead
    }
}

func == (lhs: Message, rhs: Message) -> Bool{
    return lhs.id == rhs.id
}