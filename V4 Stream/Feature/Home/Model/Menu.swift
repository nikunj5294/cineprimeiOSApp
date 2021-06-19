//
//  Menu.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 08/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

var menu = Menu()
class Menu {
    
    var list: [MenuCategory] = [MenuCategory]()
    
    func update(_ data: JSON) {
        for(_,obj) in data["category"] {
            let temp = MenuCategory()
            temp.update(obj)
            list.append(temp)
        }
    }
}

class MenuCategory {
    var category_id = ""
    var category_name = ""
    var list: [MenuSubCategory] = [MenuSubCategory]()
    
    func update(_ data: JSON) {
        category_id = strFromJSON(data["category_id"])
        category_name = strFromJSON(data["category_name"])
        for(_,obj) in data["subcategory"] {
            let temp = MenuSubCategory()
            temp.update(obj)
            list.append(temp)
        }
    }
}

class MenuSubCategory {
    
    var id = ""
    var category_id = ""
    var subcategory_name = ""
    var subcategory_image = ""
    var subcategory_slug = ""
    var status = ""

    func update(_ data: JSON) {
        id = strFromJSON(data["id"])
        category_id = strFromJSON(data["category_id"])
        subcategory_name = strFromJSON(data["subcategory_name"])
        subcategory_image = strFromJSON(data["subcategory_image"])
        subcategory_slug = strFromJSON(data["subcategory_slug"])
        status = strFromJSON(data["status"])
    }
}

/*
 (
                 {
         "category_id" = 4;
         "category_name" = Movie;
         subcategory =                 (
                                 {
                 "category_id" = 4;
                 id = 15;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Kannada;
                 "subcategory_slug" = kannada;
             },
                                 {
                 "category_id" = 4;
                 id = 16;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Hindi;
                 "subcategory_slug" = hindi;
             },
                                 {
                 "category_id" = 4;
                 id = 18;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Tulu;
                 "subcategory_slug" = tulu;
             },
                                 {
                 "category_id" = 4;
                 id = 21;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = English;
                 "subcategory_slug" = english;
             },
                                 {
                 "category_id" = 4;
                 id = 28;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Tamil;
                 "subcategory_slug" = tamil;
             }
         );
     },
                 {
         "category_id" = 5;
         "category_name" = Sports;
         subcategory =                 (
                                 {
                 "category_id" = 5;
                 id = 17;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Cricket;
                 "subcategory_slug" = cricket;
             },
                                 {
                 "category_id" = 5;
                 id = 19;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Football;
                 "subcategory_slug" = football;
             },
                                 {
                 "category_id" = 5;
                 id = 20;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Kabaddi;
                 "subcategory_slug" = kabaddi;
             }
         );
     },
                 {
         "category_id" = 6;
         "category_name" = News;
         subcategory =                 (
         );
     },
                 {
         "category_id" = 7;
         "category_name" = Premium;
         subcategory =                 (
                                 {
                 "category_id" = 7;
                 id = 29;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Movies;
                 "subcategory_slug" = movies;
             },
                                 {
                 "category_id" = 7;
                 id = 30;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = "Web Series";
                 "subcategory_slug" = "web-series";
             }
         );
     },
                 {
         "category_id" = 24;
         "category_name" = "Web Series";
         subcategory =                 (
                                 {
                 "category_id" = 24;
                 id = 25;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Kannada;
                 "subcategory_slug" = kannada;
             },
                                 {
                 "category_id" = 24;
                 id = 26;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Hindi;
                 "subcategory_slug" = hindi;
             },
                                 {
                 "category_id" = 24;
                 id = 27;
                 status = 1;
                 "subcategory_image" = "<null>";
                 "subcategory_name" = Tulu;
                 "subcategory_slug" = tulu;
             }
         );
     }
 )
 */
