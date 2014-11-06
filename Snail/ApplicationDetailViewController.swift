//
//  ApplicationDetailViewController.swift
//  ONES
//
//  Created by Solution on 14/10/2.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit


class ApplicationDetailViewController: UITableViewController, RETableViewManagerDelegate, UIAlertViewDelegate{
    
    var manager: RETableViewManager?
    
    var enableEdit: Bool!
    
    var currentApplication: Application!
    
    var userInfoDelegate: UserInfoUpdateDelegate?
    
    var origin: CGRect!
    
    var doctorNameOptionsController: RETableViewOptionsController?
    var sampleNameOptionsController: RETableViewOptionsController?
    
    var idItem: RETextItem?
    var applyDateItem: RETextItem?
    var lastModifyDateItem: RETextItem?
    var doctorNameItem: RERadioItem?
    var sampleUsageAddressItem: RETextItem?
    var sampleItem: RERadioItem?
    var sampleQuantityItem: RENumberItem?
    var validateDateItem: REDateTimeItem?
    var isDifferentBatchItem: REBoolItem?
    var isDifferentManufactureItem: REBoolItem?
    var internalOrderNoItem: RETextItem?
    var deliveryAddressItem: RETextItem?
    var costCenterItem: RETextItem?
    var applyPurposeItem: RETextItem?
    
    var waitingBar: MBProgressHUD?
    
    var doctors: [Doctor]?
    var availableSamples: [Sample]?
    var approvalRecords: [ApprovalRecord]?
    
    var selectedSample: Sample?
    var confirmAlertView: UIAlertView?
    
    var newDoctorInfo: (String?, String?)?
    var newSampleInfo: ApplySample?
    var newOrderInfo: InternalOrder?
    
    var originalDoctorName: String?
    var originalSampleName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if enableEdit != nil && enableEdit! {
            self.title = "Application Detail (Modify)"
        }else{
            self.title = "Application Detail"
        }
        
        createNavigationButtons()
        
        confirmAlertView = UIAlertView(title: "Confirm Modification", message: "Do you want to modify the application?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        
        if let session = Session.currentSession {
            if let app = currentApplication {
                waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                waitingBar?.removeFromSuperViewOnHide = true
                
                if let applier = currentApplication?.applier{
                    SnailServer.server.getDoctorsByUser(
                        session.sessionID,
                        userID: applier,
                        onSucceed: { doctors in
                            self.doctors = doctors
                            SnailServer.server.getUserAvailableSamples(
                                session.sessionID,
                                userID: applier,
                                onSucceed: { samples in
                                    self.availableSamples = samples
                                    SnailServer.server.getApplicationApprovalHistory(
                                        session.sessionID,
                                        applicationID: self.currentApplication.appID,
                                        onSucceed: { records in
                                            self.approvalRecords = records
                                            self.waitingBar?.hide(true)
                                            self.createTable()
                                        },
                                        onFailed: {error in
                                            self.waitingBar?.hide(true)
                                            self.showErrorMsg(error)
                                        })
                                
                                },
                                onFailed: {error in
                                    self.waitingBar?.hide(true)
                                    self.showErrorMsg(error)
                                })
                        },
                        onFailed: {error in
                            self.waitingBar?.hide(true)
                            self.showErrorMsg(error)
                        })
                }
                
            }
        }else{
            showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
        
        
    }
    
    func createNavigationButtons(){
        if let ediable = enableEdit {
            if ediable {
                let confirmBtn = UIButton()
                confirmBtn.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
                confirmBtn.setImage(UIImage(named: "confirmbtn.png"), forState: UIControlState.Normal)
                confirmBtn.addTarget(self, action: "confirmBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                
                let confirmBarItem = UIBarButtonItem(customView: confirmBtn);
                let btns = [confirmBarItem]

                self.navigationItem.rightBarButtonItems = btns
            }
        }
    }
    
    func createTable(){
        weak var weakSelf = self
        
        manager = RETableViewManager(tableView: tableView, delegate: self)
        
        origin = tableView.frame
        
        let section = RETableViewSection(headerTitle: "Application Info")
        
        idItem = RETextItem(title: "Application ID:", value: currentApplication.appID)
        idItem!.enabled = false
        
        section.addItem(idItem)
        
        //section.addItem(RETableViewItem(title: "Application ID: " + currentApplication.appID))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        applyDateItem = RETextItem(title: "Apply Date:", value: dateFormatter.stringFromDate(currentApplication.applyDate))
        applyDateItem?.enabled = false
        
        section.addItem(applyDateItem)
        
        lastModifyDateItem = RETextItem(title: "Last Modify Date:", value: dateFormatter.stringFromDate(currentApplication.lastModifyDate))
        lastModifyDateItem?.enabled = false
        section.addItem(lastModifyDateItem)
        
        let completeHandler = { (item : RETableViewItem!) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            item.reloadRowWithAnimation(UITableViewRowAnimation.None)

        }
        
        var doctorOptions = Array<String>()
        if let doctors = self.doctors {
            for doctor in doctors {
                doctorOptions.append(doctor.doctorName)
            }
        }

        originalDoctorName = currentApplication.doctorName
        
        doctorNameItem = RERadioItem(title: "Apply for Doctor:", value: currentApplication.doctorName, selectionHandler: {(item : RERadioItem!) -> Void in
            item.deselectRowAnimated(true)
            self.doctorNameOptionsController = RETableViewOptionsController(item: item,
                options: doctorOptions,
                multipleChoice: false,
                completionHandler: completeHandler)
            
            self.doctorNameOptionsController!.delegate = weakSelf
            
            self.navigationController?.pushViewController(self.doctorNameOptionsController!, animated: true)
        })
        
        if !enableEdit {
            doctorNameItem?.enabled = false
        }
        section.addItem(doctorNameItem)
        
        sampleUsageAddressItem = RETextItem(title: "Sample Usage Address:", value: currentApplication.sampleUsageAddress)
        if !enableEdit {
            sampleUsageAddressItem?.enabled = false
        }
        
        section.addItem(sampleUsageAddressItem)
        
        var sampleOptions = Array<String>()
        if let samples = self.availableSamples {
            for sample in samples {
                sampleOptions.append(sample.sampleName)
            }
        }
        
        originalSampleName = currentApplication.applySample.sample.sampleName
        
        sampleItem = RERadioItem(title: "Applied Sample:", value: currentApplication.applySample.sample.sampleName, selectionHandler: {(item : RERadioItem!) -> Void in
            item.deselectRowAnimated(true)
            self.sampleNameOptionsController = RETableViewOptionsController(item: item,
                options: sampleOptions,
                multipleChoice: false,
                completionHandler: completeHandler)
            
            self.sampleNameOptionsController!.delegate = weakSelf
            
            self.navigationController?.pushViewController(self.sampleNameOptionsController!, animated: true)
        })
        if !enableEdit {
            sampleItem?.enabled = false
        }
        section.addItem(sampleItem)
        
        
        sampleQuantityItem = RENumberItem(title: "Quantity:", value: "\(currentApplication.applySample.quantity)")
        if !enableEdit {
            sampleQuantityItem?.enabled = false
        }
        section.addItem(sampleQuantityItem)
        
        section.addItem(RETableViewItem(title: "Special Requirment"))
        
        if let vDate = currentApplication.applySample.validateDate {
            validateDateItem = REDateTimeItem(title: "    Validate Date:", value: vDate, placeholder: "", format: "yyyy-MM", datePickerMode: UIDatePickerMode.Date)
        }else{
            validateDateItem = REDateTimeItem(title: "    Validate Date:", value: nil, placeholder: "", format: "yyyy-MM", datePickerMode: UIDatePickerMode.Date)
        }
        if !enableEdit {
            validateDateItem?.enabled = false
        }
        section.addItem(validateDateItem)
        
        
        if let isDPB = currentApplication.applySample.isDifferentProductionBatch {
            isDifferentBatchItem = REBoolItem(title: "    Different Production Batch:", value: isDPB)
        }else{
            isDifferentBatchItem = REBoolItem(title: "    Different Production Batch:")
        }
        
        if !enableEdit {
            isDifferentBatchItem?.enabled = false
        }
        section.addItem(isDifferentBatchItem)
        
        if let isDM = currentApplication.applySample.isDifferentManufacture {
            isDifferentManufactureItem = REBoolItem(title: "    Different Manufacture:", value: isDM)
        }else{
            isDifferentManufactureItem = REBoolItem(title: "    Different Manufacture:")
        }
        
        if !enableEdit {
            isDifferentManufactureItem?.enabled = false
        }
        section.addItem(isDifferentManufactureItem)
        
        if let order = currentApplication.internalOrder {
            internalOrderNoItem = RETextItem(title: "Internal Order No:", value: order.internalOrderNo)
            if !enableEdit {
                internalOrderNoItem?.enabled = false
            }
            section.addItem(internalOrderNoItem)
            
            deliveryAddressItem = RETextItem(title: "Delivery Address:", value: order.deliveryAddress)
            if !enableEdit {
                deliveryAddressItem?.enabled = false
            }
            section.addItem(deliveryAddressItem)
            
            
            costCenterItem = RETextItem(title: "Cost Center:", value: order.costCenter)
            if !enableEdit {
                costCenterItem?.enabled = false
            }
            section.addItem(costCenterItem)
            
            applyPurposeItem = RETextItem(title: "Apply Purpose:", value: order.applyPurpose)
            if !enableEdit {
                applyPurposeItem?.enabled = false
            }
            section.addItem(applyPurposeItem)
            
            
        }
        manager!.addSection(section)
        
        let aprrovalHistorySection = RETableViewSection(headerTitle: "Approval History")
        
        if let records = approvalRecords {
            for record in records{
                var itemText = "\(record.approvalStatus) by \(record.approver)"
                if let date = record.approvalDate {
                    itemText += " at \(dateFormatter.stringFromDate(date))"
                }
                let item = RETableViewItem(title: itemText)
                item.detailLabelText = record.comment == nil ? "N/A" : record.comment
            
                aprrovalHistorySection.addItem(item)
            }
        }
        manager!.addSection(aprrovalHistorySection)
        
        tableView.reloadData()
        
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tv = doctorNameOptionsController?.tableView {
            if tv == tableView {
                currentApplication.doctorName = tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text
                doctorNameItem?.reloadRowWithAnimation(UITableViewRowAnimation.None)
            }
        }
        
        if let tv = sampleNameOptionsController?.tableView {
            if tv == tableView {
                if let sampleName = tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text {
                    if let samples = availableSamples {
                        for sample in samples{
                            if sample.sampleName == sampleName{
                                currentApplication.applySample.sample = sample
                            }
                        }
                    }
                }
                sampleItem?.reloadRowWithAnimation(UITableViewRowAnimation.None)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myView = UIView()
        myView.backgroundColor = CustomizedColor.blue
        
        let titleLable = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 40))
        titleLable.backgroundColor = UIColor.clearColor()
        titleLable.textColor = UIColor.whiteColor()
        
        if tableView == self.tableView {
            if section == 0 {
                titleLable.text = "Application Detail"
            }else {
                titleLable.text = "Approval History"
            }
        }
        myView.addSubview(titleLable)
        return myView
    }
    
    func confirmBtnClicked(sender: UIButton){
        var doctorInfoModified = false;
        
        var newDoctorName: String?
        if let str = doctorNameItem?.value {
            if str != originalDoctorName{
                doctorInfoModified = true
                newDoctorName = str
             }
        }
        
        var newUsageAddress: String?
        if let str = sampleUsageAddressItem?.value{
            if str != currentApplication.sampleUsageAddress{
                doctorInfoModified = true
                newUsageAddress = str
            }
        }
        
        if doctorInfoModified{
            newDoctorInfo = (newDoctorName, newUsageAddress)
        }else{
            newDoctorInfo = nil
        }
        
        var sampleInfoModified = false
        
        var newSample: Sample?
        if let str = sampleItem?.value{
            if str != originalSampleName{
                sampleInfoModified = true
                newSample = currentApplication.applySample.sample
            }
        }
        
        var newSampleQuantity: Int?
        
        if let str = sampleQuantityItem?.value{
            if str != "\(currentApplication.applySample.quantity)" {
                sampleInfoModified = true
                newSampleQuantity = str.toInt()
            }
        }
        
        var newValidateDate: NSDate?
        
        if let date = validateDateItem?.value{
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM"
            if let nDate = currentApplication.applySample.validateDate{
                if formatter.stringFromDate(date) != formatter.stringFromDate(nDate){
                    sampleInfoModified = true
                    newValidateDate = date
                }
            }
        }
        
        var newIsDPB: Bool?
        if let b = isDifferentBatchItem?.value{
            if let oldValue = currentApplication.applySample.isDifferentProductionBatch{
                if b != currentApplication.applySample.isDifferentProductionBatch{
                    sampleInfoModified = true
                    newIsDPB = b
                }
            }else{
                if b{
                    sampleInfoModified = true
                    newIsDPB = b
                }
            }
            
        }
        
        var newIsDM: Bool?
        if let b = isDifferentManufactureItem?.value{
            if let oldValue = currentApplication.applySample.isDifferentManufacture{
                if b != currentApplication.applySample.isDifferentManufacture{
                    sampleInfoModified = true
                    newIsDM = b
                }
            }else{
                if b{
                    sampleInfoModified = true
                    newIsDM = b
                }
            }
        }
        
        if sampleInfoModified{
            newSampleInfo = currentApplication.applySample
            newSampleInfo?.sample = newSample
            newSampleInfo?.quantity = newSampleQuantity
            newSampleInfo?.validateDate = newValidateDate
            newSampleInfo?.isDifferentProductionBatch = newIsDPB
            newSampleInfo?.isDifferentManufacture = newIsDM
        }else{
            newSampleInfo = nil
        }
        
        var orderInfoModified = false
        
        var newOrderNo: String?
        if let str = internalOrderNoItem?.value{
            if str != currentApplication.internalOrder.internalOrderNo{
                orderInfoModified = true
                newOrderNo = str
            }
        }
        
        var newDeliveryAddress: String?
        if let str = deliveryAddressItem?.value{
            if str != currentApplication.internalOrder.deliveryAddress{
                orderInfoModified = true
                newDeliveryAddress = str
            }
        }
        
        var newCostCenter: String?
        if let str = costCenterItem?.value{
            if str != currentApplication.internalOrder.costCenter{
                orderInfoModified = true
                newCostCenter = str
            }
        }
        
        var newApplyPurpose: String?
        if let str = applyPurposeItem?.value{
            if str != currentApplication.internalOrder.applyPurpose{
                orderInfoModified = true
                newApplyPurpose = str
            }
        }
        
        if orderInfoModified{
            newOrderInfo = InternalOrder(internalOrderNo: newOrderNo!, deliveryAddress: newDeliveryAddress, costCenter: newCostCenter, applyPurpose: newApplyPurpose)
        }
        
        if doctorInfoModified || sampleInfoModified || orderInfoModified {
            confirmAlertView!.show()
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == confirmAlertView{
            if buttonIndex == 1{
                if let session = Session.currentSession {
                    waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    waitingBar?.removeFromSuperViewOnHide = true
                    SnailServer.server.updateApplication(
                        session.sessionID,
                        applicationID: currentApplication.appID,
                        doctorInfo: newDoctorInfo,
                        sampleInfo: newSampleInfo,
                        orderInfo: newOrderInfo,
                        onSucceed: { application in
                            self.waitingBar?.hide(true)
                            if let delegate = self.userInfoDelegate {
                                delegate.userInfoUpdate()
                            }
                            self.navigationController?.popViewControllerAnimated(true)
                        },
                        onFailed: { error in
                            self.waitingBar?.hide(true)
                            self.showErrorMsg(error)
                        })
                }else{
                    showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
                }
            }
        }
    }

}