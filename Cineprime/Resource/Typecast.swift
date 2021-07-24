//
//  Typecast.swift
//  GiftWrap
//
//  Created by kishan on 02/11/19.
//  Copyright © 2019 stark. All rights reserved.
//

import Foundation
import SwiftyJSON

func strFromJSON(_ data : JSON) -> String
{
    if data != JSON.null
    {
        return data.description
    }
    else
    {
        return ""
    }
}

func boolFromStr(_ data: String) -> Bool {
    
    if (data == "1" || data == "true") {
        return true
    } else {
        return false
    }
}

func intFromJSON(_ data : JSON) -> Int
{
    if data != JSON.null
    {
        return intFromStr(data.description)
    }
    else
    {
        return 0
    }
}

func doubleFromJSON(_ data : JSON) -> Double
{
    if data != JSON.null
    {
        return doubleFromStr(data.description)
    }
    else
    {
        return 0
    }
}


func intFromStr(_ data : String) -> Int
{
    if let temp = Int(data)
    {
        return temp
    }
    else
    {
        return 0
    }
}

func doubleFromStr(_ data : String) -> Double
{
    if let temp = Double(data)
    {
        return temp
    }
    else
    {
        return 0
    }
}

func amountValue(_ str : String) -> String
{
   return "Rs." + str
}



