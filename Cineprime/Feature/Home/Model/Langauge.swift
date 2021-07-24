//
//  Langauge.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 11/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class LangaugeCategory {
    
    var list: [LangauguageCategoryData] = [LangauguageCategoryData]()
    
    func update(_ data: JSON) {
        
        for (_,obj) in data {
            let temp = LangauguageCategoryData()
            temp.update(obj)
            self.list.append(temp)
        }
    }
}

class LangauguageCategoryData {
    
    var language_id = ""
    var language_image = ""
    var language_name = ""
    
    func update(_ data: JSON) {
        
        language_id = strFromJSON(data["language_id"])
        language_image = strFromJSON(data["language_image"])
        language_name = strFromJSON(data["language_name"])
    }
    
}
