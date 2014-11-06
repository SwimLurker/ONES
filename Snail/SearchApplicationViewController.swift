//
//  SearchApplicationViewController.swift
//  Snail
//
//  Created by Solution on 14/10/15.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationSearchDelegate {
    func search(appID: String?, doctorName: String?, fromDate: NSDate?, toDate: NSDate?)
    
    func cancelSearch()
}

class SearchApplicationViewController: UIViewController{

    @IBOutlet weak var appIDTF: UITextField!
    @IBOutlet weak var doctorNameTF: UITextField!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    @IBOutlet weak var searchBtn: UIGlossyButton!
    @IBOutlet weak var cancelBtn: UIGlossyButton!
    
    var delegate: ApplicationSearchDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM"
        
        var cal  = NSCalendar(identifier: NSGregorianCalendar)
        
        var dateCom = cal.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth, fromDate: now)
        dateCom.month = dateCom.month - 1
        
        var lastMonth = NSDate()
        
        fromDateTF.text = formatter.stringFromDate(cal.dateFromComponents(dateCom)!)
        toDateTF.text = formatter.stringFromDate(now)
        
        setButtonStyle(searchBtn, actionSelector: "searchBtnClicked:")
        
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
    
    func searchBtnClicked(sender: UIButton){
        let appID = appIDTF?.text
        let doctorName = doctorNameTF?.text
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let fromDate = dateFormatter.dateFromString(fromDateTF.text)
        
        let toDate = dateFormatter.dateFromString(toDateTF.text)
        
        var filterID = appID
        if appID != nil && appID!.isEmpty {
            filterID = nil
        }
        
        var filterDoctor = doctorName
        if doctorName != nil && doctorName!.isEmpty{
            filterDoctor = nil
        }
        
        if let d  = delegate {
            d.search(filterID, doctorName: filterDoctor, fromDate: fromDate, toDate: toDate)
        }
    }
    
    func cancelBtnClicked(sender: UIButton){
        if let d = delegate {
            d.cancelSearch()
        }
    }
    
    
}