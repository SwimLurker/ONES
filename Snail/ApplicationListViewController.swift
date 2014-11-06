//
//  ApplicationListViewController.swift
//  ONES
//
//  Created by Solution on 14/9/29.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import UIKit

enum SortRule: Int, Printable{
    case ByDate = 1, ByDoctorName, ByStatus
    
    var description:String {
        return ["Sort By Date", "Sort By Doctor Name", "Sort By Status"][toRaw() - 1]
    }
}

class ApplicationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UserInfoUpdateDelegate, ApplicationSearchDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var sortSegmentControl: HMSegmentedControl!
    
    var applications: [Application]?
    
    var dataSourceType: String?
    
    var sortRule: SortRule?
    
    var selectedIndexPath: NSIndexPath?
    
    var selectedApplication: Application?
    
    var cancelAlertView: UIAlertView?
    var copyAlertView: UIAlertView?
    
    var userInfoDelegate: UserInfoUpdateDelegate?
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationButtons()
        
        if let type = dataSourceType {
            if type == "CurrentYear" {
                self.title = "Application List(2014)"
            }else if type == "Total" {
                self.title = "Application List(Total)"
            }
        }
        
        createSegmentControl()
        
        sortRule = SortRule.ByDate
        sortApplication()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.blackColor().CGColor
        tableView.tableHeaderView = sortSegmentControl
        
        /*
        self.manager = RETableViewManager(tableView: tableView, delegate: self)
        
        let section = RETableViewSection()
        manager!.addSection(section)
        
        for application in applications!{
            section.addItem(RETextItem(title: application.appID))
            section.addItem(RETextItem(title: application.sampleName))
            
            section.addItem(RERadioItem(title: "\(application.status)"))
        }
        */
        
        
        
        
        
    }
    
    func createNavigationButtons(){
        
        //create back button
        let backBtn = UIButton()
        backBtn.bounds = CGRect(x: 0, y: 0, width: 80, height: 48)
        backBtn.setTitle("< Home", forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backToHomeBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let backBarItem = UIBarButtonItem(customView: backBtn);
        self.navigationItem.leftBarButtonItems = [backBarItem]
        
        
        let refreshBtn = UIButton()
        refreshBtn.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
        refreshBtn.setImage(UIImage(named: "refreshbtn.png"), forState: UIControlState.Normal)
        refreshBtn.addTarget(self, action: "refreshBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let refreshBarItem = UIBarButtonItem(customView: refreshBtn);
        
        
        let searchBtn = UIButton()
        searchBtn.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
        searchBtn.setImage(UIImage(named: "searchbtn.png"), forState: UIControlState.Normal)
        
        searchBtn.addTarget(self, action: "searchBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let searchBarItem = UIBarButtonItem(customView: searchBtn);
        
        self.navigationItem.rightBarButtonItems = [searchBarItem, refreshBarItem]
        
    }

    func createSegmentControl(){
        
        
        sortSegmentControl = HMSegmentedControl(sectionTitles: ["Sort by Date", "Sort by Doctor", "Sort by Status"])
        sortSegmentControl.bounds = CGRectMake(0, 0, 200, 70)
        //sortSegmentControl.setBorder(UIColor.darkGrayColor(), width: 2)
        sortSegmentControl.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        sortSegmentControl.selectedSegmentIndex = 0
        sortSegmentControl.font = CustomizedFont.font_btn
        sortSegmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox
        sortSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        sortSegmentControl.backgroundColor = CustomizedColor.blue
        sortSegmentControl.selectionIndicatorColor = CustomizedColor.light_blue
        sortSegmentControl.selectedTextColor = UIColor.whiteColor()
        sortSegmentControl.selectionIndicatorHeight = 8.0
        
        
        sortSegmentControl.addTarget(self, action: "sortRuleChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if applications != nil {
            return applications!.count
        }else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(selectedIndexPath == indexPath){
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("ApplicationListItemDetailCell") as UITableViewCell?
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ApplicationListItemDetailCell")
            }
            
            let app = applications![indexPath.row]
                
            let shortDescLabel = cell!.viewWithTag(21001) as UILabel
            shortDescLabel.text = app.shortDesc
                
            let statusLabel = cell!.viewWithTag(21002) as UILabel
            statusLabel.text = "Status:\(app.status)"
                
            let detailLabel = cell!.viewWithTag(21003) as UILabel
            var detailText = ""
                
            let order = app.internalOrder
                
            detailText += "    Interanl Order ID: \(order.internalOrderNo)"
            if let deliverAddress = order.deliveryAddress {
                detailText += "\r\n    Delivery Address: \(deliverAddress)"
            }else{
                detailText += "\r\n    Delivery Address: N/A"
            }
                
            if let costCenter = order.costCenter {
                detailText += "\r\n    Cost Center: \(costCenter)"
            }else{
                detailText += "\r\n    Cost Center: N/A"
            }
                
            if let purpose = order.applyPurpose {
                detailText += "\r\n    Apply Purpose: \(purpose)"
            }else{
                detailText += "\r\n    Apply Purpose: N/A"
            }
                
            detailText += "\r\n    Approval History:"
            for approvalRecord in app.getApprovalHistory() {
                detailText += "\r\n        \(approvalRecord)"
            }
                
            detailLabel.text = detailText
            detailLabel.backgroundColor = CustomizedColor.light_blue
            detailLabel.textColor = UIColor.whiteColor()
                
            let modifyBtn = cell!.viewWithTag(21004) as TableViewCellButton
            let copyBtn = cell!.viewWithTag(21005) as TableViewCellButton
            let cancelBtn = cell!.viewWithTag(21006) as TableViewCellButton
            let signBtn = cell!.viewWithTag(21007) as TableViewCellButton
            
            setTableButtonStyle(modifyBtn, cellID: app.appID, actionSelector: "modifyApplicationBtnClicked:")
            setTableButtonStyle(copyBtn, cellID: app.appID, actionSelector: "copyApplicationBtnClicked:")
            setTableButtonStyle(cancelBtn, cellID: app.appID, actionSelector: "cancelApplicationBtnClicked:")
            setTableButtonStyle(signBtn, cellID: app.appID, actionSelector: "signApplicationBtnClicked:")

          
            switch(app.status){
            case ApplicationStatus.Approved, ApplicationStatus.Rejected, ApplicationStatus.Signed:
                    modifyBtn.setTitle("Detail", forState: UIControlState.Normal)
                    //modifyBtn.setTitle("Detail", forState: UIControlState.Selected)
                    modifyBtn.enabled = true
                    cancelBtn.enabled = false
                    signBtn.enabled = false
            case ApplicationStatus.Deliveried:
                    modifyBtn.setTitle("Detail", forState: UIControlState.Normal)
                    //modifyBtn.setTitle("Detail", forState: UIControlState.Selected)
                    modifyBtn.titleLabel?.text = "Detail"
                    modifyBtn.enabled = true
                    cancelBtn.enabled = false
                    signBtn.enabled = true
            case ApplicationStatus.WaitingForApproval:
                    modifyBtn.setTitle("Modify", forState: UIControlState.Normal)
                    //modifyBtn.setTitle("Modify", forState: UIControlState.Selected)
                    modifyBtn.enabled = true
                    cancelBtn.enabled = true
                    signBtn.enabled = false
            }
            return cell!
        }else{
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("ApplicationListItemCell") as UITableViewCell?
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ApplicationListItemCell")
            }
            let shortDescLabel = cell!.viewWithTag(20001) as UILabel
            shortDescLabel.text = applications?[indexPath.row].shortDesc
            
            let statusLabel = cell!.viewWithTag(20002) as UILabel
            statusLabel.text = "Status:\(applications![indexPath.row].status)"
            
            return cell!
        }
        //cell?.textLabel?.text = applications?[indexPath.row].shortDesc
        
    }
    
    func setTableButtonStyle(btn: TableViewCellButton, cellID: String, actionSelector: Selector){
        btn.cellID = cellID
        btn.useBlackLabel(true)
        btn.setTitleColor(CustomizedColor.dark_blue, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)
        btn.backgroundColor = CustomizedColor.light_blue
        btn.buttonTintColor = UIColor.whiteColor()
        btn.titleLabel?.font = CustomizedFont.font_smallbtn
        btn.innerBorderWidth = 0.0
        btn.buttonBorderWidth = 0.0
        btn.buttonCornerRadius = 4.0
        btn.setShadow(UIColor.whiteColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 2.0)
        btn.strokeType = kUIGlossyButtonStrokeTypeInnerBevelDown
        btn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        btn.addTarget(self, action: actionSelector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        if(selectedIndexPath == nil){
            selectedIndexPath = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }else{
            let hasSelectedOtherRow = !(selectedIndexPath == indexPath)
            let tempIndex = selectedIndexPath
            selectedIndexPath = nil
            
            tableView.reloadRowsAtIndexPaths([tempIndex!], withRowAnimation: UITableViewRowAnimation.Automatic)
            if(hasSelectedOtherRow){
                selectedIndexPath = indexPath
                tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
        tableView.endUpdates()
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath == selectedIndexPath){
            return 250
        }else{
            return 80
        }
    }
    
    func sortRuleChanged(sender: UISegmentedControl){
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            sortRule = SortRule.ByDate
        case 1:
            sortRule = SortRule.ByDoctorName
        case 2:
            sortRule = SortRule.ByStatus
        default:
            sortRule = nil
        }
        sortApplication()
        selectedApplication = nil
        selectedIndexPath = nil
        tableView.reloadData()
    }
    func sortApplication(){
        if let rule = sortRule {
            switch rule {
            case SortRule.ByDate:
                applications = applications?.sorted({app1, app2 in app1.applyDate.timeIntervalSinceDate(app2.applyDate) > 0.0})
            case SortRule.ByDoctorName:
                applications = applications?.sorted({app1, app2 in app1.doctorName < app2.doctorName})
            case SortRule.ByStatus:
                applications = applications?.sorted({app1, app2 in app1.status.toRaw() < app2.status.toRaw()})
            }
        }
    }
    
    func modifyApplicationBtnClicked(sender: TableViewCellButton){
        
        for app in applications!{
            if app.appID == sender.cellID{
                selectedApplication = app
                break
            }
        }
        
        performSegueWithIdentifier("ApplicationDetail", sender: self)
    }
    
    func copyApplicationBtnClicked(sender: TableViewCellButton){
        for app in applications!{
            if app.appID == sender.cellID{
                selectedApplication = app
                break
            }
        }
        copyAlertView = UIAlertView(title: "Copy Application", message: "Do you want to use selected application info to create new application?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        copyAlertView!.show()
    }
    
    func cancelApplicationBtnClicked(sender: TableViewCellButton){
        for app in applications!{
            if app.appID == sender.cellID{
                selectedApplication = app
                break
            }
        }
        cancelAlertView = UIAlertView(title: "Cancel Application", message: "Do you want to cancel current selected application?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        cancelAlertView!.show()
    }
    
    func signApplicationBtnClicked(sender: TableViewCellButton){
        let alertView = UIAlertView(title: "TableViewCell Sign Button Clicked", message: "Application ID: \(sender.cellID)", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func searchBtnClicked(sender: UIButton){
        performSegueWithIdentifier("Search", sender: self)
    }
    
    func refreshBtnClicked(sender: UIButton){
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            if dataSourceType == "CurrentYear" {
                SnailServer.server.getApplicationsByYear(
                    session.sessionID,
                    year: 2014,
                    onSucceed: { apps in
                        self.waitingBar?.hide(true)
                        self.applications = apps
                        self.sortApplication()
                        self.selectedApplication = nil
                        self.selectedIndexPath = nil
                        self.tableView.reloadData()
                    },
                    onFailed: { error in
                        self.waitingBar?.hide(true)
                        self.showErrorMsg(error)
                })
            }else if dataSourceType == "Total" {
                SnailServer.server.getApplications(
                    session.sessionID,
                    onSucceed: { apps in
                        self.waitingBar?.hide(true)
                        self.applications = apps
                        self.sortApplication()
                        self.selectedApplication = nil
                        self.selectedIndexPath = nil
                        self.tableView.reloadData()
                    },
                    onFailed: { error in
                        self.waitingBar?.hide(true)
                        self.showErrorMsg(error)
                })
            }

        }
    }
    
    
    func backToHomeBtnClicked(sender: UIButton){
        if let delegate = userInfoDelegate {
            delegate.userInfoUpdate()
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ApplicationDetail" {
            let detailController = segue.destinationViewController as ApplicationDetailViewController
            detailController.currentApplication = selectedApplication
            if selectedApplication?.status == ApplicationStatus.WaitingForApproval{
                detailController.enableEdit = true
                detailController.userInfoDelegate = self
            }else{
                detailController.enableEdit = false
            }
        }else if segue.identifier == "CopyToNewApplication" {
            
            let newAppController = segue.destinationViewController as NewApplicationViewController
            if let app = selectedApplication {
                newAppController.doctorInfo = (app.doctorName, app.sampleUsageAddress)
                newAppController.sampleInfo = app.applySample
                newAppController.orderInfo = app.internalOrder
            }
            
            newAppController.userInfoDelegate = self.userInfoDelegate

            
            //navigationController?.pushViewController(newAppController, animated: true)
        }else if segue.identifier == "Search"{
            let searchAppVC = segue.destinationViewController as SearchApplicationViewController
            searchAppVC.delegate = self
        }
    }
        
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == cancelAlertView{
            if buttonIndex == 1{
                if let session = Session.currentSession {
                    if let app = selectedApplication {
                        waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        waitingBar?.removeFromSuperViewOnHide = true
                    
                        SnailServer.server.cancelApplication(
                            session.sessionID,
                            applicationID: app.appID,
                            onSucceed: {apps in
                                self.waitingBar?.hide(true)
                                self.userInfoUpdate()
                            },
                            onFailed: {error in
                                self.waitingBar?.hide(true)
                                self.showErrorMsg(error)
                            })
                    }
                }else{
                    showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
                }
            }
        }else if alertView == copyAlertView{
            if buttonIndex == 1{
                performSegueWithIdentifier("CopyToNewApplication", sender: self)
            }
        }
    }
    
    func userInfoUpdate() {
        if let session = Session.currentSession {
            if dataSourceType == "CurrentYear" {
                waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                waitingBar?.removeFromSuperViewOnHide = true
                
                SnailServer.server.getApplicationsByYear(
                    session.sessionID,
                    year: 2014,
                    onSucceed: { apps in
                        self.waitingBar?.hide(true)
                        self.updateTableData(apps)
                    },
                    onFailed: { error in
                        self.showErrorMsg(error)
                    })
            }else if dataSourceType == "Total" {
                waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                waitingBar?.removeFromSuperViewOnHide = true
                
                SnailServer.server.getApplications(
                    session.sessionID,
                    onSucceed: { apps in
                        self.waitingBar?.hide(true)
                        self.updateTableData(apps)
                    },
                    onFailed: { error in
                        self.showErrorMsg(error)
                })
            }
        }
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func search(appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?) {
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            SnailServer.server.getApplications(
                session.sessionID,
                appID: appID,
                doctorName: doctorName,
                fromDate: fromDate,
                toDate: toDate,
                onSucceed: { apps in
                    self.waitingBar?.hide(true)
                    self.updateTableData(apps)
                },
                onFailed: { error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
                })
            presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func cancelSearch() {
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateTableData(apps: [Application]?){
        applications = apps
        sortApplication()
        selectedApplication = nil
        selectedIndexPath = nil
        tableView.reloadData()
    }
    
}
