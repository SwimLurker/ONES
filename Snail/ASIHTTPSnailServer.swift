//
//  ASIHTTPSnailServer.swift
//  Snail
//
//  Created by Solution on 14/10/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class ASIHTTPSnailServer: NSObject, SnailServerProtocol, ASIHTTPRequestDelegate{
    
    var delegateDic: Dictionary<ASIHTTPRequest, AnyObject?>
    
    override init(){
        delegateDic = Dictionary<ASIHTTPRequest, AnyObject?>()
        super.init()
    }
    
    func login(username: String, password: String, onSucceed: (Session?) -> (), onFailed: (Error) -> ()) {
        
        var request = ASIFormDataRequest.requestWithURL(NSURL.URLWithString(Settings.loginURL)) as ASIFormDataRequest
        request.requestMethod = "Post"
        request.setPostValue(username, forKey: "username")
        request.setPostValue(password, forKey: "password")
        request.delegate = self
        
        delegateDic.updateValue(LoginRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
        
    }
    
    func logout(sessionID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.logoutURL + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Delete"
        request.delegate = self
        
        delegateDic.updateValue(LogoutRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getApplicationsByYear(sessionID: String, year: Int, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        
        var requestURL: NSURL = NSURL.URLWithString(Settings.applicationsURL + "?sessionID=" + sessionID + "&year=\(year)")
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetApplicationsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getApplications(sessionID: String, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        
        var requestURL: NSURL = NSURL.URLWithString(Settings.applicationsURL + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetApplicationsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }

    func getApplications(sessionID: String, appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.applicationsURL
        if let aID = appID{
            url += "?appID="
            url += aID
        }else{
            url += "?appID="
        }
        if let dName = doctorName{
            url += "&doctorName="
            url += dName
        }else{
            url += "&doctorName="
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM"
        
        if let from = fromDate{
            url += "&from="
            url += formatter.stringFromDate(from)
        }else{
            url += "&from="
        }
        
        url += "&sessionID="
        url += sessionID
        
        if let to = toDate{
            url += "&to="
            url += formatter.stringFromDate(to)
        }else{
            url += "&to="
        }
        
        var requestURL: NSURL = NSURL.URLWithString(url)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetApplicationsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    
    func getUserCurrentApplication(sessionID: String, username: String, onSucceed: (Application?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.userApplicationsURL.stringByReplacingOccurrencesOfString("{userid}", withString: username, options: nil, range: nil) + "?sessionID=" + sessionID + "&type=current")
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetCurrentApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func applyApplication(sessionID: String, doctorInfo: (String?, String?), sampleInfo: ApplySample, orderInfo: InternalOrder, onSucceed: (Application) -> (), onFailed: (Error) -> ()) {
        
        var request = ASIFormDataRequest.requestWithURL(NSURL.URLWithString(Settings.applicationsURL)) as ASIFormDataRequest
        request.requestMethod = "Post"
        
        request.setPostValue(sessionID, forKey: "sessionID")
        
        let (doctorName, sampleUsageAddress) = doctorInfo
        request.setPostValue(doctorName, forKey: "doctorName")
        request.setPostValue(sampleUsageAddress, forKey: "sampleUsageAddress")
        request.setPostValue(sampleInfo.sample.sampleID, forKey: "applySampleID")
        request.setPostValue(sampleInfo.quantity, forKey: "applySampleQuantity")
        if let vDate = sampleInfo.validateDate{
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            request.setPostValue(formatter.stringFromDate(vDate), forKey: "applySampleValidateDate")
        }
        
        if let isDPB = sampleInfo.isDifferentProductionBatch{
            request.setPostValue(isDPB, forKey: "applySampleIsDifferentProductionBatch")
        }
        
        if let isDM = sampleInfo.isDifferentManufacture{
            request.setPostValue(isDM, forKey: "applySampleIsDifferentManuafacture")
        }
        request.setPostValue(orderInfo.internalOrderNo, forKey: "internalOrderNo")

        if let deliveryAddress = orderInfo.deliveryAddress{
            request.setPostValue(deliveryAddress, forKey: "deliveryAddress")
        }
        
        if let costCenter = orderInfo.costCenter{
            request.setPostValue(costCenter, forKey: "costCenter")
        }
        
        if let applyPurpose = orderInfo.applyPurpose{
            request.setPostValue(applyPurpose, forKey: "applyPurpose")
        }
        
        request.delegate = self
        
        delegateDic.updateValue(NewApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func updateApplication(sessionID: String, applicationID: String, doctorInfo: (String?, String?)?, sampleInfo: ApplySample?, orderInfo: InternalOrder?, onSucceed: (Application) -> (), onFailed: (Error) -> ()) {
        
        var requestURL: NSURL = NSURL.URLWithString(Settings.applicationURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID, options: nil, range: nil))
        
        var request = ASIFormDataRequest.requestWithURL(requestURL) as ASIFormDataRequest
        
        request.requestMethod = "Put"
        
        request.setPostValue(sessionID, forKey: "sessionID")
        
        if let (doctorName, sampleUsageAddress) = doctorInfo{
            if let dName = doctorName{
                request.setPostValue(dName, forKey: "doctorName")
            }
            if let address = sampleUsageAddress{
                request.setPostValue(address, forKey: "sampleUsageAddress")
            }
        }
        
        if let applySample = sampleInfo{
            if let sampleID = applySample.sample?.sampleID{
                request.setPostValue(sampleID, forKey: "applySampleID")
            }
            
            if let sampleQuantity = applySample.quantity{
                request.setPostValue(sampleQuantity, forKey: "applySampleQuantity")
            }
            
            if let vDate = applySample.validateDate{
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                request.setPostValue(formatter.stringFromDate(vDate), forKey: "applySampleValidateDate")
            }
            
            if let isDPB = applySample.isDifferentProductionBatch{
                request.setPostValue(isDPB, forKey: "applySampleIsDifferentProductionBatch")
            }
            
            if let isDM = applySample.isDifferentManufacture{
                request.setPostValue(isDM, forKey: "applySampleIsDifferentManuafacture")
            }
        }
        
        if let internalOrder = orderInfo{
            if let orderNo = internalOrder.internalOrderNo {
                request.setPostValue(orderNo, forKey: "internalOrderNo")
            }
            
            if let deliveryAddress = internalOrder.deliveryAddress{
                request.setPostValue(deliveryAddress, forKey: "deliveryAddress")
            }
            
            if let costCenter = internalOrder.costCenter{
                request.setPostValue(costCenter, forKey: "costCenter")
            }
            
            if let applyPurpose = internalOrder.applyPurpose{
                request.setPostValue(applyPurpose, forKey: "applyPurpose")
            }
        }
        
        request.delegate = self
        
        delegateDic.updateValue(UpdateApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func cancelApplication(sessionID: String, applicationID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.applicationURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID, options: nil, range: nil) + "?sessionID=" + sessionID )
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Delete"
        request.delegate = self
        
        delegateDic.updateValue(CancelApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getApplicationApprovalHistory(sessionID: String, applicationID: String, onSucceed: ([ApprovalRecord]?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.applicationApprovalRecordsURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID, options: nil, range: nil) + "?sessionID=" + sessionID )
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetApprovalRecordsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getUserMessages(sessionID: String, userID: String, onSucceed: ([Message]?) -> (), onFailed: (Error) -> ()) {
        
        var requestURL: NSURL = NSURL.URLWithString(Settings.userMessagesURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil) + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetMessagesRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func deleteUserMessage(sessionID: String, userID: String, messageID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.userMessageURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil).stringByReplacingOccurrencesOfString("{messageid}", withString: messageID, options: nil, range: nil) + "?sessionID=" + sessionID )
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Delete"
        request.delegate = self
        
        delegateDic.updateValue(DeleteMessageRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func setUserMessageRead(sessionID: String, userID: String, messageID: String, onSucceed: (Message?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.userMessageURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil).stringByReplacingOccurrencesOfString("{messageid}", withString: messageID, options: nil, range: nil) + "?sessionID=" + sessionID )
        
        var request = ASIFormDataRequest.requestWithURL(requestURL) as ASIFormDataRequest
        request.requestMethod = "Put"
        request.setPostValue(sessionID, forKey: "sessionID")
        request.setPostValue(true, forKey: "isRead")
        request.delegate = self
        
        delegateDic.updateValue(SetUserMessageReadRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()

    }
    
    func getDoctorsByUser(sessionID: String, userID: String, onSucceed: ([Doctor]?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.userDoctorsURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil) + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetDoctorsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getDoctor(sessionID: String, doctorID: String, onSucceed: (Doctor?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.doctorURL.stringByReplacingOccurrencesOfString("{doctorid}", withString: doctorID, options: nil, range: nil) + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetDoctorRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()

    }
    
    func getDoctorByName(sessionID: String, doctorName: String, onSucceed: (Doctor?) -> (), onFailed: (Error) -> ()) {
        var urlString = Settings.doctorsURL + "?doctorName=" + doctorName + "&sessionID=" + sessionID
        var requestURL: NSURL = NSURL.URLWithString(urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetDoctorByNameRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
        
    }
    
    func getUserAvailableSamples(sessionID: String, userID: String, onSucceed: ([Sample]?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.userSamplesURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil) + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetUserAvailableSamplesRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getSampleByName(sessionID: String, sampleName: String, onSucceed: (Sample?) -> (), onFailed: (Error) -> ()) {
        var urlString = Settings.samplesURL + "?sampleName=" + sampleName + "&sessionID=" + sessionID
        var requestURL: NSURL = NSURL.URLWithString(urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetSampleByNameRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func getUser(sessionID: String, userID: String, onSucceed: (User?) -> (), onFailed: (Error) -> ()) {
        var requestURL: NSURL = NSURL.URLWithString(Settings.userURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil) + "?sessionID=" + sessionID)
        var request = ASIHTTPRequest.requestWithURL(requestURL) as ASIHTTPRequest
        request.requestMethod = "Get"
        request.delegate = self
        
        delegateDic.updateValue(GetUserRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed), forKey: request)
        
        request.startAsynchronous()
    }
    
    func requestFinished(request: ASIHTTPRequest!) {
        let delegateObj = delegateDic.removeValueForKey(request)
        if let delegate = delegateObj as? LoginRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? LogoutRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetApplicationsRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetApplicationRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetCurrentApplicationRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? NewApplicationRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? UpdateApplicationRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? CancelApplicationRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetApprovalRecordsRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetMessagesRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? DeleteMessageRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? SetUserMessageReadRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetDoctorsRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetDoctorRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetDoctorByNameRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetUserAvailableSamplesRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetSampleByNameRequestDelegate{
            delegate.requestFinished(request)
        }else if let delegate = delegateObj as? GetUserRequestDelegate{
            delegate.requestFinished(request)
        }

    }
    
    func requestFailed(request: ASIHTTPRequest!) {
        let delegateObj = delegateDic.removeValueForKey(request)
        if let delegate = delegateObj as? LoginRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? LogoutRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetApplicationsRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetApplicationRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetCurrentApplicationRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? NewApplicationRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? UpdateApplicationRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? CancelApplicationRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetApprovalRecordsRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetMessagesRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? DeleteMessageRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? SetUserMessageReadRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetDoctorsRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetDoctorRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetDoctorByNameRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetUserAvailableSamplesRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetSampleByNameRequestDelegate{
            delegate.requestFailed(request)
        }else if let delegate = delegateObj as? GetUserRequestDelegate{
            delegate.requestFailed(request)
        }
    }
    
}

extension SnailServerRequestDelegate{
    func requestFinished(request: ASIHTTPRequest!){
        
        finished(Int(request.responseStatusCode), responseData: request.responseData())
    }
    
    func requestFailed(request: ASIHTTPRequest!){
        failed(request.error)
    }
}