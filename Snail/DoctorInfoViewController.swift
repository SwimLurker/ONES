//
//  DoctorInfoViewController.swift
//  ONES
//
//  Created by Solution on 14/10/7.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

protocol DoctorInfoCreatorDelegate{
    func doctorInfoCreated(doctorInfo: (String?, String?))
}

class DoctorInfoViewController : UIViewController, DoctorInfoSelectionDelegate,RETableViewManagerDelegate{
    
    @IBOutlet weak var doctorNameTF: UITextField!
    @IBOutlet weak var searchDoctorBtn: UIButton!
    @IBOutlet weak var doctorAddressTF: UITextField!
    @IBOutlet weak var additionalInfoTV: UITableView!
    @IBOutlet weak var nextBtn: UIGNavigationButton!
    
    var aInfoTVManager: RETableViewManager!
    
    var doctorListVC: DoctorListViewController!
    
    var creatorDelegate: DoctorInfoCreatorDelegate!
    
    var initDoctorInfo: (String?, String?)?
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakRef = self
        
        doctorListVC = storyboard?.instantiateViewControllerWithIdentifier("DoctorList") as DoctorListViewController
        
        doctorListVC!.selectionDelegate = weakRef
        
        aInfoTVManager = RETableViewManager(tableView: additionalInfoTV, delegate: self)
        
        //aInfoTVManager["InfoTableViewItem"] = "InfoTableViewCell"
        //aInfoTVManager.registerClass("InfoTableViewItem", forCellWithReuseIdentifier: "InfoTableViewCell")
        //aInfoTVManager.setObject("InfTableViewCell", forKeyedSubscript: "InfoTableViewItem")
        
        //aInfoTVManager.registerClass("InfoTableViewItem", forCellWithReuseIdentifier: "InfoTableView", bundle: nil)
    
        
        nextBtn.titleLabel?.font = CustomizedFont.font_btn
        nextBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextBtn.buttonTintColor = CustomizedColor.blue
        nextBtn.leftArrow = false
        nextBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        nextBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
                
        if let (doctorName, address) = initDoctorInfo {
            if doctorName != nil{
                if let session = Session.currentSession{
                    waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    waitingBar?.removeFromSuperViewOnHide = true
                    SnailServer.server.getDoctorByName(
                        session.sessionID,
                        doctorName: doctorName!,
                        onSucceed: { doctor in
                            self.waitingBar?.hide(true)
                            if doctor != nil{
                                self.selectDoctorInfo(doctor!)
                            }
                        
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
    
    func initWithDoctorInfo(doctorInfo: (String?, String?)?){
        initDoctorInfo = doctorInfo
    }
    
    @IBAction func nextBtnClicked(sender: AnyObject) {
        //validate input info
        nextStep()
    }
    
    func nextStep() {
        let doctorName = doctorNameTF.text
        if doctorName != nil && !doctorName.isEmpty {
            
            let doctorAddress = doctorAddressTF.text
            if doctorAddress != nil && !doctorAddress.isEmpty{
                if let delegate = creatorDelegate {
                    creatorDelegate.doctorInfoCreated((doctorName,doctorAddress))
                    stepsController.showNextStep()
                }
            }else{
                let alertView = UIAlertView(title: "Doctor Info Invalidate", message: "Please input doctor address", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
        }else{
            let alertView = UIAlertView(title: "Doctor Info Invalidate", message: "Please select doctor name", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }

    }
    
    @IBAction func searchDoctorBtnClicked(sender: AnyObject) {
        doctorListVC!.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(doctorListVC, animated: true, completion: nil)
        
    }
    
    func selectDoctorInfo(doctorInfo: Doctor) {
        doctorListVC.dismissViewControllerAnimated(true, completion: nil)
        
        doctorNameTF.text = doctorInfo.doctorName
        doctorAddressTF.text = doctorInfo.address
        
        aInfoTVManager.removeAllSections()
        
        let section = RETableViewSection()
        
        for (key, value) in doctorInfo.additionalInfoDict {
            let item = RETextItem(title: key, value: value)
            item.enabled = false
            section.addItem(item)
        }
        
        
        aInfoTVManager.addSection(section)
        
        aInfoTVManager.tableView.reloadData()
    }
    

    @IBAction func handleSwipeLeft(sender: AnyObject) {
        nextStep()
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
}


