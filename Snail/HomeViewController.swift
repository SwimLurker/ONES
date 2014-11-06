//
//  HomeViewController.swift
//  ONES
//
//  Created by Solution on 14/9/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import UIKit

protocol UserInfoUpdateDelegate{
    func userInfoUpdate()
}

class HomeViewController: UIViewController, UIAlertViewDelegate, UserInfoUpdateDelegate{
   
    
    @IBOutlet weak var userinfoPanel: UIView!
    
    @IBOutlet weak var quickBar1Panel: UIView!
    
    @IBOutlet weak var quickBar2Panel: UIView!
    
    @IBOutlet weak var quickBar3Panel: UIView!
    
    @IBOutlet weak var mainPanel: UIView!
    
    var userPhotoIV: UIImageView!
    var userNameLB: UILabel!
    var userRoleLB: UILabel!
    
    var quickBar1Btn: LinkButton!
    var quickBar2Btn: LinkButton!
    var quickBar3Btn: LinkButton!
    
    
    var appIDValueLB: UILabel!
    var sampleNameValueLB: UILabel!
    var sampleQuantityValueLB: UILabel!
    var doctorNameValueLB: UILabel!
    var applyDateValueLB: UILabel!
    var statusValueLB: UILabel!
    
    var detailBtn: UIGlossyButton!
    var cancelBtn: UIGlossyButton!
    var signBtn: UIGlossyButton!
    var newApplicationBtn: UIGlossyButton!
    
    
    var logoutAlertView: UIAlertView?
    var cancelApplicationAlertView: UIAlertView?
    
    var waitingBar: MBProgressHUD?
    
    var currentUser: User!
    
    var currentApplication: Application?
    
    var applications: Array<Application>?
    
    var messages: Array<Message>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationButtons()
        
        logoutAlertView = UIAlertView(title: "Logout", message: "Do you want to lougout the application?", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
        
        if let curUser = Session.currentSession?.currentUser{
            currentUser = curUser
            
            createUserInfoPanel()
            
            
            switch curUser.role! {
                case UserRole.SaleRepresentive:
                    createUIForSR()
                    cancelApplicationAlertView = UIAlertView(title: "Cancle Application", message: "Do you want to cancel current application?", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
                
                case UserRole.Manager:
                    createUIForManager()
                case UserRole.Assistant:
                    createUIForAssistant()
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        switch currentUser.role! {
            case UserRole.SaleRepresentive:
                updateUserInfo()
                updateCurrentApplicationInfo()
            case UserRole.Manager:
                //do some job
                println("update manager info")
            case UserRole.Assistant:
                //do some job
                println("update assisate info")
        }

    }
    
    func createNavigationButtons(){
        let settingsBtn = UIButton()
        settingsBtn.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
        settingsBtn.setImage(UIImage(named: "settingsbtn.png"), forState: UIControlState.Normal)
        
        settingsBtn.addTarget(self, action: "settingsBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let settingsBarItem = UIBarButtonItem(customView: settingsBtn);
        
        let logoutBtn = UIButton()
        logoutBtn.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
        logoutBtn.setImage(UIImage(named: "logoutbtn.png"), forState: UIControlState.Normal)
        
        logoutBtn.addTarget(self, action: "logoutBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let logoutBarItem = UIBarButtonItem(customView: logoutBtn);
        
        
        let btns = [logoutBarItem, settingsBarItem]
        
        
        self.navigationItem.rightBarButtonItems = btns
        
    }
    
    func createUserInfoPanel(){
        userPhotoIV = UIImageView(image: UIImage(named: "photo.png"))
        userPhotoIV.frame = CGRect(x: 50.0, y: 15.0, width: 64.0, height: 94.0)
        
        userNameLB = UILabel()
        userNameLB.frame = CGRect(x:150.0, y: 20.0, width: 200.0, height: 40.0)
        userNameLB.font = CustomizedFont.font_title
        
        
        userRoleLB = UILabel()
        userRoleLB.frame = CGRect(x: 150.0, y: 75.0, width: 200.0, height: 40.0)
        userRoleLB.font = CustomizedFont.font_subtitle
        userRoleLB.textColor = UIColor.grayColor()
        
        userinfoPanel.addSubview(userPhotoIV)
        userinfoPanel.addSubview(userNameLB)
        userinfoPanel.addSubview(userRoleLB)
        
        userNameLB.text = currentUser.username
        userRoleLB.text = currentUser.role.description
        if let photoName = currentUser.avatarFilename {
            userPhotoIV.image = UIImage(named: photoName)
        }else{
            userPhotoIV.image = UIImage(named: "avatar_default.png")
        }
    }
    
    func createUIForSR(){
        
        let quickBar1LB = UILabel()
        quickBar1LB.frame = CGRect(x: 10.0, y: 10.0, width: 230.0, height: 30.0)
        quickBar1LB.font = CustomizedFont.font_subtitle
        quickBar1LB.textColor = UIColor.blackColor()
        quickBar1LB.textAlignment = NSTextAlignment.Center
        quickBar1LB.text = "My Application(2014)"
        
        quickBar1Btn = LinkButton()
        quickBar1Btn.frame = CGRect(x: 10.0, y: 40.0, width: 230.0, height: 30.0)
        quickBar1Btn.titleLabel?.font = CustomizedFont.font_title
        quickBar1Btn.titleLabel?.textAlignment = NSTextAlignment.Center
        quickBar1Btn.setTitleColor(CustomizedColor.light_blue, forState: UIControlState.Normal)
        quickBar1Btn.setColor(CustomizedColor.light_blue)
        quickBar1Btn.addTarget(self, action: "myThisYearAppListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let quickBar1Marker = UIView()
        quickBar1Marker.frame = CGRect(x: 0.0, y: 100.0, width: 250.0, height: 15.0)
        quickBar1Marker.backgroundColor = CustomizedColor.light_blue
        
        quickBar1Panel.addSubview(quickBar1LB)
        quickBar1Panel.addSubview(quickBar1Btn)
        quickBar1Panel.addSubview(quickBar1Marker)
        
        
        let quickBar2LB = UILabel()
        quickBar2LB.frame = CGRect(x: 10.0, y: 10.0, width: 230.0, height: 30.0)
        quickBar2LB.font = CustomizedFont.font_subtitle
        quickBar2LB.textColor = UIColor.blackColor()
        quickBar2LB.textAlignment = NSTextAlignment.Center
        quickBar2LB.text = "My Application(Total)"
        
        quickBar2Btn = LinkButton()
        
        quickBar2Btn.frame = CGRect(x: 10.0, y: 40.0, width: 230.0, height: 30.0)
        quickBar2Btn.titleLabel?.font = CustomizedFont.font_title
        quickBar2Btn.titleLabel?.textAlignment = NSTextAlignment.Center
        quickBar2Btn.setTitleColor(CustomizedColor.blue, forState: UIControlState.Normal)
        quickBar2Btn.setColor(CustomizedColor.blue)
        quickBar2Btn.addTarget(self, action: "myTotalAppListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let quickBar2Marker = UIView()
        quickBar2Marker.frame = CGRect(x: 0.0, y: 100.0, width: 250.0, height: 15.0)
        quickBar2Marker.backgroundColor = CustomizedColor.blue
        quickBar2Panel.addSubview(quickBar2LB)
        quickBar2Panel.addSubview(quickBar2Btn)
        quickBar2Panel.addSubview(quickBar2Marker)
        
        let quickBar3LB = UILabel()
        quickBar3LB.frame = CGRect(x: 10.0, y: 10.0, width: 230.0, height: 30.0)
        quickBar3LB.font = CustomizedFont.font_subtitle
        quickBar3LB.textColor = UIColor.blackColor()
        quickBar3LB.textAlignment = NSTextAlignment.Center
        quickBar3LB.text = "Messages"
        
        quickBar3Btn = LinkButton()
        quickBar3Btn.frame = CGRect(x: 10.0, y: 40.0, width: 230.0, height: 30.0)
        quickBar3Btn.titleLabel?.font = CustomizedFont.font_title
        quickBar3Btn.titleLabel?.textAlignment = NSTextAlignment.Center
        quickBar3Btn.setTitleColor(CustomizedColor.dark_blue, forState: UIControlState.Normal)
        quickBar3Btn.setColor(CustomizedColor.dark_blue)
        quickBar3Btn.addTarget(self, action: "myMessageListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let quickBar3Marker = UIView()
        quickBar3Marker.frame = CGRect(x: 0.0, y: 100.0, width: 250.0, height: 15.0)
        quickBar3Marker.backgroundColor = CustomizedColor.dark_blue
        quickBar3Panel.addSubview(quickBar3LB)
        quickBar3Panel.addSubview(quickBar3Btn)
        quickBar3Panel.addSubview(quickBar3Marker)
        
        let mainCaptionLB = UILabel()
        mainCaptionLB.frame = CGRect(x: 266.0, y: 10.0, width: 260, height: 60)
        mainCaptionLB.font = CustomizedFont.font_title
        mainCaptionLB.textAlignment = NSTextAlignment.Center
        mainCaptionLB.text = "Current Application"
        
        let appIDLB = UILabel()
        appIDLB.frame = CGRect(x: 220.0, y: 80.0, width: 140.0, height: 25.0)
        appIDLB.font = CustomizedFont.font_subtitle
        appIDLB.textAlignment = NSTextAlignment.Right
        appIDLB.text = "Application ID:"
        
        appIDValueLB = UILabel()
        appIDValueLB.frame = CGRect(x: 425.0, y: 80.0, width: 200.0, height: 25.0)
        appIDValueLB.font = CustomizedFont.font_subtitle
        appIDValueLB.textAlignment = NSTextAlignment.Left
        appIDValueLB.text = ""
        
        let sampleNameLB = UILabel()
        sampleNameLB.frame = CGRect(x: 220.0, y: 115, width: 140.0, height: 25.0)
        sampleNameLB.font = CustomizedFont.font_subtitle
        sampleNameLB.textAlignment = NSTextAlignment.Right
        sampleNameLB.text = "Apply Sample:"
        
        sampleNameValueLB = UILabel()
        sampleNameValueLB.frame = CGRect(x: 425.0, y: 115.0, width: 200.0, height: 25.0)
        sampleNameValueLB.font = CustomizedFont.font_subtitle
        sampleNameValueLB.textAlignment = NSTextAlignment.Left
        sampleNameValueLB.text = ""
        
        let sampleQuantityLB = UILabel()
        sampleQuantityLB.frame = CGRect(x: 220.0, y: 150.0, width: 140.0, height: 25.0)
        sampleQuantityLB.font = CustomizedFont.font_subtitle
        sampleQuantityLB.textAlignment = NSTextAlignment.Right
        sampleQuantityLB.text = "Quantity:"
        
        sampleQuantityValueLB = UILabel()
        sampleQuantityValueLB.frame = CGRect(x: 425.0, y: 150.0, width: 200.0, height: 25.0)
        sampleQuantityValueLB.font = CustomizedFont.font_subtitle
        sampleQuantityValueLB.textAlignment = NSTextAlignment.Left
        sampleQuantityValueLB.text = ""
        

        let doctorNameLB = UILabel()
        doctorNameLB.frame = CGRect(x: 220.0, y: 185.0, width: 140.0, height: 25.0)
        doctorNameLB.font = CustomizedFont.font_subtitle
        doctorNameLB.textAlignment = NSTextAlignment.Right
        doctorNameLB.text = "Doctor Name:"
        
        doctorNameValueLB = UILabel()
        doctorNameValueLB.frame = CGRect(x: 425.0, y: 185.0, width: 200.0, height: 25.0)
        doctorNameValueLB.font = CustomizedFont.font_subtitle
        doctorNameValueLB.textAlignment = NSTextAlignment.Left
        doctorNameValueLB.text = ""
        

        let applyDateLB = UILabel()
        applyDateLB.frame = CGRect(x: 220.0, y: 220.0, width: 140.0, height: 25.0)
        applyDateLB.font = CustomizedFont.font_subtitle
        applyDateLB.textAlignment = NSTextAlignment.Right
        applyDateLB.text = "Apply Date:"
        
        applyDateValueLB = UILabel()
        applyDateValueLB.frame = CGRect(x: 425.0, y: 220.0, width: 200.0, height: 25.0)
        applyDateValueLB.font = CustomizedFont.font_subtitle
        applyDateValueLB.textAlignment = NSTextAlignment.Left
        applyDateValueLB.text = ""
        
        let statusLB = UILabel()
        statusLB.frame = CGRect(x: 220.0, y: 255.0, width: 140.0, height: 25.0)
        statusLB.font = CustomizedFont.font_subtitle
        statusLB.textAlignment = NSTextAlignment.Right
        statusLB.text = "Status:"
        
        statusValueLB = UILabel()
        statusValueLB.frame = CGRect(x: 425.0, y: 255.0, width: 200.0, height: 25.0)
        statusValueLB.font = CustomizedFont.font_subtitle
        statusValueLB.textAlignment = NSTextAlignment.Left
        statusValueLB.text = ""
        
        
        
        detailBtn = createButton(CGRect(x: 165.0, y: 350.0, width: 140.0, height: 44.0), title:"Detail Info", actionSelector: "currentAppDetailClicked:")
        cancelBtn = createButton(CGRect(x: 340.0, y: 350.0, width: 140.0, height: 44.0), title:"Cancel", actionSelector: "currentAppCancelClicked:")
        signBtn = createButton(CGRect(x: 515.0, y: 350.0, width: 140.0, height: 44.0), title:"Sign", actionSelector: "currentAppSignClicked:")
        
        newApplicationBtn = createButton(CGRect(x: 5, y: 420, width: 758, height: 75), title: "Apply Sample", actionSelector: "applySampleClicked:")

        
        
        mainPanel.addSubview(mainCaptionLB)
        mainPanel.addSubview(appIDLB)
        mainPanel.addSubview(appIDValueLB)
        mainPanel.addSubview(sampleNameLB)
        mainPanel.addSubview(sampleNameValueLB)
        mainPanel.addSubview(sampleQuantityLB)
        mainPanel.addSubview(sampleQuantityValueLB)
        mainPanel.addSubview(doctorNameLB)
        mainPanel.addSubview(doctorNameValueLB)
        mainPanel.addSubview(applyDateLB)
        mainPanel.addSubview(applyDateValueLB)
        mainPanel.addSubview(statusLB)
        mainPanel.addSubview(statusValueLB)
        mainPanel.addSubview(detailBtn)
        mainPanel.addSubview(cancelBtn)
        mainPanel.addSubview(signBtn)
        mainPanel.addSubview(newApplicationBtn)
        
        
    }
    
    func createButton(frame: CGRect, title: String, actionSelector: Selector) -> UIGlossyButton{
        var btn = UIGlossyButton();
        btn.frame = frame
        btn.titleLabel?.font = CustomizedFont.font_btn
        btn.titleLabel?.textAlignment = NSTextAlignment.Center
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.buttonTintColor = CustomizedColor.blue
        btn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        btn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        btn.addTarget(self, action: actionSelector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }
    
    func createUIForManager(){
        let blue1 = UIColor(red: 41.0/255.0, green: 181.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        let blue2 = UIColor(red: 5.0/255.0, green: 130.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        let blue3 = UIColor(red: 0.0/255.0, green: 120.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        
        let quickBar1LB = UILabel()
        quickBar1LB.frame = CGRect(x: 10.0, y: 10.0, width: 230.0, height: 30.0)
        quickBar1LB.font = UIFont(name: "HelveticaNeue", size: 18.0)
        quickBar1LB.textColor = UIColor.blackColor()
        quickBar1LB.textAlignment = NSTextAlignment.Center
        quickBar1LB.text = "My Application(2014)"
        
        quickBar1Btn = LinkButton()
        quickBar1Btn.frame = CGRect(x: 10.0, y: 40.0, width: 230.0, height: 30.0)
        quickBar1Btn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
        quickBar1Btn.titleLabel?.textAlignment = NSTextAlignment.Center
        quickBar1Btn.setTitleColor(blue1, forState: UIControlState.Normal)
        quickBar1Btn.setColor(blue1)
        quickBar1Btn.addTarget(self, action: "myThisYearAppListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let quickBar1Marker = UIView()
        quickBar1Marker.frame = CGRect(x: 0.0, y: 100.0, width: 250.0, height: 15.0)
        quickBar1Marker.backgroundColor = blue1
        
        quickBar1Panel.addSubview(quickBar1LB)
        quickBar1Panel.addSubview(quickBar1Btn)
        quickBar1Panel.addSubview(quickBar1Marker)
        
        
        let quickBar2LB = UILabel()
        quickBar2LB.frame = CGRect(x: 10.0, y: 10.0, width: 230.0, height: 30.0)
        quickBar2LB.font = UIFont(name: "HelveticaNeue", size: 18.0)
        quickBar2LB.textColor = UIColor.blackColor()
        quickBar2LB.textAlignment = NSTextAlignment.Center
        quickBar2LB.text = "My Application(Total)"
        
        quickBar2Btn = LinkButton()
        
        quickBar2Btn.frame = CGRect(x: 10.0, y: 40.0, width: 230.0, height: 30.0)
        quickBar2Btn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
        quickBar2Btn.titleLabel?.textAlignment = NSTextAlignment.Center
        quickBar2Btn.setTitleColor(blue2, forState: UIControlState.Normal)
        quickBar2Btn.setColor(blue2)
        quickBar2Btn.addTarget(self, action: "myTotalAppListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let quickBar2Marker = UIView()
        quickBar2Marker.frame = CGRect(x: 0.0, y: 100.0, width: 250.0, height: 15.0)
        quickBar2Marker.backgroundColor = blue2
        quickBar2Panel.addSubview(quickBar2LB)
        quickBar2Panel.addSubview(quickBar2Btn)
        quickBar2Panel.addSubview(quickBar2Marker)
        
        let quickBar3LB = UILabel()
        quickBar3LB.frame = CGRect(x: 10.0, y: 10.0, width: 230.0, height: 30.0)
        quickBar3LB.font = UIFont(name: "HelveticaNeue", size: 18.0)
        quickBar3LB.textColor = UIColor.blackColor()
        quickBar3LB.textAlignment = NSTextAlignment.Center
        quickBar3LB.text = "Messages"
        
        quickBar3Btn = LinkButton()
        quickBar3Btn.frame = CGRect(x: 10.0, y: 40.0, width: 230.0, height: 30.0)
        quickBar3Btn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
        quickBar3Btn.titleLabel?.textAlignment = NSTextAlignment.Center
        quickBar3Btn.setTitleColor(blue3, forState: UIControlState.Normal)
        quickBar3Btn.setColor(blue3)
        quickBar3Btn.addTarget(self, action: "myMessageListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let quickBar3Marker = UIView()
        quickBar3Marker.frame = CGRect(x: 0.0, y: 100.0, width: 250.0, height: 15.0)
        quickBar3Marker.backgroundColor = blue3
        quickBar3Panel.addSubview(quickBar3LB)
        quickBar3Panel.addSubview(quickBar3Btn)
        quickBar3Panel.addSubview(quickBar3Marker)
        
        let mainCaptionLB = UILabel()
        mainCaptionLB.frame = CGRect(x: 10.0, y: 10.0, width: 500, height: 60)
        mainCaptionLB.font = UIFont(name: "HelveticaNeue", size: 28.0)
        mainCaptionLB.textAlignment = NSTextAlignment.Center
        mainCaptionLB.text = "Waiting For Approval Application:"
        
        let captionBottomLine = UIView()
        captionBottomLine.frame = CGRect(x: 0.0, y: 70.0, width: 800.0, height: 5.0)
        captionBottomLine.backgroundColor = blue3
        
        mainPanel.addSubview(mainCaptionLB)
        mainPanel.addSubview(captionBottomLine)
        
        updateUserInfo()
        var apps: [Application]! = currentUser._mockAppList[2014]
        var step: Int = 0.0
        
        for app in apps{
            var managerApprovalListView = UIView();
            
            var applicationTitle = UILabel()
            applicationTitle.frame = CGRect(x: 10.0, y: 70.0 + step, width: 500, height: 60)
            applicationTitle.font = UIFont(name: "HelveticaNeue", size: 28.0)
            applicationTitle.textAlignment = NSTextAlignment.Left
            applicationTitle.text = app.appID
            
            var applyDate = UILabel()
            applyDate.frame = CGRect(x: 10.0, y: 130.0 + step, width: 500, height: 60)
            applyDate.font = UIFont(name: "HelveticaNeue", size: 28.0)
            applyDate.textAlignment = NSTextAlignment.Left
            applyDate.text = "Applied Date: \(app.applyDate)"
            
            var approveBtn = LinkButton()
            approveBtn.frame = CGRect(x: 510.0, y: 130.0 + step, width: 100.0, height: 30.0)
            approveBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
            approveBtn.titleLabel?.textAlignment = NSTextAlignment.Right
            approveBtn.setTitleColor(blue1, forState: UIControlState.Normal)
            approveBtn.setColor(blue1)
            approveBtn.addTarget(self, action: "myThisYearAppListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            approveBtn.setTitle("Approve", forState: UIControlState.Normal)
            approveBtn.layer.borderWidth = 1
            
            var rejectBtn = LinkButton()
            rejectBtn.frame = CGRect(x: 650.0, y: 130.0 + step, width: 100.0, height: 30.0)
            rejectBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
            rejectBtn.titleLabel?.textAlignment = NSTextAlignment.Right
            rejectBtn.setTitleColor(blue1, forState: UIControlState.Normal)
            rejectBtn.setColor(blue1)
            rejectBtn.addTarget(self, action: "myThisYearAppListClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            rejectBtn.setTitle("Reject", forState: UIControlState.Normal)
            rejectBtn.layer.borderWidth = 1
            
            var appBottomLine = UIView()
            appBottomLine.frame = CGRect(x: 0.0, y: 180.0 + step, width: 800.0, height: 5.0)
            appBottomLine.backgroundColor = blue3
            
            managerApprovalListView.addSubview(applicationTitle)
            managerApprovalListView.addSubview(applyDate)
            managerApprovalListView.addSubview(approveBtn)
            managerApprovalListView.addSubview(rejectBtn)
            managerApprovalListView.addSubview(appBottomLine)
            mainPanel.addSubview(managerApprovalListView)
            
            step = step + 120.0
        }
        
    }
    
    func createUIForAssistant(){
        
    }
    
    
    func updateUserInfo(){
        if let session = Session.currentSession {
            SnailServer.server.getApplicationsByYear(
                session.sessionID,
                year: 2014,
                onSucceed: { apps in
                    if let appsThisYear = apps {
                        self.quickBar1Btn.setTitle("\(appsThisYear.count)", forState: UIControlState.Normal)
                        self.quickBar1Btn.setNeedsDisplay()
                    }
                },
                onFailed: { error in
                    self.showErrorMsg(error)
                })
            SnailServer.server.getApplications(
                session.sessionID,
                onSucceed: { apps in
                    if let appsTotal = apps {
                        self.quickBar2Btn.setTitle("\(appsTotal.count)", forState: UIControlState.Normal)
                        self.quickBar2Btn.setNeedsDisplay()
                    }
                },
                onFailed: { error in
                    self.showErrorMsg(error)
            })
            SnailServer.server.getUserMessages(
                session.sessionID,
                userID: session.currentUser.username,
                onSucceed: { msgs in
                    if let msgsCount = msgs {
                        self.quickBar3Btn.setTitle("\(msgsCount.count)", forState: UIControlState.Normal)
                        self.quickBar3Btn.setNeedsDisplay()
                    }
                },
                onFailed: { error in
                    self.showErrorMsg(error)
            })
            
        }
    
        /*
        if let applicationsThisYear = currentUser.getApplicationsByYear()[2014]{
            quickBar1Btn.setTitle("\(applicationsThisYear.count)", forState: UIControlState.Normal)
        }

        
        quickBar2Btn.setTitle("\(currentUser.getAllApplications().count)", forState: UIControlState.Normal)

        quickBar3Btn.setTitle("\(currentUser.getMessages().count)", forState: UIControlState.Normal)
        */
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func updateCurrentApplicationInfo(){
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            SnailServer.server.getUserCurrentApplication(session.sessionID,
                username: currentUser.username,
                onSucceed: { application in
                    self.waitingBar?.hide(true)
                    self.currentApplication = application
                    self.updateCurrentApplicationUI()
                }, onFailed: { error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
            })
        }
        
    }
    
    func updateCurrentApplicationUI(){
        if let app = currentApplication {
            appIDValueLB.text = app.appID
            sampleNameValueLB.text = app.applySample.sample.sampleName
            sampleQuantityValueLB.text = "\(app.applySample.quantity)"
            doctorNameValueLB.text = app.doctorName
            applyDateValueLB.text = "\(app.applyDate)"
            statusValueLB.text = "\(app.status)"
        
            switch app.status{
            case ApplicationStatus.WaitingForApproval:
                detailBtn.enabled = true;
                cancelBtn.enabled = true;
                signBtn.enabled = false;
            case ApplicationStatus.Approved:
                detailBtn.enabled = true;
                cancelBtn.enabled = false;
                signBtn.enabled = false;
            case ApplicationStatus.Rejected:
                detailBtn.enabled = true;
                cancelBtn.enabled = false;
                signBtn.enabled = false;
            case ApplicationStatus.Deliveried:
                detailBtn.enabled = true;
                cancelBtn.enabled = false;
                signBtn.enabled = true;
            case ApplicationStatus.Signed:
                detailBtn.enabled = true;
                cancelBtn.enabled = false;
                signBtn.enabled = false;
            }
        }else{
            appIDValueLB.text = ""
            sampleNameValueLB.text = ""
            sampleQuantityValueLB.text = ""
            doctorNameValueLB.text = ""
            applyDateValueLB.text = ""
            statusValueLB.text = ""
            detailBtn.enabled = false;
            cancelBtn.enabled = false;
            signBtn.enabled = false;
        }
    }
    
    func settingsBtnClicked(sender: UIButton){
        performSegueWithIdentifier("Settings", sender: self)
    }
    
    func logoutBtnClicked(sender: UIButton){
        logoutAlertView!.show()
    }
    
    func myThisYearAppListClicked(sender: UIButton){
        if let session = Session.currentSession {
            
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            SnailServer.server.getApplicationsByYear(session.sessionID,
                year: 2014,
                onSucceed: {apps in
                    self.waitingBar?.hide(true)
                    self.applications = apps
                    self.performSegueWithIdentifier("CurrentYearApplicationList", sender: self)
                },
                onFailed: {error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
            })
        }else{
            showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
    }
    
    func myTotalAppListClicked(sender: UIButton){
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            SnailServer.server.getApplications(session.sessionID,
                onSucceed: {apps in
                    self.waitingBar?.hide(true)
                    self.applications = apps
                    self.performSegueWithIdentifier("TotalApplicationList", sender: self)
                },
                onFailed: {error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
            })
        }else{
            showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
        
    }
    
    func myMessageListClicked(sender: UIButton){
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            SnailServer.server.getUserMessages(session.sessionID,
                userID: session.currentUser.username,
                onSucceed: {msgs in
                    self.waitingBar?.hide(true)
                    self.messages = msgs
                    self.performSegueWithIdentifier("MessageList", sender: self)
                },
                onFailed: {error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
            })
        }else{
            showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
    }
    
    func currentAppDetailClicked(sender: UIButton){
        performSegueWithIdentifier("ApplicationDetail", sender: self)
    }
    
    func currentAppCancelClicked(sender: UIButton){
        cancelApplicationAlertView!.show()
    }
    
    func currentAppSignClicked(sender: UIButton){
        let alertView = UIAlertView(title: "Current Application Sign Button Clicked", message: "Quiit System", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func applySampleClicked(sender: UIButton){
        self.performSegueWithIdentifier("NewApplication", sender: self)
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == logoutAlertView{
            if buttonIndex == 1{
                if let session = Session.currentSession {
                    waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    waitingBar?.removeFromSuperViewOnHide = true
                    SnailServer.server.logout(session.sessionID,
                        onSucceed: {
                            self.waitingBar?.hide(true)
                            Session.currentSession = nil
                            self.performSegueWithIdentifier("logout", sender: self)
                        },
                        onFailed: { error in
                            self.waitingBar?.hide(true)
                            self.showErrorMsg(error)
                            Session.currentSession = nil
                            self.performSegueWithIdentifier("logout", sender: self)
                        })
                }else{
                    Session.currentSession = nil
                    self.performSegueWithIdentifier("logout", sender: self)
                }
                
            }
        }else if alertView == cancelApplicationAlertView{
            if buttonIndex == 1{
                if let session = Session.currentSession {
                    if let app = currentApplication {
                        waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        waitingBar?.removeFromSuperViewOnHide = true
                    
                        SnailServer.server.cancelApplication(
                            session.sessionID,
                            applicationID: app.appID,
                            onSucceed: {apps in
                                self.waitingBar?.hide(true)
                                self.updateUserInfo()
                                self.updateCurrentApplicationInfo()
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
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ApplicationDetail" {
            let detailController = segue.destinationViewController as ApplicationDetailViewController
            if let curApp = currentApplication {
                detailController.currentApplication = curApp
                detailController.enableEdit = (curApp.status == ApplicationStatus.WaitingForApproval)
            }
        }else if segue.identifier == "NewApplication"{
            let newApplicationController = segue.destinationViewController as NewApplicationViewController
            newApplicationController.userInfoDelegate = self
        }else if segue.identifier == "CurrentYearApplicationList"{
            let applicationListController = segue.destinationViewController as ApplicationListViewController
            applicationListController.dataSourceType = "CurrentYear"
            applicationListController.applications = applications
            applicationListController.userInfoDelegate = self
        }else if segue.identifier == "TotalApplicationList"{
            let applicationListController = segue.destinationViewController as ApplicationListViewController
            applicationListController.dataSourceType =  "Total"
            applicationListController.applications = applications
            applicationListController.userInfoDelegate = self
        }else if segue.identifier == "MessageList"{
            let messageListController = segue.destinationViewController as MessageListViewController
            messageListController.messages = messages
            messageListController.userInfoDelegate = self
        }else if segue.identifier == "Settings"{
            let settingsVC = segue.destinationViewController as SettingsViewController
            
        }
    }
    
    func userInfoUpdate() {
        updateUserInfo()
    }
}

