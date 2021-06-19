//
//  AppDetail.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 20/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

var appDetail = AppDetail()
class AppDetail {
        
    var app_about = ""
    var app_version = ""
    var app_website = ""
    var app_privacy = ""
    var app_tc = ""
    var user_status = ""
    var app_name = ""
    var app_logo = ""
    var app_email = ""
    var app_contact = ""
    var app_company = ""
    
    var app_force_update = ""
    var app_package_name = ""
    var banner_ad = ""
    var banner_ad_id = ""
    var interstital_ad = ""
    var interstital_ad_click = ""
    var interstital_ad_id = ""
    var publisher_id = ""

    
    func update(_ data: JSON) {
         app_about = strFromJSON(data["app_about"])
         app_version = strFromJSON(data["app_version"])
         app_website = strFromJSON(data["app_website"])
         app_privacy = strFromJSON(data["app_privacy"])
         user_status = strFromJSON(data["user_status"])
         app_name = strFromJSON(data["app_name"])
         app_logo = strFromJSON(data["app_logo"])
         app_email = strFromJSON(data["app_email"])
         app_contact = strFromJSON(data["app_contact"])
         app_company = strFromJSON(data["app_company"])
         app_tc = strFromJSON(data["app_tc"])
         app_force_update = strFromJSON(data["app_force_update"])
         app_package_name = strFromJSON(data["app_package_name"])
         banner_ad = strFromJSON(data["banner_ad"])
         banner_ad_id = strFromJSON(data["banner_ad_id"])
         interstital_ad = strFromJSON(data["interstital_ad"])
         interstital_ad_click = strFromJSON(data["interstital_ad_click"])
         interstital_ad_id = strFromJSON(data["interstital_ad_id"])
         publisher_id = strFromJSON(data["publisher_id"])


    }
}
