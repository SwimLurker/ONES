//
//  ApprovalRecordsRequestDelegate.swift
//  Snail
//
//  Created by Solution on 14/10/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

typealias GetApprovalRecordsRequestDelegate = _ApprovalRecordsRequestDelegate<Array<ApprovalRecord>>

class _ApprovalRecordsRequestDelegate<T>: SnailServerRequestDelegate<T> {
    
    init(succeedCallback: ((T?) ->())?, failedCallback: ((Error)->())?){
        super.init(succeedCallback: succeedCallback, failedCallback: failedCallback, responseHandler: handleApprovalRecordsResponse)
    }
    
    func handleApprovalRecordsResponse(jsonObj: JSON) -> Any? {
        var result = Array<ApprovalRecord>()
        
        if let arArray = jsonObj.arrayValue {
            
            for arJson in arArray{
                var approver: String
                var approvalStatus: ApplicationStatus
                var approvalDate: NSDate?
                var comment: String?
                
                if let approverStr = arJson["approver"].stringValue{
                    approver = approverStr
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                if let statusNumber = arJson["approvalStatus"].integerValue{
                    if let s = ApplicationStatus.fromRaw(statusNumber){
                        approvalStatus = s
                    }else{
                        return Error(errorCode: -203, errorMsg: "Invalid Approval Status")
                    }
                }else{
                    return Error(errorCode: -201, errorMsg: "Invalid Result")
                }
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                if let approvalDateStr = arJson["approvalDate"].stringValue{
                    if let aDate = formatter.dateFromString(approvalDateStr) {
                        approvalDate = aDate
                    }
                }
                
                comment = arJson["comment"].stringValue
                
                
                var ar = ApprovalRecord(approver: approver, approvalStatus: approvalStatus, approvalDate: approvalDate)
                ar.comment = comment
                result.append(ar)
            }
            return result;
        }else{
            return Error(errorCode: -201, errorMsg: "Invalid Result")
        }
    }
}