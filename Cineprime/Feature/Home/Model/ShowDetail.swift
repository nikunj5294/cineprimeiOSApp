//
//  SeriesDetail.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 14/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShowDetail {
    

    var show_id = ""
    var show_info = ""
    var check_plan = ""
    var imdb_rating = ""
    var related_shows = ""
    var show_lang = ""
    var show_name = ""
    var show_poster = ""
    var show_price = ""
    var show_video_access = ""
    var genre_list = [GenerData]()
    var season_list = [SeasonData]()
    
    
    func update(_ data: JSON) {
        
         check_plan = strFromJSON(data["check_plan"])
         imdb_rating = strFromJSON(data["imdb_rating"])
         related_shows = strFromJSON(data["related_shows"])
         show_id = strFromJSON(data["show_id"])
         show_info = strFromJSON(data["show_info"])
         show_lang = strFromJSON(data["show_lang"])
         show_name = strFromJSON(data["show_name"])
         show_poster = strFromJSON(data["show_poster"])
         show_price = strFromJSON(data["show_price"])
         show_video_access = strFromJSON(data["show_video_access"])
        
        for(_,obj) in data["genre_list"] {
            let temp = GenerData()
            temp.update(obj)
            self.genre_list.append(temp)
        }
        
        for(_,obj) in data["season_list"] {
            let temp = SeasonData()
            temp.update(obj)
            self.season_list.append(temp)
        }
    }
    
}

class SeasonData{
    var season_id = ""
    var season_name = ""
    var season_poster = ""
    
    func update(_ data: JSON) {
        season_id = strFromJSON(data["season_id"])
        season_name = strFromJSON(data["season_name"])
        season_poster = strFromJSON(data["season_poster"])
    }
}

class Episode {
    
    var list: [EpisodeData] = [EpisodeData]()
    
    func update(_ data: JSON) {
        for(_,obj) in data{
            let temp = EpisodeData()
            temp.update(obj)
            
            if !isRental(temp.video_access) {
                self.list.append(temp)
            }
            
        }
    }

}
class EpisodeData {
    
    var episode_id = ""
    var episode_title = ""
    var episode_image = ""
    var video_access = ""
    var description = ""
    var duration = ""
    var release_date = ""
    var imdb_rating = ""
    var video_type = ""
    var video_url = ""
    var lang_id = ""
    var language_name = ""
    var series_name = ""
    var season_name = ""
    var download_enable = ""
    var download_url = ""
    var check_plan = ""
    var rental_plan = ""
    var rental_price = ""

    
    var genre_list = [GenerData]()
    var resolutions = [ResolutionData]()
    
    func update(_ data: JSON) {
        
         episode_id = strFromJSON(data["episode_id"])
         episode_title = strFromJSON(data["episode_title"])
         episode_image = strFromJSON(data["episode_image"])
         video_access = strFromJSON(data["video_access"])
         description = strFromJSON(data["description"])
         duration = strFromJSON(data["duration"])
         release_date = strFromJSON(data["release_date"])
         imdb_rating = strFromJSON(data["imdb_rating"])
         video_type = strFromJSON(data["video_type"])
         video_url = strFromJSON(data["video_url"])
         lang_id = strFromJSON(data["lang_id"])
         language_name = strFromJSON(data["language_name"])
         series_name = strFromJSON(data["series_name"])
         season_name = strFromJSON(data["season_name"])
         download_enable = strFromJSON(data["download_enable"])
         download_url = strFromJSON(data["download_url"])
         check_plan = strFromJSON(data["check_plan"])
         rental_plan = strFromJSON(data["rental_plan"])
         rental_price = strFromJSON(data["rental_price"])

        
         for(_,obj) in data["genre_list"] {
            let temp = GenerData()
            temp.update(obj)
            self.genre_list.append(temp)
         }
        
        for(_,obj) in data["resolutions"] {
            let temp = ResolutionData()
            temp.update(obj)
            self.resolutions.append(temp)
        }
    }
}
