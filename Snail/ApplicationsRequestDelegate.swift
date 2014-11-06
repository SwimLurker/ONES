//
//  ApplicationsRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetApplicationsRequestDelegate = _ApplicationsRequestDelegate<Array<Application>>

typealias GetCurrentApplicationRequestDelegate = _ApplicationsRequestDelegate<Application>

class _ApplicationsRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleApplicationsResponse)
    }
    
    func handleApplicationsResponse(jsonObj: JSON) -> Any? {
        var result = Array<Application>()
        
        if let appArray = jsonObj.arrayValue {
            
            for appJson in appArray{
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
                
                
                if let appIDStr = appJson["appID"].stringValue{
                    appID = appIDStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let sampleIDStr = appJson["applySample"]["sample"]["sampleID"].stringValue {
                    sampleID = sampleIDStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let sampleNameStr = appJson["applySample"]["sample"]["sampleName"].stringValue {
                    sampleName = sampleNameStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let sampleTypeNumber = appJson["applySample"]["sample"]["sampleType"].integerValue {
                    if let sType = SampleType.fromRaw(sampleTypeNumber){
                        sampleType = sType
                    }else{
                        return Error(errorCode: -202, errorMsg: "Invalid Sample Type")
                    }
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let samplePictureNameStr = appJson["applySample"]["sample"]["samplePictureName"].stringValue {
                    samplePictureName = samplePictureNameStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let quantityValue = appJson["applySample"]["quantity"].integerValue{
                    quantity = quantityValue
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                doctorName = appJson["doctorName"].stringValue
                
                sampleUsageAddress = appJson["sampleUsageAddress"].stringValue
                
                if let applierStr = appJson["applier"].stringValue{
                    applier = applierStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                if let applyDateStr = appJson["applyDate"].stringValue{
                    if let aDate = formatter.dateFromString(applyDateStr) {
                        applyDate = aDate
                    }else{
                        return Error(errorCode: -203, errorMsg: "Invalid Date Format")
                    }
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let lastModifyDateStr = appJson["lastModifyDate"].stringValue{
                    lastModifyDate = formatter.dateFromString(lastModifyDateStr)
                }
                
                if let statusNumber = appJson["status"].integerValue{
                    if let s = ApplicationStatus.fromRaw(statusNumber){
                        status = s
                    }else{
                        return Error(errorCode: -203, errorMsg: "Invalid Application Status")
                    }
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let internalOrderNoStr = appJson["internalOrder"]["internalOrderNo"].stringValue {
                    internalOrderNo = internalOrderNoStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                deliveryAddress = appJson["internalOrder"]["deliveryAddress"].stringValue
                costCenter = appJson["internalOrder"]["costCenter"].stringValue
                applyPurpose = appJson["internalOrder"]["applyPurpose"].stringValue
                
                
                
                var app = Application(appID: appID, applySample: ApplySample(sample: Sample(sampleID: sampleID, sampleName: sampleName, sampleType: sampleType, samplePictureName: samplePictureName), quantity: quantity), doctorName: doctorName, sampleUsageAddress: sampleUsageAddress, applier: applier, applyDate: applyDate, status: status)
                
                
                app.lastModifyDate = lastModifyDate
                app.internalOrder = InternalOrder(internalOrderNo: internalOrderNo, deliveryAddress: deliveryAddress, costCenter: costCenter, applyPurpose: applyPurpose)
                
                
                result.append(app)
            }
            return result;
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
    }
}