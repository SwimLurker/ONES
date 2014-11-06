//
//  MockServer.swift
//  Snail
//
//  Created by Solution on 14/10/22.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class MockServer: SnailServerProtocol {
    
    func login(username: String, password: String, onSucceed: (Session?) -> (), onFailed: (Error) -> ()) {
        if let user = User.getUser(username){
            if user.password != password{
                onFailed(Error(errorCode: -100,errorMsg: "Password is wrong"))
            }else{
                onSucceed(Session(sessionID: "1234567890", currentUser: user))
            }
        }else{
            onFailed(Error(errorCode: -101, errorMsg: "User not found"))
        }
    }
    
    func logout(sessionID: String, onSucceed: () -> (), onFailed: (Error) -> ()){
        println("session:" + sessionID + " is logout")
        onSucceed()
    }
    
    func getApplicationsByYear(sessionID: String, year: Int, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession {
            onSucceed(session.currentUser.getApplicationsByYear()[year])
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getApplications(sessionID: String, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession {
            onSucceed(session.currentUser.getAllApplications())
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getApplications(sessionID: String, appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession {
            onSucceed(session.currentUser.searchApplications(appID, doctorName: doctorName, fromDate: fromDate, toDate: toDate))
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getUserCurrentApplication(sessionID: String, username: String, onSucceed: (Application?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession {
            onSucceed(session.currentUser.currentApplication)
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    
    func applyApplication(sessionID: String, doctorInfo: (String?, String?), sampleInfo: ApplySample, orderInfo: InternalOrder, onSucceed: (Application) -> (), onFailed: (Error) -> ()) {
        
        if let session = Session.currentSession {
            let result = session.currentUser.applyApplication(doctorInfo,sampleInfo: sampleInfo, orderInfo: orderInfo)
            if let resultApp = result{
                onSucceed(resultApp)
            }else{
                onFailed(Error(errorCode: -998, errorMsg: "Apply Application Failed"))
            }
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    func updateApplication(sessionID: String, applicationID: String, doctorInfo: (String?, String?)?, sampleInfo: ApplySample?, orderInfo: InternalOrder?, onSucceed: (Application) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession {
            let result = session.currentUser.updateApplication(applicationID, doctorInfo: doctorInfo, sampleInfo: sampleInfo, orderInfo: orderInfo);
            if let resultApp = result{
                onSucceed(resultApp)
            }else{
                onFailed(Error(errorCode: -998, errorMsg: "Update Application Failed"))
            }
            
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func cancelApplication(sessionID: String, applicationID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            
            var apps = session.currentUser.getAllApplications()
            for app in apps{
                if app.appID ==  applicationID{
                    if session.currentUser.cancelApplication(app){
                        onSucceed()
                    }else{
                        onFailed(Error(errorCode:-998, errorMsg: "Cancel Application Failed"))
                    }
                    break
                }
            }
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getApplicationApprovalHistory(sessionID: String, applicationID: String, onSucceed: ([ApprovalRecord]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            
            var apps = session.currentUser.getAllApplications()
            for app in apps{
                if app.appID ==  applicationID{
                    onSucceed(app.getApprovalHistory())
                    break
                }
            }
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getUserMessages(sessionID: String, userID: String, onSucceed: ([Message]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession {
            onSucceed(session.currentUser.getMessages())
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func deleteUserMessage(sessionID: String, userID: String, messageID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            
            var msgs = session.currentUser.getMessages()
            for msg in msgs{
                if msg.id == messageID{
                    if session.currentUser.deleteMessage(msg){
                        onSucceed()
                    }else{
                        onFailed(Error(errorCode:-997, errorMsg: "Delete Message Failed"))
                    }
                    break
                }
            }
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func setUserMessageRead(sessionID: String, userID: String, messageID: String, onSucceed: (Message?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            var msgs = session.currentUser.getMessages()
            for msg in msgs{
                if msg.id == messageID{
                    msg.isRead = true
                    onSucceed(msg)
                    break
                }
            }
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getDoctorsByUser(sessionID: String, userID: String, onSucceed: ([Doctor]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            if let user = User.getUser(userID) {
                onSucceed(user.getAvailableDoctors())
            }else{
                onFailed(Error(errorCode: -998, errorMsg: "Unknown User"))
            }
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getDoctorByName(sessionID: String, doctorName: String, onSucceed: (Doctor?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            onSucceed(Doctor.getDoctorByName(doctorName))
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getDoctor(sessionID: String, doctorID: String, onSucceed: (Doctor?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            onSucceed(Doctor.getDoctor(doctorID))
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    func getUserAvailableSamples(sessionID: String, userID: String, onSucceed: ([Sample]?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            if let user = User.getUser(userID) {
                onSucceed(user.getAvailableSamples())
            }else{
                onFailed(Error(errorCode: -998, errorMsg: "Unknown User"))
            }
            
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getSampleByName(sessionID: String, sampleName: String, onSucceed: (Sample?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            onSucceed(Sample.getSample(sampleName))
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
    
    func getUser(sessionID: String, userID: String, onSucceed: (User?) -> (), onFailed: (Error) -> ()) {
        if let session = Session.currentSession{
            onSucceed(User.getUser(userID))
        }else{
            onFailed(Error(errorCode: -999, errorMsg: "Please Login"))
        }
    }
}