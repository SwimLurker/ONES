//
//  User.swift
//  ONES
//
//  Created by Solution on 14/9/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

enum UserRole: Int, Printable{
    case SaleRepresentive = 1, Manager, Assistant
    
    var description: String{
        let roleNames = ["Sale Representive", "Manager", "Assistant"]
        return roleNames[toRaw() - 1]
    }
}

class User {
    let username: String!
    var password: String?
    let role: UserRole!
    var avatarFilename: String?
    
    var _mockAppList: Dictionary<Int, Array<Application>>!
    
    var _mockMessageList: Array<Message>!
    
    lazy var _mockCurrentApp: Application? = {
        if let apps = self.getApplicationsByYear()[2014] {
            return apps.last
        }else{
            return nil
        }
    }()
    
    var currentApplication: Application? {
        get{
            return _mockCurrentApp
        }
        set {
            _mockCurrentApp = newValue
            if newValue != nil {
                var apps = getApplicationsByYear()[2014]
                if apps != nil{
                    apps!.append(newValue!)
                    _mockAppList.updateValue(apps!, forKey: 2014)
                }
            }else {
                var apps = getApplicationsByYear()[2014]
                if apps != nil{
                    apps!.removeLast()
                    _mockAppList.updateValue(apps!, forKey: 2014)
                }
            }
        }
    }
    
    init(username: String, password: String?, role: UserRole, avatarFilename: String?){
        self.username = username
        self.password = password
        self.role = role
        self.avatarFilename = avatarFilename
    }
    
    //mock method
    class func getUser(username: String) -> User?{
        switch(username){
            case "UserSR":
                return User(username: username, password: "Password", role: UserRole.SaleRepresentive, avatarFilename: "avatar_sr.png")
            case "UserManager":
                return User(username: username, password: "Password", role: UserRole.Manager, avatarFilename: "avatar_manager.png")
            case "UserAS":
                return User(username: username, password: "Password", role: UserRole.Assistant, avatarFilename: "avatar_assistant.png")
            default:
                return nil
        }
    }
    
    //mock method
    func getAllApplications() -> [Application] {
        var result = Array<Application>()
        for year in getApplicationsByYear().keys{
            if let apps = getApplicationsByYear()[year]{
                for index in 0 ..< apps.count{
                    result.append(apps[index])
                }
            }
        }
        return result
    }
    
    //mock method
    func getApplicationsByYear() -> [Int: [Application]]{
        if _mockAppList == nil {
            _mockAppList = Dictionary<Int,[Application]>()
        
            let samples:[Sample] = Sample.getSamples()!
            let sampleCount = UInt32(samples.count)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
        
            let now = NSDate()
            
            for year in [2013, 2014] {
                var apps = Array<Application>()
            
                for index in 1...12 {
                    var applyDate: NSDate
                    var appID: String
                    do {
                    
                        let month = Int(arc4random_uniform(12) + 1)
                        let day = Int(arc4random_uniform(28) + 1)
                        let dateStr = NSString(format: "%04d-%02d-%02d", year, month, day)
                        appID = NSString(format: "APP-%d%02d%02d%03d", year, month, day, index)
                        applyDate  = formatter.dateFromString(dateStr)!
                        
                    }while applyDate.timeIntervalSinceDate(now) >= 0
                    
                    let sample = samples[Int(arc4random_uniform(sampleCount))]
                
                    let sampleQuantity = Int(arc4random_uniform(10))
                
                    let applySample = ApplySample(sample: sample, quantity: sampleQuantity)
                
                    let doctorName = ["John Washton","Denis Liu", "Chandler Li"][Int(arc4random_uniform(3))]
                    var status: ApplicationStatus! = ApplicationStatus.fromRaw(Int(arc4random_uniform(5) + 1))
                    let sampleUsageAddress = ["Tianjin Jiawan Masion 28th floor", "No 1 Hosptial, Beijin", "No 2 Hospital, Beijin"][Int(arc4random_uniform(3))]
                
                    
                    
                    
                    var application = Application(appID: appID, applySample: applySample, doctorName: doctorName, sampleUsageAddress: sampleUsageAddress, applier: username, applyDate: applyDate, status: status)
                    let order = InternalOrder(internalOrderNo: "ORD-\(year)010100\(index)", deliveryAddress: "WFC, Street xxx, Road xxx", costCenter: "DBD", applyPurpose: "Trail for Use")
                
                    application.internalOrder = order
                
                    apps.append(application)
                
                }
                apps = apps.sorted({app1, app2 in app1.applyDate.timeIntervalSinceDate(app2.applyDate) > 0.0 })
                _mockAppList.updateValue(apps, forKey: year)
            }
        }
        return _mockAppList!
    }

    /*
    func getCurrentApplication() -> Application? {
        if let apps = getApplicationsByYear()[2014] {
            return apps.last
        }else{
            return nil
        }
    }*/
    
    //mock method
    func getMessages() -> [Message]{
        
        if _mockMessageList == nil {
            _mockMessageList = Array<Message>()
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let now = NSDate()
            
            for index in 0...16 {
                let msgID = "MSG-\(index)"
                let i = Int(arc4random_uniform(3))
                let title = ["Message Approved by LEIT",
                    "Message Reject by LEIT",
                    "Sample received to your department"][i]
                let content = ["Message Approved by LEIT at 20141001\r\nComment:N/A....",
                    "Message Rejectby LEIT at 20141009\r\nComment:N/A...",
                    "Your applied sample(APP-20141001001) has been deliveried to your department,please go to receive sample"][i]
                
                var sentDate: NSDate
                do {
                    let year =  2013 + Int(arc4random_uniform(2))
                    let month = Int(arc4random_uniform(12)) + 1
                    let day = Int(arc4random_uniform(28)) + 1
                
                    let dateStr = NSString(format: "%04d-%02d-%02d", year, month, day)
                
                    sentDate  = formatter.dateFromString(dateStr)!
                    
                }while sentDate.timeIntervalSinceDate(now) >= 0
                
                _mockMessageList!.append(Message(id: "MSG-\(index)", title: title, content: content, sentDate: sentDate, sender: "System", isRead: [true, false][Int(arc4random_uniform(2))]))
                
                _mockMessageList = _mockMessageList.sorted({msg1, msg2 in msg1.sentDate.timeIntervalSinceDate(msg2.sentDate) > 0.0})
            }
        }
        
        
        return _mockMessageList!;
    }

    //mock method
    
    func deleteMessage(message: Message) -> Bool{
        for i in 0 ..< _mockMessageList!.count {
            if _mockMessageList[i].id == message.id{
                _mockMessageList?.removeAtIndex(i)
                break
            }
        }
        return true
    }
    
    
    
    func getAvailableSamples() -> [Sample]?{
        return Sample.getSamples()
    }
    
    func getAvailableDoctors() -> [Doctor]?{
        return Doctor.getDoctors()
    }
    
    func applyApplication(doctorInfo: (String?, String?), sampleInfo: ApplySample, orderInfo: InternalOrder) -> Application? {
        
        let appID = Application.newAppID
        let (doctorName, address) = doctorInfo
        currentApplication = Application(appID: appID, applySample: sampleInfo, doctorName: doctorName, sampleUsageAddress: address, applier: self.username, applyDate: NSDate(), status: ApplicationStatus.WaitingForApproval)
        
        currentApplication!.internalOrder = orderInfo
        
        return currentApplication
    }
    
    func updateApplication(applicationID: String, doctorInfo: (String?, String?)?, sampleInfo: ApplySample?, orderInfo: InternalOrder?) -> Application?{
        var apps = getAllApplications()
        for app in apps{
            if app.appID == applicationID {
            
                if let (doctorName, address) = doctorInfo{
                    if doctorName != nil{
                        app.doctorName = doctorName
                    }
                    if address != nil {
                        app.sampleUsageAddress = address
                    }
                }
            
                if let si = sampleInfo{
                    app.applySample = si
                }
            
                if let oi = orderInfo{
                    app.internalOrder = oi
                }
                return app
            }
        }
        return nil
        
    }
    
    func cancelCurrentApplication() -> Bool{
        currentApplication = nil
        return true
    }
    
    func cancelApplication(application: Application) -> Bool{
        if application == currentApplication {
            return cancelCurrentApplication()
        }
        for year in _mockAppList.keys {
            if var applications = _mockAppList[year] {
                for index in 0 ..< applications.count {
                    if applications[index].appID == application.appID {
                       applications.removeAtIndex(index)
                       _mockAppList.updateValue(applications, forKey: year)
                        break;
                    }
                }
            }
            
        }
        return true
    }
    
    func searchApplications(appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?) -> [Application]{
        var apps = getAllApplications()
        
        if let filterID = appID {
            var targetRegex: String = ""
            for c in filterID {
                if c == "*" {
                    targetRegex += ".*"
                }else{
                    targetRegex.append(c)
                }
            }

            apps = apps.filter({ app in app.appID.stringByMatching(targetRegex) != nil})
        }
        
        if let filterDoctor = doctorName {
            var targetRegex: String = ""
            for c in filterDoctor {
                if c == "*" {
                    targetRegex += ".*"
                }else{
                    targetRegex.append(c)
                }
            }
            apps = apps.filter({app in app.doctorName!.stringByMatching(targetRegex) != nil})
        }
        
        if let filterFromDate = fromDate {
            apps = apps.filter({app in app.applyDate.timeIntervalSinceDate(filterFromDate)>=0})
        }
        
        if let filterToDate = toDate {
            apps = apps.filter({app in app.applyDate.timeIntervalSinceDate(filterToDate)<=0})
        }
        return apps
    
    }
    
    
}