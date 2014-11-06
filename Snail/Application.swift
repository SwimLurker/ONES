//
//  Application.swift
//  ONES
//
//  Created by Solution on 14/9/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

enum ApplicationStatus: Int, Printable{
    case WaitingForApproval = 1, Approved, Rejected, Deliveried, Signed
    
    var description: String{
        return ["Waiting For Approval",
            "Approved",
            "Rejected",
            "Deliveried",
            "Signed"][toRaw() - 1]
    }
}


class ApprovalRecord: Printable{
    let approvalDate: NSDate?
    let approvalStatus: ApplicationStatus
    let approver: String
    var comment: String?
    
    
    var description: String{
        if let aDate = approvalDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return "\(approvalStatus), \(approver), \(formatter.stringFromDate(aDate))"
        }else{
            return "\(approvalStatus), \(approver)"
        }
    }
    
    init(approver: String, approvalStatus: ApplicationStatus, approvalDate: NSDate?){
        self.approver = approver
        self.approvalStatus = approvalStatus
        self.approvalDate = approvalDate
    }
    
}

var applicationIDCounter: Int = 1

class Application: Printable, Hashable {
    let appID: String
    var applySample: ApplySample
    var doctorName: String?
    var sampleUsageAddress: String?
    let applier: String
    let applyDate: NSDate
    var lastModifyDate: NSDate!
    var status: ApplicationStatus
    
    var internalOrder: InternalOrder!
   
    class var newAppID: String {
        return "APP-2014100100\(applicationIDCounter++)"
    }
    
    var shortDesc: String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        formatter.dateFormat = "yyyy-MM-dd"
        return "\(appID): \(applySample.sample.sampleName), Doctor: \(doctorName!), \(formatter.stringFromDate(applyDate))"
    }
    
    init(appID: String, applySample: ApplySample , doctorName: String?, sampleUsageAddress: String?, applier: String, applyDate: NSDate, status: ApplicationStatus){
        self.appID = appID
        self.applySample = applySample
        self.doctorName = doctorName
        self.sampleUsageAddress = sampleUsageAddress
        self.applier = applier
        self.applyDate = applyDate
        self.status = status
        self.lastModifyDate = NSDate()
    }
    
    
    var description: String{
        return "Application(\(appID)) apply Sample(\(applySample)) for Doctor(\(doctorName!))by Applier(\(applier)) at Date(\(applyDate)), Satus:\(status)"
    }
    
    var hashValue: Int{
        return appID.hashValue
    }
    
    func getApprovalHistory() -> [ApprovalRecord] {
        var result = Array<ApprovalRecord>()
        result.append(ApprovalRecord(approver: "LEIT", approvalStatus: ApplicationStatus.Approved, approvalDate: NSDate()))
        if status  == ApplicationStatus.WaitingForApproval{
            result.append(ApprovalRecord(approver: "JHPI", approvalStatus: ApplicationStatus.WaitingForApproval, approvalDate: nil))
        }else{
            result.append(ApprovalRecord(approver: "JHPI", approvalStatus: status, approvalDate: NSDate()))
        }
        
        return result
    }
}

func ==(lhs: Application, rhs: Application) -> Bool {
    return lhs.appID == rhs.appID
}