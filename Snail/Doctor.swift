//
//  Doctor.swift
//  Snail
//
//  Created by Solution on 14/10/30.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class Doctor{
    var doctorID: String
    var doctorName: String
    var address: String?
    var additionalInfoDict: [String: String]

    init(doctorID: String, doctorName: String, address: String?, additionalInfoDict:[String: String]){
        self.doctorID = doctorID
        self.doctorName = doctorName
        self.address = address
        self.additionalInfoDict = additionalInfoDict
    }
    
    class func getDoctors() -> [Doctor]? {
        var result = Array<Doctor>()
        var aInfo1 = Dictionary<String, String>()
        aInfo1["Available Apply Medicine Quantity"] = "10"
        aInfo1["Applied Sample Before"] = "Yes"
        aInfo1["Doctor Level"] = "1"
        
        var aInfo2 = Dictionary<String, String>()
        aInfo2["Available Apply Medicine Quantity"] = "5"
        aInfo2["Applied Sample Before"] = "No"
        aInfo2["Doctor Level"] = "2"
        
        
        var aInfo3 = Dictionary<String, String>()
        aInfo3["Available Apply Medicine Quantity"] = "9999"
        aInfo3["Applied Sample Before"] = "Yes"
        aInfo3["Doctor Level"] = "1"
        
        result.append(Doctor(doctorID: "DOC1", doctorName: "John Washton", address: "No 1 Hosptial, Beijin", additionalInfoDict: aInfo1))
        result.append(Doctor(doctorID: "DOC2", doctorName: "Denis Liu", address: "No 2 Hosptial, Beijin", additionalInfoDict: aInfo2))
        result.append(Doctor(doctorID: "DOC3", doctorName: "Chandler Li", address: "Tianjin Jiawan Masion 28th floor", additionalInfoDict: aInfo3))
        
        return result
    }
    
    class func getDoctor(doctorID: String) -> Doctor?{
        if let doctors = Doctor.getDoctors() {
            for doctor in doctors{
                if doctor.doctorID == doctorID{
                    return doctor
                }
            }
        }
        return nil
    }
    
    class func getDoctorByName(doctorName: String) -> Doctor?{
        if let doctors = Doctor.getDoctors() {
            for doctor in doctors{
                if doctor.doctorName == doctorName{
                    return doctor
                }
            }
        }
        return nil
    }

}