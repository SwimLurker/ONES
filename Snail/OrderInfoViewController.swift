//
//  OrderInfoViewController.swift
//  ONES
//
//  Created by Solution on 14/10/9.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

protocol OrderInfoCreatorDelegate{
    func orderInfoCreated(orderInfo: InternalOrder)
}

class OrderInfoViewController: UIViewController{
    
    @IBOutlet weak var orderNoTF: UITextField!
    @IBOutlet weak var deliveryAddressTF: UITextField!
    @IBOutlet weak var costCenterTF: UITextField!
    @IBOutlet weak var applyPurposeTV: UITextView!
    @IBOutlet weak var preBtn: UIGNavigationButton!
    @IBOutlet weak var finishBtn: UIGNavigationButton!
    
    var creatorDelegate: OrderInfoCreatorDelegate!
    
    var initOrderInfo: InternalOrder?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preBtn.titleLabel?.font = CustomizedFont.font_btn
        preBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        preBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        preBtn.buttonTintColor = CustomizedColor.blue
        preBtn.leftArrow = true
        preBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        preBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        
        finishBtn.titleLabel?.font = CustomizedFont.font_btn
        finishBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        finishBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        finishBtn.buttonTintColor = CustomizedColor.blue
        finishBtn.leftArrow = false
        finishBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        finishBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        
        if let order = initOrderInfo {
            orderNoTF.text = order.internalOrderNo
            if let deliveryAddress = order.deliveryAddress {
                deliveryAddressTF.text = deliveryAddress
            }
            if let costCenter = order.costCenter {
                costCenterTF.text = costCenter
            }
            
            if let applyPurpose = order.applyPurpose {
                applyPurposeTV.text = applyPurpose
            }
        }
    }
    
    func initWithOrderInfo(orderInfo: InternalOrder?){
        initOrderInfo = orderInfo
    }
    
    @IBAction func preBtnClicked(sender: AnyObject) {
        preStep()
    }
    
    @IBAction func finishBtnClicked(sender: AnyObject) {
        nextStep()
    }
    
    func preStep(){
        stepsController.showPreviousStep()
    }
    
    func nextStep(){
        let orderNo = orderNoTF.text
        if orderNo != nil && !orderNo.isEmpty{
            if let delegate = creatorDelegate{
                delegate.orderInfoCreated(InternalOrder(internalOrderNo: orderNo, deliveryAddress: deliveryAddressTF.text, costCenter: costCenterTF.text, applyPurpose: applyPurposeTV.text))
                stepsController.showNextStep()
            }
        }else{
            let alertView = UIAlertView(title: "Order Info Invalidate", message: "Please input valid interal order no", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    @IBAction func handleSwipeLeft(sender: AnyObject) {
        nextStep()
    }
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        preStep()
    }
    
}