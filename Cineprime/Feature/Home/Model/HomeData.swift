//
//  HomeData.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 19/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage

var homeData = HomeData()
let tempImage = UIImageView()
class HomeData
{
    var slider : [SliderData] = [SliderData]()
    var recently_watched : [RecentlyWatchData] = [RecentlyWatchData]()
    var dashboardData : [dashboard_data] = [dashboard_data]()

//    var latest_movies: [MovieData] = [MovieData]()
//    var latest_shows: [MovieData] = [MovieData]()
//    var popular_movies: [MovieData] = [MovieData]()
//    var popular_shows: [ShowData] = [ShowData]()
//    var homeSection: [HomeSectionData] = [HomeSectionData]()
//
//    var home_title2 = ""
//    var home_title3 = ""
//    var home_title4 = ""

    
//    func setSectionData(list: [MovieData], title: String) {
//        let temp1 = HomeSectionData()
//        temp1.title = title
//        temp1.type = "Movie"
//        temp1.list = list
//        self.homeSection.append(temp1)
//
//    }
    func update(_ data: JSON) {
        
//      home_title2 = strFromJSON(data["home_title2"])
//      home_title3 = strFromJSON(data["home_title3"])
//      home_title4 = strFromJSON(data["home_title4"])
        
        for(_,obj) in data["slider"] {
            let temp = SliderData()
            temp.update(obj)
            self.slider.append(temp)
        }
        
        for(_,obj) in data["recently_watched"] {
            let temp = RecentlyWatchData()
            temp.update(obj)
            self.recently_watched.append(temp)
        }

        for(_,obj) in data["dashboard_data"] {
            let temp = dashboard_data()
            temp.update(obj)
            if temp.category_id != ""
            {
                self.dashboardData.append(temp)
            }
        }
        
        print(self.dashboardData.count)
        
        
//        for(_,obj) in data["popular_shows"] {
//            let temp = ShowData()
//            temp.update(obj)
//            if !isRental(temp.video_access) {
//                self.popular_shows.append(temp)
//            }
//
//        }
        
        
//        for(_,obj) in data["latest_movies"] {
//            let temp = MovieData()
//            temp.update(obj)
//            if !isRental(temp.movie_access) {
//                self.latest_movies.append(temp)
//            }
//
//        }
        
       // setSectionData(list: self.latest_movies, title: "Trending")
        
//        for(_,obj) in data["latest_shows"] {
//            let temp = MovieData()
//            temp.update(obj)
//            if !isRental(temp.movie_access) {
//                self.latest_shows.append(temp)
//            }
//
//        }
        
//        setSectionData(list: self.latest_shows, title: home_title2)
        
//        for(_,obj) in data["popular_movies"] {
//            let temp = MovieData()
//            temp.update(obj)
//            if !isRental(temp.movie_access) {
//                self.popular_movies.append(temp)
//            }
//
//        }
        
//        setSectionData(list: self.popular_movies, title: home_title3)
        
//        for i in 0..<9  {
//
//            if data["home_sections\(i)"] != JSON.null {
//                let temp = HomeSectionData()
//                temp.update(data, number: i)
//                if temp.list.count > 0 {
//                    self.homeSection.append(temp)
//                }
//            }
//        }
        
        

        
    }
}

class dashboard_data {
    var title_name = ""
    var category_id = ""
    var is_landscape = ""
    var movie_array: [MovieData] = [MovieData]()
    
    func update(_ data: JSON) {
    
        if data["movie_array"].count != 0
        {
            title_name = strFromJSON(data["title_name"])
            category_id = strFromJSON(data["category_id"])
            is_landscape = strFromJSON(data["is_landscape"])
            
            for(_,obj) in data["movie_array"] {
                let temp = MovieData()
                temp.update(obj)
                self.movie_array.append(temp)
            }
        }else
        {
            return
        }
    }

    
//    func update(_ data: JSON) {
        
//        title_name = strFromJSON(data["dashboard_data"])
//        lang_id = strFromJSON(data["home_sections\(number)_lang_id"])
//        title = strFromJSON(data["home_sections\(number)_title"])
//        type = strFromJSON(data["home_sections\(number)_type"])
        
//        for(_,obj) in data["home_sections\(number)"] {
//            let temp = MovieData()
//            temp.update(obj)
//            if !isRental(temp.movie_access) {
//                list.append(temp)
//            }
//
//        }
//    }
}

class RecentlyWatchData {
    
    var video_id = ""
    var video_thumb_image = ""
    var video_type = ""
    
    
    func update(_ data: JSON) {
        video_id = strFromJSON(data["video_id"])
        video_thumb_image = strFromJSON(data["video_thumb_image"])
        video_type = strFromJSON(data["video_type"])
    }
    
}

class MovieData {
    
    var movie_id = ""
    var movie_title = ""
    var movie_poster = ""
    var movie_access = ""
    var movie_duration = ""
    var movie_type = ""
    
    
    func update(_ data: JSON) {
        movie_id = strFromJSON(data["movie_id"])
        movie_type = strFromJSON(data["movie_type"])
        movie_title = strFromJSON(data["movie_title"])
        movie_poster = strFromJSON(data["movie_poster"])
        movie_access = strFromJSON(data["movie_access"])
        movie_duration = strFromJSON(data["movie_duration"])
        
        
//        if movie_title == "" && (strFromJSON(data["movi_title"]) != "") {
//            movie_title = strFromJSON(data["movi_title"])
//        }
        
//        if movie_id == "" && (strFromJSON(data["movie_videos_id"]) != "") {
//            movie_id = strFromJSON(data["movie_videos_id"])
//        }
        
        
//        if movie_duration == "" && (strFromJSON(data["duration"]) != "") {
//            movie_duration = strFromJSON(data["duration"])
//        }
        //This logic is to preload images
        //tempImage.sd_setImage(with: URL(string: movie_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
    }
}


class SliderData {
    var slider_post_id = ""
    var slider_title = ""
    var slider_image = ""
    var slider_type = ""
    var slider_video_url = ""
    
    func update(_ data: JSON) {
        slider_post_id = strFromJSON(data["slider_post_id"])
        slider_title = strFromJSON(data["slider_title"])
        slider_image = strFromJSON(data["slider_image"])
        slider_type = strFromJSON(data["slider_type"])
        slider_video_url = strFromJSON(data["slider_video_url"])

        //This logic is to preload images
        //tempImage.sd_setImage(with: URL(string: slider_image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
    }
}

//class ShowData {
//    var show_id = ""
//    var show_poster = ""
//    var show_title = ""
//    var video_access = ""
//
//    func update(_ data: JSON) {
//        show_id = strFromJSON(data["show_id"])
//        show_poster = strFromJSON(data["show_poster"])
//        show_title = strFromJSON(data["show_title"])
//        video_access = strFromJSON(data["video_access"])
//
//        //This logic is to preload images
//        //tempImage.sd_setImage(with: URL(string: show_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
//    }
//}

func isRental(_ access: String) -> Bool {
    
    if access.lowercased() == "rental" {
        return true
    }
    
    return false
}
