//
//  ApplySample.swift
//  ONES
//
//  Created by Solution on 14/10/6.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

class ApplySample: Printable{
    var sample: Sample!
    var quantity: Int!
    var validateDate: NSDate?
    var isDifferentProductionBatch: Bool?
    var isDifferentManufacture: Bool?
    
    var description: String{
        let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM"
            var dateStr: String
            if let vDate = validateDate {
                dateStr = formatter.stringFromDate(vDate)
            }else {
                dateStr = "N/A"
            }
            
            var str1: String
            if let b1 = isDifferentProductionBatch {
                str1 = "\(b1)"
            }else{
                str1 = "N/A"
            }
            var str2: String
            if let b2 = isDifferentManufacture {
                str2 = "\(b2)"
            }else{
                str2 = "N/A"
            }
            
            return "Sample:\(sample), Quantity:\(quantity), Validate Date: \(dateStr), Different Production Batch:\(str1), Different Manufacture: \(str2)"
    }
    init(sample: Sample, quantity: Int){
        self.sample = sample
        self.quantity = quantity
    }
}
