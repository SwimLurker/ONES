//
//  SampleInfoViewController.swift
//  ONES
//
//  Created by Solution on 14/10/7.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

protocol SampleInfoCreatorDelegate{
    func sampleInfoCreated(sampleInfo: ApplySample)
}

class SampleInfoViewController : UIViewController, SampleInfoSelectionDelegate{
    @IBOutlet weak var sampleNameTF: UITextField!
    @IBOutlet weak var sampleQuantityTF: UITextField!
    @IBOutlet weak var validityDateTF: UITextField!
    @IBOutlet weak var productionSwitch: UISwitch!
    @IBOutlet weak var manufactureSwitch: UISwitch!
    @IBOutlet weak var preBtn: UIGNavigationButton!
    @IBOutlet weak var nextBtn: UIGNavigationButton!
    @IBOutlet weak var searchSampleBtn: UIButton!
    

    @IBOutlet var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var rightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    
    var sampleListVC: SampleListViewController!
    
    var creatorDelegate: SampleInfoCreatorDelegate!
    
    var initSampleInfo: ApplySample?
    
    var waitingBar: MBProgressHUD?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        weak var weakRef = self
        
        sampleListVC = storyboard?.instantiateViewControllerWithIdentifier("SampleList") as SampleListViewController
        
        sampleListVC!.selectionDelegate = weakRef
        
        sampleQuantityTF.text = "1"
    
        preBtn.titleLabel?.font = CustomizedFont.font_btn
        preBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        preBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        preBtn.buttonTintColor = CustomizedColor.blue
        preBtn.leftArrow = true
        preBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        preBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        
        nextBtn.titleLabel?.font = CustomizedFont.font_btn
        nextBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextBtn.buttonTintColor = CustomizedColor.blue
        nextBtn.leftArrow = false
        nextBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        nextBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        
        if let sample = initSampleInfo {
            sampleNameTF.text = sample.sample.sampleName
            sampleQuantityTF.text = "\(sample.quantity)"
            if let date = sample.validateDate {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM"
                validityDateTF.text = formatter.stringFromDate(date)
            }
            if let isDPB = sample.isDifferentProductionBatch {
                productionSwitch.on = isDPB
            }
            if let isDM = sample.isDifferentManufacture {
                manufactureSwitch.on = isDM
            }
        }
    }
    
    func initWithSampleInfo(sampleInfo: ApplySample?){
        initSampleInfo = sampleInfo
    }
    
    @IBAction func nextBtnClicked(sender: AnyObject) {
        nextStep()
    }
    
    @IBAction func preBtnClicked(sender: AnyObject) {
        preStep()
    }
    
    func preStep(){
        stepsController.showPreviousStep()
    }
    
    func nextStep(){
        if let session = Session.currentSession {
            if let sampleName = sampleNameTF.text {
                waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                waitingBar?.removeFromSuperViewOnHide = true
                SnailServer.server.getSampleByName(
                session.sessionID,
                sampleName:sampleName,
                onSucceed: {sample in
                    self.waitingBar?.hide(true)
                    
                    if sample == nil {
                        self.showErrorMsg(Error(errorCode: -3, errorMsg: "Sample Not Found"))
                    }else{
                    
                        if let sampleQuantityStr = self.sampleQuantityTF.text{
                            if let quantity = sampleQuantityStr.toInt(){
                                var applySample = ApplySample(sample: sample!, quantity: quantity)
                            
                                if let vDateStr = self.validityDateTF.text {
                                    let formatter = NSDateFormatter()
                                    formatter.dateFormat = "yyyy-MM"
                                    applySample.validateDate = formatter.dateFromString(vDateStr)
                                }
                            
                                if let isDPB = self.productionSwitch?.on {
                                    applySample.isDifferentProductionBatch = isDPB
                                }
                            
                                if let isDM = self.manufactureSwitch?.on {
                                    applySample.isDifferentManufacture = isDM
                                }
                            
                                if let delegate = self.creatorDelegate {
                                    delegate.sampleInfoCreated(applySample)
                                    self.stepsController.showNextStep()
                                }
                            
                            }else{
                                let alertView = UIAlertView(title: "Sample Info Invalidate", message: "Please input valid sample quantity", delegate: self, cancelButtonTitle: "OK")
                                alertView.show()
                            }
                        }else{
                            let alertView = UIAlertView(title: "Sample Info Invalidate", message: "Please input sample quantity", delegate: self, cancelButtonTitle: "OK")
                            alertView.show()
                        }
                    
                    }
                },
                onFailed: {error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
                })
            }else{
                let alertView = UIAlertView(title: "Sample Info Invalidate", message: "Please input valid sample name", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
        }else{
            showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
        
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    @IBAction func searchSampleBtnClicked(sender: AnyObject) {
        sampleListVC!.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(sampleListVC, animated: true, completion: nil)
        
    }

    
    func selecteSampleInfo(sample: Sample) {
        
        sampleListVC.dismissViewControllerAnimated(true, completion: nil)
        sampleNameTF.text = sample.sampleName
    }
    
    @IBAction func handleSwipeLeft(sender: AnyObject) {
        nextStep()
    }
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        preStep()
    }
}