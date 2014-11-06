//
//  DoctorListViewController.swift
//  ONES
//
//  Created by Solution on 14/10/7.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

protocol DoctorInfoSelectionDelegate {
    func selectDoctorInfo(doctorInfo: Doctor)
}

class DoctorListViewController: UITableViewController, RETableViewManagerDelegate{
    
    var manager: RETableViewManager?
    var doctors: [Doctor]!
    
    var selectionDelegate: DoctorInfoSelectionDelegate?
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = RETableViewManager(tableView: tableView, delegate: self)
        tableView.dataSource = self
        tableView.delegate = self
        
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            SnailServer.server.getDoctorsByUser(
                session.sessionID,
                userID: session.currentUser.username,
                onSucceed: {doctors in
                    self.waitingBar?.hide(true)
                    self.doctors = doctors
                    self.tableView.reloadData()
                }, onFailed: {error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
                    
                })
        }else{
            showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
       
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ds = doctors{
            return ds.count
        }else {
            return 0
        }
    }
    
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("DoctorInfoCell") as UITableViewCell?
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DoctorInfoCell")
        }
        let doctorNameLabel = cell!.viewWithTag(23001) as UILabel
        let doctorAddressLabel = cell!.viewWithTag(23002) as UILabel
            
        if let doctorInfo = doctors{
            doctorNameLabel.text = doctorInfo[indexPath.row].doctorName
            doctorAddressLabel.text = doctorInfo[indexPath.row].address
        }
                    
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = selectionDelegate {
            delegate.selectDoctorInfo(doctors[indexPath.row])
        }
    }
}
