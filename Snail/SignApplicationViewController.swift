//
//  SignApplicationViewController.swift
//  Snail
//
//  Created by Solution on 14/11/8.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

protocol ApplicationSignDelegate{
    func sign(image: UIImage)
    func cancelSign()
}

class SignApplicationViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var clearBtn: UIGlossyButton!
    @IBOutlet weak var saveBtn: UIGlossyButton!
    @IBOutlet weak var cancelBtn: UIGlossyButton!
    
    var canvasView: SignatureView!
    
    var cancelAlertView: UIAlertView!
    var saveAlertView: UIAlertView!
    var clearAlertView: UIAlertView!
    
    var currentApplication: Application!
    var delegate: ApplicationSignDelegate!
    
    var waitingBar: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelAlertView = UIAlertView(title: "Cancel", message: "Do you want to cancel sign the application?", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
        saveAlertView = UIAlertView(title: "Sign Application", message: "Do you want to save the signature?", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
        clearAlertView = UIAlertView(title: "Cancel", message: "Do you want to clear the signature?", delegate: self, cancelButtonTitle: "Cancle", otherButtonTitles: "OK")
        
        canvasView = SignatureView(frame: CGRect(x: 22, y: 20, width: 497, height: 436))
            
        setButtonStyle(clearBtn, actionSelector: "clearBtnClicked:")
        setButtonStyle(saveBtn, actionSelector: "saveBtnClicked:")
        setButtonStyle(cancelBtn, actionSelector: "cancelBtnClicked:")
    }
    
    func setButtonStyle(btn: UIGlossyButton, actionSelector: Selector){
        btn.titleLabel?.font = CustomizedFont.font_btn
        btn.titleLabel?.textAlignment = NSTextAlignment.Center
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.buttonTintColor = CustomizedColor.blue
        btn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        btn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        btn.addTarget(self, action: actionSelector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func clearBtnClicked(sender: UIGlossyButton){
        clearAlertView.show()
    }
    
    func saveBtnClicked(sender: UIGlossyButton){
        saveAlertView.show()
    }
    
    func cancelBtnClicked(sender: UIGlossyButton){
        cancelAlertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == cancelAlertView{
            if buttonIndex == 1{
                if let d = delegate{
                    d.cancelSign()
                }
            }
        }else if alertView == saveAlertView{
            if buttonIndex == 1{
                var image = saveToImage()
                if let session = Session.currentSession {
                
                        waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        waitingBar?.removeFromSuperViewOnHide = true
                        
                        SnailServer.server.uploadApplicationSignatureImage(
                            session.sessionID,
                            applicationID: currentApplication.appID,
                            image: image,
                            onSucceed: {
                                self.waitingBar?.hide(true)
                                if let d = self.delegate{
                                    d.sign(image)
                                }
                            },
                            onFailed: { error in
                                self.waitingBar?.hide(true)
                                self.showErrorMsg(Error(errorCode: -3, errorMsg: "Sign Application failed"))
                            })
                    
                }else{
                    showErrorMsg(Error(errorCode: -2, errorMsg: "Login required"))
                }
                                
            }
        }else if alertView == clearAlertView{
            if buttonIndex == 1{
                canvasView.clear()
            }
        }
    }
    
    func showErrorMsg(error: Error){
        let alertView = UIAlertView(title: "Error", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func saveToImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var signImg = UIImage(CGImage: CGImageCreateWithImageInRect(image.CGImage, canvasView.frame))
        
        return signImg
    }

}