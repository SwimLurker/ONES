//
//  SampleListViewController.swift
//  ONES
//
//  Created by Solution on 14/10/9.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

protocol SampleInfoSelectionDelegate {
    func selecteSampleInfo(sample: Sample)
}

class SampleListViewController: UITableViewController, RETableViewManagerDelegate{
    
    var manager: RETableViewManager?

    var samples: [Sample]?
    
    var selectionDelegate: SampleInfoSelectionDelegate?
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = RETableViewManager(tableView: tableView, delegate: self)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            SnailServer.server.getUserAvailableSamples(
                session.sessionID,
                userID: session.currentUser.username,
                onSucceed: {samples in
                    self.waitingBar?.hide(true)
                    self.samples = samples
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
        if let s = samples{
            return s.count
        }else{
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("SampleInfoCell") as UITableViewCell?
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SampleInfoCell")
        }
        let samplePictureIV = cell!.viewWithTag(24001) as UIImageView
        let sampleNameLabel = cell!.viewWithTag(24002) as UILabel
        let sampleTypeLabel = cell!.viewWithTag(24003) as UILabel
        
        if let sample = samples?[indexPath.row] {
            samplePictureIV.image = UIImage(named: sample.samplePictureName)
            sampleNameLabel.text = sample.sampleName
            sampleTypeLabel.text = "\(sample.sampleType)"
        }
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = selectionDelegate {
            if let selectedSampleInfo = samples?[indexPath.row] {
                delegate.selecteSampleInfo(selectedSampleInfo)
            }
        }
    }
}
