//
//  User.swift
//  Fighter Connect
//
//  Created by kishan on 27/05/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON


private var _sharedUser = User()
var kCurrentUser = _sharedUser.sharedInstance


class User
{
    var user_id = ""
    var phone = ""
    var name = ""
    var user_image = ""
    
    var last_login_phone = ""
    var last_login_password = ""
    
    let key = "userDeafultKey"
    
    var sharedInstance: User
    {
        if self.user_id == ""
        {
            self.loadFromDefault()
        }
        return self
    }
    
    func loadFromDefault()
    {
        if let dict = UserDefaults.standard.value(forKey: self.key) as? [String : Any]
        {
            self.user_id = dict["user_id"] as? String ?? ""
            self.phone = dict["phone"] as? String ?? ""
            self.name = dict["name"] as? String ?? ""
            self.user_image = dict["user_image"] as? String ?? ""
            
            self.last_login_phone = dict["last_login_phone"] as? String ?? ""
            self.last_login_password = dict["last_login_password"] as? String ?? ""
        }
    }
    
    func saveToDefault()
    {
        
        var dict : [String : Any] = [String : Any]()

        dict["user_id"] = user_id
        dict["phone"] = phone
        dict["name"] = name
        dict["user_image"] = user_image
        
        dict["last_login_phone"] = last_login_phone
        dict["last_login_password"] = last_login_password

        UserDefaults.standard.set(dict, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    func update(_ data : JSON)
    {
        if strFromJSON(data["user_id"]) == "" || strFromJSON(data["user_id"]) == nil
        {
            self.user_id = intFromJSON(data["id"]).description
        }
        else
        {
            self.user_id = strFromJSON(data["user_id"])
        }
        self.phone = strFromJSON(data["phone"])
        self.name = strFromJSON(data["name"])
        self.user_image = strFromJSON(data["user_image"])
        self.saveToDefault()
    }
    
    func logout()
    {

        self.user_id = ""
        self.phone = ""
        self.name = ""
        self.user_image = ""
        
        self.saveToDefault()
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}



