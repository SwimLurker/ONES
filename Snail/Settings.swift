//
//  Settings.swift
//  Snail
//
//  Created by Solution on 14/10/21.
//  Copyright (c) 2014年 NNIT. All rights reserved.
//

import Foundation

let SETTINGS_SERVER_ADDRESS: String = "server_address"
let DEFAULT_SERVER_ADDRESS: String = "http://10.41.233.204:8080"

class Settings{
    class var serverURL: String {
        get{
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let url = userDefaults.stringForKey(SETTINGS_SERVER_ADDRESS) {
                return url
            }else{
                return DEFAULT_SERVER_ADDRESS
            }
        }
    }
    
    class var loginURL: String{
        get{
            //return serverURL + "/sessionfail")
            return serverURL + "/session"
        }
    }
    
    class var logoutURL: String{
        get{
            return serverURL + "/session"
        }
    }
    
    class var applicationsURL: String{
        get{
            return serverURL + "/snail/applications"
        }
    }
    
    class var applicationURL: String{
        get{
            return serverURL + "/snail/applications/{appid}"
        }
    }
    
    class var applicationApprovalRecordsURL: String{
        get{
            return serverURL + "/snail/applications/{appid}/approvals"
        }
    }
    
    class var userApplicationsURL: String{
        get{
            return serverURL + "/snail/users/{userid}/applications"
        }
    }
    
    class var userMessagesURL: String{
        get{
            return serverURL + "/snail/users/{userid}/messages"
        }
    }
    
    class var userMessageURL: String{
        get{
            return serverURL + "/snail/users/{userid}/messages/{messageid}"
        }
    }
    
    class var userDoctorsURL: String{
        get{
            return serverURL + "/snail/users/{userid}/doctors"
        }
    }
    
    class var doctorURL: String{
        get{
            return serverURL + "/snail/doctors/{doctorid}"
        }
    }
    
    class var doctorsURL: String{
        get{
            return serverURL + "/snail/doctors"
        }
    }
    
    class var userSamplesURL: String{
        get{
            return serverURL + "/snail/users/{userid}/samples"
        }
    }
    
    class var samplesURL: String{
        get{
            return serverURL + "/snail/samples"
        }
    }
    
    class var userURL: String{
        get{
            return serverURL + "/snail/users/{userid}"
        }
    }
    
    class var signatureImgURL: String{
        get{
            return serverURL + "/snail/applications/{appid}/signatureimg/{imgid}"
        }
    }

}