//
//  AFHTTPSnailServer.swift
//  Snail
//
//  Created by Solution on 14/10/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class AFHTTPSnailServer: SnailServerProtocol{
    
    
    func login(username: String, password: String, onSucceed: (Session?) -> (), onFailed: (Error) -> ()) {
        
        var requestDelegate = LoginRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        manager.POST(
            Settings.loginURL,
            parameters: ["username":username, "password": password],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
        
    }
    
    func logout(sessionID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        var requestDelegate = LogoutRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        manager.DELETE(
            Settings.logoutURL,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getApplicationsByYear(sessionID: String, year: Int, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        var requestDelegate = GetApplicationsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(Settings.applicationsURL,
            parameters: ["sessionID": sessionID, "year": "\(year)"],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getApplications(sessionID: String, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        var requestDelegate = GetApplicationsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(Settings.applicationsURL,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getApplications(sessionID: String, appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?, onSucceed: ([Application]?) -> (), onFailed: (Error) -> ()) {
        var requestDelegate = GetApplicationsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var parameters = ["sessionID": sessionID]
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM"
        
        if appID != nil{
            parameters.updateValue(appID!, forKey: "appID")
        }else{
            parameters.updateValue("", forKey: "appID")
        }
        
        if doctorName != nil {
            parameters.updateValue(doctorName!, forKey: "doctorName")
        }else{
            parameters.updateValue("", forKey: "doctorName")
        }
        
        if fromDate != nil {
            parameters.updateValue(formatter.stringFromDate(fromDate!), forKey: "from")
        }else{
            parameters.updateValue("", forKey: "from")
        }
        if toDate != nil {
            parameters.updateValue(formatter.stringFromDate(toDate!), forKey: "to")
        }else{
            parameters.updateValue("", forKey: "to")
        }
        
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(Settings.applicationsURL,
            parameters: parameters,
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getUserCurrentApplication(sessionID: String, username: String, onSucceed: (Application?) -> (), onFailed: (Error) -> ()) {
        
        var url = Settings.userApplicationsURL.stringByReplacingOccurrencesOfString("{userid}", withString: username, options: nil, range: nil)
        
        var requestDelegate = GetCurrentApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID, "type": "current"],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func applyApplication(sessionID: String, doctorInfo: (String?, String?), sampleInfo: ApplySample, orderInfo: InternalOrder, onSucceed: (Application) -> (), onFailed: (Error) -> ()) {
        
        var requestDelegate = NewApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        var parameters = Dictionary<String, String>();
        parameters["sessionID"] = sessionID
        let (doctorName, sampleUsageAddress) = doctorInfo
        parameters["doctorName"] = doctorName
        parameters["sampleUsageAddress"] = sampleUsageAddress
        
        parameters["applySampleID"] = sampleInfo.sample.sampleID
        parameters["applySampleQuantity"] = "\(sampleInfo.quantity)"
        if let vDate = sampleInfo.validateDate{
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            parameters["applySampleValidateDate"] = formatter.stringFromDate(vDate)
        }
        
        if let isDPB = sampleInfo.isDifferentProductionBatch{
            parameters["applySampleIsDifferentProductionBatch"] = "\(isDPB)"
        }
        
        if let isDM = sampleInfo.isDifferentManufacture{
            parameters["applySampleIsDifferentManuafacture"] = "\(isDM)"
        }
        
        parameters["internalOrderNo"] = orderInfo.internalOrderNo
        
        if let deliveryAddress = orderInfo.deliveryAddress{
            parameters["deliveryAddress"] = deliveryAddress
        }
        
        if let costCenter = orderInfo.costCenter{
            parameters["costCenter"] = costCenter
        }
        
        if let applyPurpose = orderInfo.applyPurpose{
            parameters["applyPurpose"] = applyPurpose
        }
        
        manager.POST(
            Settings.applicationsURL,
            parameters: parameters,
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )

    }
    
    func updateApplication(sessionID: String, applicationID: String, doctorInfo: (String?, String?)?, sampleInfo: ApplySample?, orderInfo: InternalOrder?, onSucceed: (Application) -> (), onFailed: (Error) -> ()) {
        var url = Settings.applicationURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID,options: nil, range: nil)
        
        var requestDelegate = UpdateApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        var parameters = Dictionary<String, String>();
        
        parameters["sessionID"] = sessionID
        
        if let (doctorName, sampleUsageAddress) = doctorInfo{
            if let dName = doctorName{
                parameters["doctorName"] = dName
            }
            if let address = sampleUsageAddress{
                parameters["sampleUsageAddress"] = address
            }
        }
        
        if let applySample = sampleInfo{
            if let sampleID = applySample.sample?.sampleID{
                parameters["applySampleID"] = sampleID
            }
            if let sampleQuantity = applySample.quantity{
                parameters["applySampleQuantity"] = "\(sampleQuantity)"
            }
            if let vDate = applySample.validateDate{
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                parameters["applySampleValidateDate"] = formatter.stringFromDate(vDate)
            }
            
            if let isDPB = applySample.isDifferentProductionBatch{
                parameters["applySampleIsDifferentProductionBatch"] = "\(isDPB)"
            }
            
            if let isDM = applySample.isDifferentManufacture{
                parameters["applySampleIsDifferentManuafacture"] = "\(isDM)"
            }
        }
        
        if let internalOrder = orderInfo{
            if let orderNo = internalOrder.internalOrderNo{
                parameters["internalOrderNo"] = orderNo
            }
            
            if let deliveryAddress = internalOrder.deliveryAddress{
                parameters["deliveryAddress"] = deliveryAddress
            }
            
            if let costCenter = internalOrder.costCenter{
                parameters["costCenter"] = costCenter
            }
            
            if let applyPurpose = internalOrder.applyPurpose{
                parameters["applyPurpose"] = applyPurpose
            }
        }
            
        manager.PUT(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func cancelApplication(sessionID: String, applicationID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        
        var url = Settings.applicationURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID,options: nil, range: nil)
        
        var requestDelegate = CancelApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        manager.DELETE(
            url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getApplicationApprovalHistory(sessionID: String, applicationID: String, onSucceed: ([ApprovalRecord]?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.applicationApprovalRecordsURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID, options: nil, range: nil)
        
        var requestDelegate = GetApprovalRecordsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getUserMessages(sessionID: String, userID: String, onSucceed: ([Message]?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.userMessagesURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil)
        
        var requestDelegate = GetMessagesRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func deleteUserMessage(sessionID: String, userID: String, messageID: String, onSucceed: () -> (), onFailed: (Error) -> ()) {
        var url = Settings.userMessageURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil).stringByReplacingOccurrencesOfString("{messageid}", withString: messageID, options: nil, range: nil)
        
        var requestDelegate = DeleteMessageRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        manager.DELETE(
            url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func setUserMessageRead(sessionID: String, userID: String, messageID: String, onSucceed: (Message?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.userMessageURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil).stringByReplacingOccurrencesOfString("{messageid}", withString: messageID, options: nil, range: nil)
        
        var requestDelegate = SetUserMessageReadRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        
        manager.PUT(
            url,
            parameters: ["sessionID": sessionID, "isRead": true],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            },
            failure: { (operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getDoctorsByUser(sessionID: String, userID: String, onSucceed: ([Doctor]?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.userDoctorsURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil)
        
        var requestDelegate = GetDoctorsRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getDoctor(sessionID: String, doctorID: String, onSucceed: (Doctor?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.doctorURL.stringByReplacingOccurrencesOfString("{doctorid}", withString: doctorID, options: nil, range: nil)
        
        var requestDelegate = GetDoctorRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getDoctorByName(sessionID: String, doctorName: String, onSucceed: (Doctor?) -> (), onFailed: (Error) -> ()) {
        
        var requestDelegate = GetDoctorByNameRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(Settings.doctorsURL,
            parameters: ["sessionID": sessionID, "doctorName": doctorName],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getUserAvailableSamples(sessionID: String, userID: String, onSucceed: ([Sample]?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.userSamplesURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil)
        
        var requestDelegate = GetUserAvailableSamplesRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getSampleByName(sessionID: String, sampleName: String, onSucceed: (Sample?) -> (), onFailed: (Error) -> ()) {
        var requestDelegate = GetSampleByNameRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(Settings.samplesURL,
            parameters: ["sessionID": sessionID, "sampleName": sampleName],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func getUser(sessionID: String, userID: String, onSucceed: (User?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.userURL.stringByReplacingOccurrencesOfString("{userid}", withString: userID, options: nil, range: nil)
        
        var requestDelegate = GetUserRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
    
    func uploadApplicationSignatureImage(sessionID: String, applicationID: String, image: UIImage, onSucceed: () -> (), onFailed: (Error) -> ()) {
        var url = Settings.signatureImgURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID, options: nil, range: nil).stringByReplacingOccurrencesOfString("{imgid}", withString: applicationID+".png", options: nil, range: nil)
        
        var requestDelegate = SignApplicationRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var imageData = UIImagePNGRepresentation(image)
        
        var serializer = AFHTTPRequestSerializer()
        
        var request = serializer.multipartFormRequestWithMethod(
            "POST",
            URLString: url,
            parameters: ["sessionID": sessionID],
            constructingBodyWithBlock: { formData in
                formData.appendPartWithFileData(imageData, name: "signImg", fileName: applicationID + ".png", mimeType: "image/png")
            },
            error: nil)
        
        
        var manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        var progress: NSProgress?
        
        var uploadTask = manager.uploadTaskWithStreamedRequest(request,
            progress: &progress,
            completionHandler: { (response, responseObj, error) in
                if let err = error{
                    requestDelegate.failed(err)
                }else{
                    if let res = response as? NSHTTPURLResponse{
                        requestDelegate.finished(res.statusCode, responseData: responseObj as NSData)
                    }
                    
                }
            })
        uploadTask.resume()
    }
    
    func getSignatureImage(sessionID: String, applicationID: String, onSucceed: (UIImage?) -> (), onFailed: (Error) -> ()) {
        var url = Settings.signatureImgURL.stringByReplacingOccurrencesOfString("{appid}", withString: applicationID, options: nil, range: nil).stringByReplacingOccurrencesOfString("{imgid}", withString: applicationID + ".png", options: nil, range: nil)
        
        var requestDelegate = SignatureImageRequestDelegate(succeedCallback: onSucceed, failedCallback: onFailed)
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: ["sessionID": sessionID],
            success: { (operation, response) -> Void in
                requestDelegate.requestSuccess(operation, responseObj: response)
            }
            ,failure: {(operation, error) -> Void in
                requestDelegate.requestFailure(operation, error: error)
            }
        )
    }
}

extension SnailServerRequestDelegate{
    func requestSuccess(operation: AFHTTPRequestOperation!, responseObj: AnyObject!) {
        finished(operation.response.statusCode, responseData: operation.responseData)
    }
    
    func requestFailure(operation: AFHTTPRequestOperation!, error: NSError!){
        failed(error)
    }
    
}
