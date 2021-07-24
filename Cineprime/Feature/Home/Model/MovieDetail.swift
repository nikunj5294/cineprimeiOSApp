//
//  MovieData.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 31/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieDetail {
    
    var movie_share_url = ""
    var movie_title = ""
    var movie_image = ""
    var movie_access = ""
    var movie_duration = ""
    var movie_id = ""
    var description = ""
    var release_date = ""
    var rental_plan = ""
    var imdb_rating = ""
    var lang_id = ""
    var language_name = ""
    var trailer_url = ""
    var video_type = ""
    var video_url = ""
    var rent_expire_on = ""
    var download_url = ""
    var download_enable = ""
    var related_movies = [MovieData]()
    var genre_list = [GenerData]()
    var movie_language_list = [LanguageData]()
    var videos = [VideoData]()
    var move_resolution = [ResolutionData]()
    var Movie_cast = [Moviewcast]()
    var check_plan = ""
    var is_available = ""
    var premium = ""
    var rental = ""
    var status_code = ""
    var user_plan_status = ""
    
    func update(_ data: JSON) {
        
        
         let json = data["VIDEO_STREAMING_APP"]

         movie_id = strFromJSON(json["movie_id"])
         movie_share_url = strFromJSON(json["movie_share_url"])
         movie_title = strFromJSON(json["movie_title"])
         movie_image = strFromJSON(json["movie_image"])
         movie_access = strFromJSON(json["movie_access"])
         movie_duration = strFromJSON(json["movie_duration"])
         description = strFromJSON(json["description"])
         release_date = strFromJSON(json["release_date"])
         rental_plan = strFromJSON(json["rental_plan"])
         imdb_rating = strFromJSON(json["imdb_rating"])
         lang_id = strFromJSON(json["lang_id"])
         language_name = strFromJSON(json["language_name"])
         trailer_url = strFromJSON(json["trailer_url"])
         video_type = strFromJSON(json["video_type"])
         video_url = strFromJSON(json["video_url"])
         rent_expire_on = strFromJSON(json["rent_expire_on"])
         download_url = strFromJSON(json["download_url"])
         download_enable = strFromJSON(json["download_enable"])
        
        for(_,obj) in json["related_movies"] {
             let temp = MovieData()
             temp.update(obj)
             self.related_movies.append(temp)
        }
        
        for(_,obj) in json["genre_list"] {
            let temp = GenerData()
            temp.update(obj)
            self.genre_list.append(temp)
        }
        
        for(_,obj) in json["movie_language_list"] {
            let temp = LanguageData()
            temp.update(obj)
            self.movie_language_list.append(temp)
        }
        
        for(_,obj) in json["videos"] {
            let temp = VideoData()
            temp.update(obj)
            self.videos.append(temp)
        }
        
        for(_,obj) in json["move_resolution"] {
            let temp = ResolutionData()
            temp.update(obj)
            self.move_resolution.append(temp)
        }
        
        for(_,obj) in json["movie_cast"] {
            let temp = Moviewcast()
            temp.update(obj)
            self.Movie_cast.append(temp)
        }
        
        
        
        check_plan = strFromJSON(data["check_plan"])
        is_available = strFromJSON(data["is_available"])
        premium = strFromJSON(data["premium"])
        rental = strFromJSON(data["rental"])
        status_code = strFromJSON(data["status_code"])
        user_plan_status = strFromJSON(data["user_plan_status"])
        
        if rent_expire_on == "" && strFromJSON(data["rent_expire_on"]) != "" {
            rent_expire_on = strFromJSON(data["rent_expire_on"])
        }
        
        
    }
}

class GenerData {
    
    var genre_id = ""
    var genre_name = ""
    
    func update(_ data: JSON) {
        genre_id = strFromJSON(data["genre_id"])
        genre_name = strFromJSON(data["genre_name"])
    }
}

class LanguageData {
    var movie_audio_url = ""
    var movie_id = ""
    var movie_language = ""
    
    func update(_ data: JSON) {
        movie_audio_url = strFromJSON(data["movie_audio_url"])
        movie_id = strFromJSON(data["movie_id"])
        movie_language = strFromJSON(data["movie_language"])
    }
}

class VideoData {
    var language = ""
    var url = ""
    
    func update(_ data: JSON) {
        language = strFromJSON(data["language"])
        url = strFromJSON(data["url"])
    }
}

class ResolutionData {
    var movie_id = ""
    var movie_resolution = ""
    var movie_url = ""
    
    func update(_ data: JSON) {
        movie_id = strFromJSON(data["movie_id"])
        movie_resolution = strFromJSON(data["movie_resolution"])
        movie_url = strFromJSON(data["movie_url"])
    }
    
}

class Moviewcast {
    var name = ""
    var type = ""
    var image = ""
    
    func update(_ data: JSON) {
        name = strFromJSON(data["name"])
        type = strFromJSON(data["type"])
        image = strFromJSON(data["image"])
    }
    
}


class MoviesList {
     var list = [MovieData]()

    func update(_ data: JSON) {
         for(_,obj) in data {
             let temp = MovieData()
             temp.update(obj)

            if !isRental(temp.movie_access) {
                self.list.append(temp)
            }

        }
    }
}

class ShowsList {
//     var list = [ShowData]()
//
//    func update(_ data: JSON) {
//         for(_,obj) in data {
//             let temp = ShowData()
//             temp.update(obj)
//            if !isRental(temp.video_access) {
//                self.list.append(temp)
//            }
//
//        }
//    }
}
