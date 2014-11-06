//
//  SamplesRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetUserAvailableSamplesRequestDelegate = _SamplesRequestDelegate<Array<Sample>>
typealias GetSampleByNameRequestDelegate = _SamplesRequestDelegate<Sample>

class _SamplesRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleSamplesResponse)
    }
    
    func handleSamplesResponse(jsonObj: JSON) -> Any? {
        var result = Array<Sample>()
        
        if let sampleArray = jsonObj.arrayValue {
            
            for sampleJson in sampleArray{
                var sampleID: String
                var sampleName: String
                var sampleType: SampleType
                var samplePictureName: String
                
                if let sampleIDStr = sampleJson["sampleID"].stringValue{
                    sampleID = sampleIDStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let sampleNameStr = sampleJson["sampleName"].stringValue{
                    sampleName = sampleNameStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let typeNumber = sampleJson["sampleType"].integerValue{
                    if let s = SampleType.fromRaw(typeNumber){
                        sampleType = s
                    }else{
                        return Error(errorCode: -203, errorMsg: "Invalid Sample Type")
                    }
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                
                if let samplePictureNameStr = sampleJson["samplePictureName"].stringValue{
                    samplePictureName = samplePictureNameStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                
                var sample = Sample(sampleID: sampleID, sampleName: sampleName, sampleType: sampleType, samplePictureName: samplePictureName)
                result.append(sample)
            }
            return result;
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
    }
}