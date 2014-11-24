//
//  SnailServerProtocol.swift
//  Snail
//
//  Created by Solution on 14/10/22.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

protocol SnailServerProtocol{
    func login(username:String, password: String, onSucceed: (Session?)->(), onFailed: (Error)->())
    func logout(sessionID: String, onSucceed: ()->(), onFailed: (Error)->())
    func getApplicationsByYear(sessionID: String, year: Int, onSucceed: ([Application]?)->(), onFailed: (Error)->())
    func getApplications(sessionID: String, onSucceed: ([Application]?)->(), onFailed: (Error)->())
    func getApplications(sessionID: String, appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?, onSucceed: ([Application]?)->(), onFailed: (Error)->())
    func getUserCurrentApplication(sessionID: String, username: String, onSucceed: (Application?)->(), onFailed: (Error)->())
    func applyApplication(sessionID: String, doctorInfo:(String?, String?), sampleInfo: ApplySample, orderInfo: InternalOrder, onSucceed:(Application)->(), onFailed: (Error)->())
    func updateApplication(sessionID: String, applicationID: String, doctorInfo: (String?, String?)?, sampleInfo: ApplySample?, orderInfo: InternalOrder?, onSucceed: (Application)->(), onFailed: (Error)->())
    func cancelApplication(sessionID:String, applicationID: String, onSucceed: ()->(), onFailed: (Error) ->())
    func getApplicationApprovalHistory(sessionID: String, applicationID: String, onSucceed:([ApprovalRecord]?)->(), onFailed:(Error)->())
    func getUserMessages(sessionID: String, userID: String, onSucceed: ([Message]?)->(), onFailed: (Error)->())
    func deleteUserMessage(sessionID: String, userID: String, messageID: String, onSucceed: ()->(), onFailed: (Error)->())
    func setUserMessageRead(sessionID: String, userID: String, messageID: String, onSucceed: (Message?)->(), onFailed: (Error)->())
    func getDoctorsByUser(sessionID: String, userID: String, onSucceed:([Doctor]?) ->(), onFailed: (Error)->())
    func getDoctor(sessionID: String, doctorID: String, onSucceed: (Doctor?)->(), onFailed: (Error)->())
    func getDoctorByName(sessionID: String, doctorName: String, onSucceed:(Doctor?)->(), onFailed: (Error)->())
    func getUserAvailableSamples(sessionID: String, userID: String, onSucceed: ([Sample]?)->(), onFailed: (Error)->())
    func getSampleByName(sessionID: String, sampleName: String, onSucceed: (Sample?)->(), onFailed: (Error)->())
    func getUser(sessionID: String, userID:String, onSucceed: (User?)->(), onFailed: (Error)->())
    func uploadApplicationSignatureImage(sessionID: String, applicationID: String, image: UIImage, onSucceed: ()->(), onFailed: (Error)->())
    func getSignatureImage(sessionID: String, applicationID: String, onSucceed: (UIImage?)->(), onFailed: (Error)->())
    
    
}

private let _mockServerInstance = MockServer()
private let _afServerInstance = AFHTTPSnailServer()
private let _asiServerInstance = ASIHTTPSnailServer()

class SnailServer{
    class func getServer(type: String) -> SnailServerProtocol {
        switch type{
        case "Mock":
            return _mockServerInstance;
        case "AF":
            return _afServerInstance;
        case "ASI":
            return _asiServerInstance;
        default:
            return _mockServerInstance
        }
    }
    
    class var server: SnailServerProtocol{
    return getServer("AF")
    }
    
}


