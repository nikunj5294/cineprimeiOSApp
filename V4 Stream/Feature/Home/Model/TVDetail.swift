//
//  TVDetail.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 01/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class TVList {
    
    var list: [TVListData] = [TVListData]()
    
    func update(_ data: JSON) {
        for (_, obj) in data {
            let temp = TVListData()
            temp.update(obj)
            list.append(temp)
        }
    }
    
}


class TVListData {
    
    var tv_id = ""
    var tv_title = ""
    var tv_logo = ""
    var tv_access = ""
    
    func update(_ data: JSON) {
         tv_id = strFromJSON(data["movie_id"])
         tv_title = strFromJSON(data["movie_title"])
         tv_logo = Utilities.addPercentageEncodingInURLPath(strFromJSON(data["movie_poster"]))
         tv_access = strFromJSON(data["movie_access"])
    }
}

class TVDetail {
    
    var category_name = ""
    var description = ""
    var tv_access = ""
    var tv_cat_id = ""
    var tv_id = ""
    var tv_logo = ""
    var tv_title = ""
    var tv_url = ""
    var tv_url_type = ""
    var related_live_tv: [TVListData] = [TVListData]()
    
    func update(_ data: JSON) {
         category_name = strFromJSON(data["category_name"])
         description = strFromJSON(data["movie_duration"])
         tv_access = strFromJSON(data["movie_access"])
         tv_cat_id = strFromJSON(data["tv_cat_id"])
         tv_id = strFromJSON(data["movie_id"])
         tv_logo = strFromJSON(data["tv_logo"])
         tv_title = strFromJSON(data["movie_title"])
         tv_url = strFromJSON(data["tv_url"])
         tv_url_type = strFromJSON(data["tv_url_type"])
        
        for (_, obj) in data["VIDEO_STREAMING_APP"] {
            let temp = TVListData()
            temp.update(obj)
            
        }
    }
    
}

class CategoryList {
    var list : [CategoryListData] = [CategoryListData]()
    
    func update(_ data: JSON) {
        
        for(_,obj) in data {
            let temp = CategoryListData()
            temp.update(obj)
            list.append(temp)
        }
    }
}
class CategoryListData {
    
    var category_id = ""
    var category_name = ""
    
    func update(_ data: JSON) {
         category_id = strFromJSON(data["category_id"])
         category_name = strFromJSON(data["category_name"])
    }
}
