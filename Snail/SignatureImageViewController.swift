//
//  SignatureImageViewController.swift
//  Snail
//
//  Created by Solution on 14/11/17.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

class SignatureImageViewController: UIViewController{
    
    @IBOutlet weak var signatureIV: UIImageView!
    @IBOutlet weak var closeBtn: UIGlossyButton!
    
    var currentApplication: Application!
    var waitingBar: MBProgressHUD?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = CustomizedFont.font_btn
        closeBtn.buttonTintColor = CustomizedColor.blue
        closeBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        closeBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        if let session = Session.currentSession {
            waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            waitingBar?.removeFromSuperViewOnHide = true
            
            SnailServer.server.getSignatureImage(
                session.sessionID,
                applicationID: currentApplication.appID,
                onSucceed: { img in
                    self.waitingBar?.hide(true)
                    self.signatureIV.image = img
                },
                onFailed: {error in
                    self.waitingBar?.hide(true)
                    self.showErrorMsg(error)
            })
        }else{
            self.showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
        }
        
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }

    
    @IBAction func closeBtnClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}