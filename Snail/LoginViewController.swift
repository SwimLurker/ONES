//
//  LoginViewController.swift
//  ONES
//
//  Created by Solution on 14/9/25.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIAlertViewDelegate{
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var captionLB: UILabel!
    @IBOutlet weak var versionLB: UILabel!
    @IBOutlet weak var copyrightLB: UILabel!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var passwordLB: UILabel!
    @IBOutlet weak var loginBtn: UIGlossyButton!
    
    
    @IBOutlet weak var letterO: UILabel!
    @IBOutlet weak var letterN: UILabel!
    @IBOutlet weak var letterE: UILabel!
    @IBOutlet weak var letterS: UILabel!
    
    @IBOutlet weak var barrierLB: UILabel!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    var waitingBar: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.titleLabel?.font = CustomizedFont.font_btn
        loginBtn.buttonTintColor = CustomizedColor.blue
        loginBtn.setGradientType(kUIGlossyButtonGradientTypeLinearGlossyStandard)
        loginBtn.setShadow(UIColor.blackColor(), opacity: 0.8, offset: CGSizeMake(0, 1), blurRadius: 4)
        
        
        showAnimation()
        
        
    }
    

    @IBAction func loginBtnClicked(sender: AnyObject) {
        waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        waitingBar.removeFromSuperViewOnHide = true
        
        SnailServer.server.login(usernameTF.text, password: passwordTF.text, onSucceed: loginSucceed, onFailed: loginFailed)
    }
    
    func loginSucceed(sessionObj: Session?) {
        waitingBar.hide(true)
        
        if let session = sessionObj {
            Session.currentSession = session
            performSegueWithIdentifier("home", sender: self)
        }
        
    }
    
    func loginFailed(error: Error){
        waitingBar.hide(true)
        
        let alertView = UIAlertView(title: "Login Failed", message: error.errorMsg, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func showAnimation(){
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior(items:[captionLB, letterO, letterN, letterE, letterS, versionLB])
        collision = UICollisionBehavior(items: [letterO, letterN, letterE, letterS,captionLB, versionLB, usernameLB, usernameTF, passwordLB, passwordTF, loginBtn, copyrightLB])
        
        collision.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: barrierLB.frame))
        //        collision.addBoundaryWithIdentifier("usernameTF", forPath: UIBezierPath(rect: usernameTF.frame))
        //        collision.addBoundaryWithIdentifier("passwordLB", forPath: UIBezierPath(rect: passwordLB.frame))
        //        collision.addBoundaryWithIdentifier("passwordTF", forPath: UIBezierPath(rect: passwordTF.frame))
        //
        collision.translatesReferenceBoundsIntoBoundary = true
        
        let itemBehaviour1 = UIDynamicItemBehavior(items:[captionLB, versionLB])
        itemBehaviour1.elasticity = 0.8
        animator.addBehavior(itemBehaviour1)
        
        let itemBehaviour2 = UIDynamicItemBehavior(items:[letterO])
        itemBehaviour2.elasticity = 0.6
        itemBehaviour2.friction = 0.9
        itemBehaviour2.resistance = 0.9
        animator.addBehavior(itemBehaviour2)
        
        let itemBehaviour3 = UIDynamicItemBehavior(items:[letterN])
        itemBehaviour3.elasticity = 0.5
        animator.addBehavior(itemBehaviour3)
        
        let itemBehaviour4 = UIDynamicItemBehavior(items:[letterE])
        itemBehaviour4.elasticity = 0.8
        animator.addBehavior(itemBehaviour4)
        
        let itemBehaviour5 = UIDynamicItemBehavior(items:[letterS])
        itemBehaviour5.elasticity = 0.7
        animator.addBehavior(itemBehaviour5)
        let attach1 = UIAttachmentBehavior(item: letterO, attachedToItem: captionLB)
        let attach2 = UIAttachmentBehavior(item: letterN, attachedToItem: captionLB)
        let attach3 = UIAttachmentBehavior(item: letterE, attachedToItem: captionLB)
        let attach4 = UIAttachmentBehavior(item: letterS, attachedToItem: captionLB)
        let attach5 = UIAttachmentBehavior(item: versionLB, attachedToItem: captionLB)
        
        animator.addBehavior(attach1)
        animator.addBehavior(attach2)
        animator.addBehavior(attach3)
        animator.addBehavior(attach4)
        animator.addBehavior(attach5)
        animator.addBehavior(gravity)
        animator.addBehavior(collision)

    }
    
    
}