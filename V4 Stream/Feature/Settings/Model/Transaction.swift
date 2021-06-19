//
//  Transaction.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 08/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation


class Transaction {
    
    var subList: [SubscriptionTransactionData] = [SubscriptionTransactionData]()
    var rentList: [RentalransactionData] = [RentalransactionData]()
    var donateList: [DonateTransactionData] = [DonateTransactionData]()
    
    func update(_ data: JSON) {
        for(_,obj) in data["subscription_plan"] {
            let temp = SubscriptionTransactionData()
            temp.update(obj)
            subList.append(temp)
        }
        
        for(_,obj) in data["rental_plan"] {
            let temp = RentalransactionData()
            temp.update(obj)
            rentList.append(temp)
        }
        
        for(_,obj) in data["donate_plan"] {
            let temp = DonateTransactionData()
            temp.update(obj)
            donateList.append(temp)
        }
    }
}


class SubscriptionTransactionData {
    
    var transction_date = ""
    var transction_donate_flag = ""
    var transction_email = ""
    var transction_expiry_date = ""
    var transction_gateway = ""
    var transction_id = ""
    var transction_payment_amount = ""
    var transction_payment_id = ""
    var transction_plan_id = ""
    var transction_plan_name = ""
    var transction_promocode = ""
    var transction_user_id = ""
    
    func update(_ data: JSON) {
        
         transction_date = strFromJSON(data["transction_date"])
         transction_donate_flag = strFromJSON(data["transction_donate_flag"])
         transction_email = strFromJSON(data["transction_email"])
         transction_expiry_date = strFromJSON(data["transction_expiry_date"])
         transction_gateway = strFromJSON(data["transction_gateway"])
         transction_id = strFromJSON(data["transction_id"])
         transction_payment_amount = strFromJSON(data["transction_payment_amount"])
         transction_payment_id = strFromJSON(data["transction_payment_id"])
         transction_plan_id = strFromJSON(data["transction_plan_id"])
         transction_plan_name = strFromJSON(data["transction_plan_name"])
         transction_promocode = strFromJSON(data["transction_promocode"])
         transction_user_id = strFromJSON(data["transction_user_id"])

    }
    
}

class RentalransactionData {
    
    var expirty_date = ""
    var movie_id = ""
    var movie_name = ""
    var transction_date = ""
    var transction_donate_flag = ""
    var transction_email = ""
    var transction_gateway = ""
    var transction_id = ""
    var transction_payment_amount = ""
    var transction_payment_id = ""
    var transction_plan_id = ""
    var transction_plan_name = ""
    var transction_promocode = ""
    var transction_user_id = ""
    
    func update(_ data: JSON) {
        expirty_date = strFromJSON(data["expirty_date"])
        movie_id = strFromJSON(data["movie_id"])
        movie_name = strFromJSON(data["movie_name"])
        transction_date = strFromJSON(data["transction_date"])
        transction_donate_flag = strFromJSON(data["transction_donate_flag"])
        transction_email = strFromJSON(data["transction_email"])
        transction_gateway = strFromJSON(data["transction_gateway"])
        transction_id = strFromJSON(data["transction_id"])
        transction_payment_amount = strFromJSON(data["transction_payment_amount"])
        transction_payment_id = strFromJSON(data["transction_payment_id"])
        transction_plan_id = strFromJSON(data["transction_plan_id"])
        transction_plan_name = strFromJSON(data["transction_plan_name"])
        transction_promocode = strFromJSON(data["transction_promocode"])
        transction_user_id = strFromJSON(data["transction_user_id"])
    }
}

class DonateTransactionData {
    
    var movie_id = ""
    var movie_name = ""
    var transction_date = ""
    var transction_donate_flag = ""
    var transction_email = ""
    var transction_gateway = ""
    var transction_id = ""
    var transction_payment_amount = ""
    var transction_payment_id = ""
    var transction_plan_id = ""
    var transction_plan_name = ""
    var transction_promocode = ""
    var transction_user_id = ""
    
    func update(_ data: JSON) {
  
         movie_id = strFromJSON(data["movie_id"])
         movie_name = strFromJSON(data["movie_name"])
         transction_date = strFromJSON(data["transction_date"])
         transction_donate_flag = strFromJSON(data["transction_donate_flag"])
         transction_email = strFromJSON(data["transction_email"])
         transction_gateway = strFromJSON(data["transction_gateway"])
         transction_id = strFromJSON(data["transction_id"])
         transction_payment_amount = strFromJSON(data["transction_payment_amount"])
         transction_payment_id = strFromJSON(data["transction_payment_id"])
         transction_plan_id = strFromJSON(data["transction_plan_id"])
         transction_plan_name = strFromJSON(data["transction_plan_name"])
         transction_promocode = strFromJSON(data["transction_promocode"])
         transction_user_id = strFromJSON(data["transction_user_id"])
        
    }
    
}
