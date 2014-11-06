//
//  DoctorRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/31.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetDoctorRequestDelegate = _DoctorRequestDelegate<Doctor>

class _DoctorRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleDoctorResponse)
    }
    
    func handleDoctorResponse(jsonObj: JSON) -> Any? {
        var doctorID: String
        var doctorName: String
        var address: String?
        var additionalInfoDict: [String: String]
       
        if let doctorIDStr = jsonObj["doctorID"].stringValue{
            doctorID = doctorIDStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        if let doctorNameStr = jsonObj["doctorName"].stringValue{
            doctorName = doctorNameStr
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
        
        address = jsonObj["address"].stringValue
                
        additionalInfoDict = Dictionary<String,String>()
        if let aiArray = jsonObj["additionalInfo"].arrayValue{
            for aiItem in aiArray {
                if let key = aiItem["name"].stringValue{
                    if let value = aiItem["value"].stringValue{
                        additionalInfoDict.updateValue(value, forKey: key)
                    }
                }
            }
        }
        return Doctor(doctorID: doctorID, doctorName: doctorName, address: address, additionalInfoDict: additionalInfoDict)
    }
}