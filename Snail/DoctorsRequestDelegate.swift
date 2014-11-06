//
//  DoctorsRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetDoctorsRequestDelegate = _DoctorsRequestDelegate<Array<Doctor>>
typealias GetDoctorByNameRequestDelegate = _DoctorsRequestDelegate<Doctor>

class _DoctorsRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleDoctorsResponse)
    }
    
    func handleDoctorsResponse(jsonObj: JSON) -> Any? {
        var result = Array<Doctor>()
        
        if let doctorArray = jsonObj.arrayValue {
            
            for doctorJson in doctorArray{
                var doctorID: String
                var doctorName: String
                var address: String?
                var additionalInfoDict: [String: String]
                
                if let doctorIDStr = doctorJson["doctorID"].stringValue{
                    doctorID = doctorIDStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let doctorNameStr = doctorJson["doctorName"].stringValue{
                    doctorName = doctorNameStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                address = doctorJson["address"].stringValue
                
                additionalInfoDict = Dictionary<String,String>()
                if let aiArray = doctorJson["additionalInfo"].arrayValue{
                    for aiItem in aiArray {
                        if let key = aiItem["name"].stringValue{
                            if let value = aiItem["value"].stringValue{
                                additionalInfoDict.updateValue(value, forKey: key)
                            }
                        }
                    }
                }
                let doctor = Doctor(doctorID: doctorID, doctorName: doctorName, address: address, additionalInfoDict: additionalInfoDict)
                result.append(doctor)
            }
            return result;
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
    }
}