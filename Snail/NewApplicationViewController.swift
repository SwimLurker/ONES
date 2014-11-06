//
//  NewApplicationViewController.swift
//  ONES
//
//  Created by Solution on 14/10/7.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import UIKit


class NewApplicationViewController : RMStepsController, DoctorInfoCreatorDelegate, SampleInfoCreatorDelegate, OrderInfoCreatorDelegate, UIAlertViewDelegate{
    
    var segmentedBtns: HMSegmentedControl!
    let blue1 = UIColor(red: 41.0/255.0, green: 181.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    let blue2 = UIColor(red: 5.0/255.0, green: 130.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    let blue3 = UIColor(red: 0.0/255.0, green: 120.0/255.0, blue: 183.0/255.0, alpha: 1.0)
    
    
    var doctorInfo: (String?, String?)?
    var sampleInfo: ApplySample?
    var orderInfo: InternalOrder?
    
    var cancelAlertView: UIAlertView?
    var finishAlertView: UIAlertView?
    
    var userInfoDelegate: UserInfoUpdateDelegate?
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create back button
        let backBtn = UIButton()
        backBtn.bounds = CGRect(x: 0, y: 0, width: 80, height: 48)
        backBtn.setTitle("< Back", forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "cancelApplySample:", forControlEvents: UIControlEvents.TouchUpInside)
    
        let backBarItem = UIBarButtonItem(customView: backBtn);
        let btns = [backBarItem]
        self.navigationItem.leftBarButtonItems = btns

        //setup step control
        segmentedBtns = HMSegmentedControl(sectionTitles: ["Select Doctor Info", "Input Applied Sample Info", "Input Order Info"])
        segmentedBtns.frame = CGRect(x: 0, y: 60, width: 768, height: 80)
        
        segmentedBtns.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedBtns.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedBtns.selectedTextColor = blue1
        segmentedBtns.backgroundColor = UIColor.lightGrayColor()
        segmentedBtns.layer.borderWidth = 1
        segmentedBtns.layer.borderColor = UIColor.blackColor().CGColor
        segmentedBtns.selectedSegmentIndex = 0
        segmentedBtns.addTarget(self, action: "segmentBtnClicked:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedBtns.indexChangeBlock = {(index: Int) -> Void in
            
        }
        
        //view.addSubview(segmentedBtns)
        
        
        self.stepsBar.hideCancelButton = true
        //self.stepsBar.delegate = self
        
        cancelAlertView = UIAlertView(title: "Cancel Apply", message: "Do you want to cancel apply application", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
        finishAlertView = UIAlertView(title: "Finish Apply", message: "Do you want to apply this application", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
    }
        
    func segmentBtnClicked(sender: HMSegmentedControl){
        sender.selectedTextColor = blue3
        
    }
    
    override func stepViewControllers() -> [AnyObject]! {
        weak var weakRef = self
        
        let firstStep: DoctorInfoViewController = storyboard?.instantiateViewControllerWithIdentifier("DoctorInfo") as DoctorInfoViewController
        firstStep.step.title = "Select Doctor Info"
        firstStep.step.selectedBarColor = blue2
        firstStep.step.selectedTextColor = UIColor.whiteColor()
        firstStep.creatorDelegate = weakRef
        
        
        firstStep.initWithDoctorInfo(doctorInfo)
        
        
        let secondStep: SampleInfoViewController = storyboard?.instantiateViewControllerWithIdentifier("SampleInfo") as SampleInfoViewController
        secondStep.step.title = "Input Applied Sample Info"
        secondStep.step.selectedBarColor = blue2
        secondStep.step.selectedTextColor = UIColor.whiteColor()
        secondStep.creatorDelegate = weakRef
        
        secondStep.initWithSampleInfo(sampleInfo)
        
        
        let thirdStep: OrderInfoViewController = storyboard?.instantiateViewControllerWithIdentifier("OrderInfo") as OrderInfoViewController
        thirdStep.step.title = "Input Order Info"
        thirdStep.step.selectedBarColor = blue2
        thirdStep.step.selectedTextColor = UIColor.whiteColor()
        thirdStep.creatorDelegate = weakRef
        
        thirdStep.initWithOrderInfo(orderInfo)
        
        
        return [firstStep, secondStep, thirdStep]
    }
    
    override func finishedAllSteps() {
        finishAlertView!.show()
    }
    
    override func canceled() {
        cancelAlertView!.show()
    }
    
    func cancelApplySample(sender: AnyObject?){
        canceled()
    }
    
    func doctorInfoCreated(doctorInfo: (String?, String?)) {
        self.doctorInfo = doctorInfo
    }
    
    func sampleInfoCreated(sampleInfo: ApplySample) {
        self.sampleInfo = sampleInfo
    }
    
    func orderInfoCreated(orderInfo: InternalOrder) {
        self.orderInfo = orderInfo
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == cancelAlertView{
            if buttonIndex == 1{
                navigationController?.popViewControllerAnimated(true)
                //navigationController?.popToRootViewControllerAnimated(true)
            }
        }else if alertView == finishAlertView{
            if buttonIndex == 1{
                if let session = Session.currentSession {
                    waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    waitingBar?.removeFromSuperViewOnHide = true
                    
                    SnailServer.server.applyApplication(
                        session.sessionID,
                        doctorInfo: self.doctorInfo!,
                        sampleInfo: self.sampleInfo!,
                        orderInfo: self.orderInfo!,
                        onSucceed: { newApplication in
                            self.waitingBar?.hide(true)
                            if let delegate = self.userInfoDelegate {
                                delegate.userInfoUpdate()
                            }
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }, onFailed: {error in
                            self.waitingBar?.hide(true)
                            self.showErrorMsg(error)
                        })
                    
                }else{
                    showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
                }
            }
        }
    }
    
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func backToHomeBtnClicked(sender: AnyObject?){
        canceled()
    }
    
    /*
    func stepsBar(bar: RMStepsBar!, shouldSelectStepAtIndex index: Int) {
        bar.setIndexOfSelectedStep(UInt(index), animated: true)
        let alertView = UIAlertView(title: "Current Application Cancel Button Clicked", message: "Quiit System", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    
    func stepsBarDidSelectCancelButton(bar: RMStepsBar!) {
        
    }
*/
}
