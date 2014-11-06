//
//  Order.swift
//  
//
//  Created by Solution on 14/10/2.
//
//

import Foundation

class InternalOrder: Printable{
    let internalOrderNo: String!
    let deliveryAddress: String?
    let costCenter: String?
    let applyPurpose: String?
    
    var description: String{
        let dAddress = deliveryAddress == nil ? "N/A" : deliveryAddress
        let cCenter = costCenter == nil ? "N/A" : costCenter
        let purpose = applyPurpose == nil ? "N/A" : applyPurpose
        return "Internal Order No: \(internalOrderNo), Delivery Address:\(dAddress), Cost Center:\(cCenter), Apply Purpose:\(purpose)"
    }
    
    init(internalOrderNo: String, deliveryAddress: String?, costCenter: String?, applyPurpose: String?){
        self.internalOrderNo = internalOrderNo
        self.deliveryAddress = deliveryAddress
        self.costCenter = costCenter
        self.applyPurpose = applyPurpose
    }
}

