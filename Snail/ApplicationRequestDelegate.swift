//
//  ApplicationRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetApplicationRequestDelegate = _ApplicationRequestDelegate<Application>

typealias NewApplicationRequestDelegate = _ApplicationRequestDelegate<Application>

typealias UpdateApplicationRequestDelegate = _ApplicationRequestDelegate<Application>

class _ApplicationRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleApplicationResponse)
    }
    
    init(succeedCallback: ((T) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleApplicationResponse)
    }
    
    init(succeedCallback: (()->())?, failedCallback: ((Error)->())?){
        super.init(noArgsSucceedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleApplicationResponse)
    }
    
    func handleApplicationResponse(jsonObj: JSON) -> Any? {
        
        if jsonObj == JSON.Null(nil){
            return nil
        }
        
        var appID: String
        var sampleID: String
        var sampleName: String
        var sampleType: SampleType
        var samplePictureName: String
        var quantity: Int
        var doctorName: String?
        var sampleUsageAddress: String?
        var applier: String
        var applyDate: NSDate
        var lastModifyDate: NSDate?
        var status: ApplicationStatus
        var internalOrderNo: String
        var deliveryAddress: String?
        var costCenter: String?
        var applyPurpose: String?
        
        
        if let appIDStr = jsonObj["appID"].stringValue{
            appID = appIDStr
        }else{
            return nil
        }
        
        if let sampleIDStr = jsonObj["applySample"]["sample"]["sampleID"].stringValue {
            sampleID = sampleIDStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let sampleNameStr = jsonObj["applySample"]["sample"]["sampleName"].stringValue {
            sampleName = sampleNameStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let sampleTypeNumber = jsonObj["applySample"]["sample"]["sampleType"].integerValue {
            if let sType = SampleType.fromRaw(sampleTypeNumber){
                sampleType = sType
            }else{
                return Error(errorCode: -202, errorMsg: "Invalid Sample Type")
            }
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let samplePictureNameStr = jsonObj["applySample"]["sample"]["samplePictureName"].stringValue {
            samplePictureName = samplePictureNameStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let quantityValue = jsonObj["applySample"]["quantity"].integerValue{
            quantity = quantityValue
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        doctorName = jsonObj["doctorName"].stringValue
        
        sampleUsageAddress = jsonObj["sampleUsageAddress"].stringValue
        
        if let applierStr = jsonObj["applier"].stringValue{
            applier = applierStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let applyDateStr = jsonObj["applyDate"].stringValue{
            if let aDate = formatter.dateFromString(applyDateStr) {
                applyDate = aDate
            }else{
                return Error(errorCode: -203, errorMsg: "Invalid Date Format")
            }
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let lastModifyDateStr = jsonObj["lastModifyDate"].stringValue{
            lastModifyDate = formatter.dateFromString(lastModifyDateStr)
        }
        
        if let statusNumber = jsonObj["status"].integerValue{
            if let s = ApplicationStatus.fromRaw(statusNumber){
                status = s
            }else{
                return Error(errorCode: -203, errorMsg: "Invalid Application Status")
            }
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let internalOrderNoStr = jsonObj["internalOrder"]["internalOrderNo"].stringValue {
            internalOrderNo = internalOrderNoStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        deliveryAddress = jsonObj["internalOrder"]["deliveryAddress"].stringValue
        costCenter = jsonObj["internalOrder"]["costCenter"].stringValue
        applyPurpose = jsonObj["internalOrder"]["applyPurpose"].stringValue
        
        
        
        var app = Application(appID: appID, applySample: ApplySample(sample: Sample(sampleID: sampleID, sampleName: sampleName, sampleType: sampleType, samplePictureName: samplePictureName), quantity: quantity), doctorName: doctorName, sampleUsageAddress: sampleUsageAddress, applier: applier, applyDate: applyDate, status: status)
        
        
        app.lastModifyDate = lastModifyDate
        app.internalOrder = InternalOrder(internalOrderNo: internalOrderNo, deliveryAddress: deliveryAddress, costCenter: costCenter, applyPurpose: applyPurpose)
        
        return app
    }
}