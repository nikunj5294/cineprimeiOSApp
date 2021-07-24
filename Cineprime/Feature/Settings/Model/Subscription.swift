//
//  Subscription.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 08/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation

var subscription = Subscription()
class Subscription {
    
    var list: [SubscriptionData] = [SubscriptionData]()
    
    func update(_ data: JSON) {
        for(_,obj) in data {
            let temp = SubscriptionData()
            temp.update(obj)
            if temp.plan_id != "9"{
                list.append(temp)
            }
        }
    }
}

class SubscriptionData {
    
    var plan_id = ""
    var plan_name = ""
    var plan_price = ""
    var currency_code = ""
    var plan_duration = ""
    var plan_description = ""

    
    func update(_ data: JSON) {
        plan_id = strFromJSON(data["plan_id"])
        plan_name = strFromJSON(data["plan_name"])
        plan_price = strFromJSON(data["plan_price"])
        currency_code = strFromJSON(data["currency_code"])
        plan_duration = strFromJSON(data["plan_duration"])
        plan_description = strFromJSON(data["plan_description"])

    }
}
