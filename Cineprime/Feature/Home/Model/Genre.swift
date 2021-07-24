//
//  Genre.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 12/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation

class GenreCategory {
    
    var list: [GenreCategoryData] = [GenreCategoryData]()
    
    func update(_ data: JSON) {
        
        for (_,obj) in data {
            let temp = GenreCategoryData()
            temp.update(obj)
            self.list.append(temp)
        }
    }
}

class GenreCategoryData {
    
    var genre_id = ""
    var genre_image = ""
    var genre_name = ""
    
    func update(_ data: JSON) {
        
        genre_id = strFromJSON(data["genre_id"])
        genre_image = strFromJSON(data["genre_image"])
        genre_name = strFromJSON(data["genre_name"])
    }
    
}
