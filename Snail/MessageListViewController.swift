//
//  MessageListViewController.swift
//  Snail
//
//  Created by Solution on 14/10/13.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

class MessageListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate{
   
    var messages: [Message]?
    var selectedIndexPath: NSIndexPath?
    var selectedMessage: Message?
    
    var deleteAlertView: UIAlertView?
    
    var userInfoDelegate: UserInfoUpdateDelegate?
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationButtons()
        
        self.title = "Messages"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.blackColor().CGColor
        
        
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
        
        self.navigationItem.rightBarButtonItems = [refreshBarItem]
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        }else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(selectedIndexPath == indexPath){
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MessageListItemDetailCell") as UITableViewCell?
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MessageListItemDetailCell")
            }
            let message = messages![indexPath.row]
                
            let titleLable = cell!.viewWithTag(26001) as UILabel
            titleLable.text = message.title
                
            let sentInfoLabel = cell!.viewWithTag(26002) as UILabel
            sentInfoLabel.text = "Send By:\(message.sender) At \(message.sentDate)"
                
            let contentBKLabel = cell!.viewWithTag(26003) as UILabel
            contentBKLabel.backgroundColor = CustomizedColor.light_blue
            
            let contentLabel = cell!.viewWithTag(26005) as UILabel
            
            contentLabel.backgroundColor = CustomizedColor.light_blue
            contentLabel.text = message.content
            contentLabel.textColor = UIColor.whiteColor()
            
                
            let deleteBtn = cell!.viewWithTag(26004) as TableViewCellButton
            setTableButtonStyle(deleteBtn, cellID: message.id, actionSelector: "deleteMessageBtnClicked:")
            
            return cell!
        }else{
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MessageListItemCell") as UITableViewCell?
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MessageListItemCell")
            }
            let message = messages![indexPath.row]
            
            let statusIconIV = cell?.viewWithTag(25001) as UIImageView
            if !message.isRead{
                statusIconIV.image = UIImage(named: "unread.png")
            }else{
                statusIconIV.image = nil
            }
            
            let titleLable = cell!.viewWithTag(25002) as UILabel
            titleLable.text = message.title
            
            let sentInfoLabel = cell!.viewWithTag(25003) as UILabel
            sentInfoLabel.text = "Send By:\(message.sender) At \(message.sentDate)"
            
            
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

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let message = messages![indexPath.row]
        
        if !message.isRead {
            if let session = Session.currentSession {
                waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                waitingBar?.removeFromSuperViewOnHide = true
                
                SnailServer.server.setUserMessageRead(
                    session.sessionID,
                    userID: session.currentUser.username,
                    messageID: message.id,
                    onSucceed: { msg in
                        self.hideWaitingBar()
                        message.isRead = true
                    },
                    onFailed: {error in
                        self.hideWaitingBar()
                    })
            }
        }
        
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
    
    func hideWaitingBar(){
        waitingBar?.hide(true)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath == selectedIndexPath){
            return 200
        }else{
            return 80
        }
    }
    
    func refreshBtnClicked(sender: UIButton){
        updateMessageList()
    }
    
    func updateMessageList(){
        if let session = Session.currentSession{
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            SnailServer.server.getUserMessages(session.sessionID,
                userID: session.currentUser.username,
                onSucceed: { msgs in
                    self.waitingBar?.hide(true)
                    self.messages = msgs
                    self.selectedIndexPath = nil
                    self.selectedMessage =  nil
                    self.tableView.reloadData()
                    
                },
                onFailed: { error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
                    
            })
        }
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    
    func backToHomeBtnClicked(sender: UIButton){
        if let delegate = userInfoDelegate {
            delegate.userInfoUpdate()
        }
        navigationController?.popViewControllerAnimated(true)
    }

    func deleteMessageBtnClicked(sender: TableViewCellButton){
        
        for message in messages!{
            if message.id == sender.cellID! {
                selectedMessage = message
                break
            }
        }
        deleteAlertView = UIAlertView(title: "Delete Message", message: "Do you want to delete this message?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        deleteAlertView!.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == deleteAlertView{
            if buttonIndex == 1{
                
                if let session = Session.currentSession {
                    if let msg = selectedMessage {
                        waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        waitingBar?.removeFromSuperViewOnHide = true
                        
                        SnailServer.server.deleteUserMessage(
                            session.sessionID,
                            userID: session.currentUser.username,
                            messageID: msg.id,
                            onSucceed: {
                                self.waitingBar?.hide(true)
                                self.updateMessageList()
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
    
}