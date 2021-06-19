//
//  Alamofire.swift
//
//

import Foundation
@_exported import Alamofire
@_exported import SwiftyJSON

enum Environment: String {
    
   // case Dev = "http://65.0.4.118/rush_films/public/index.php/api/v1/"
//    case Dev = "http://65.0.4.118/moviesy/public/index.php/api/v1/"//"http://grovegies.com/videostreaming/api/v1/"
    case Dev = "http://65.1.163.3/api/v1/"//"http://grovegies.com/videostreaming/api/v1/"
    case Prod = "https://unratified-card.000webhostapp.com/index.php/"
    
} 

//API Environment set up
let apiEnvironment : Environment = .Dev
// Base Api URL
var baseURL: String = apiEnvironment.rawValue


var header: [String:String] = [:]
typealias reachability = (_ isReachable: Bool) -> Void

enum APIAction : String
{
    case login = "login2"
    case logout = "logout2"
    case signup = "signup"
    case facebook = "facebook"
    case app_details = "app_details1"
    case home = "dynamic_home_screen"//Parameters (user_id)
    case save_to_watchlist = "save-to-watchlist" //"saveToWatchlist" //
    case remove_watchlist_video = "remove-watchlist-video" //"removeWishlistVideo" //
    case c_watchlist_add = "c_watchlist_add"
    case c_watchlist_get = "c_watchlist_get"
    case get_watchlist = "get_watchlist"
    case movies_details1 = "movies_details1"
    case show_details = "show_details"
    case episode1 = "episodes1"
    case dashboard = "dashboard"
    case ios_v_chek = "ios_v_chek"
    case profile = "profile"
    case profile_update = "profile_update" //user_id,name,email,phone,user_address,password,user_image
    case subscription_plan = "subscription_plan"
    case rental_plan = "rental_plan" //movie_id,show_id,
    case vetifyOTP = "vetifyOTP" //phone,otp
    case forgot_password = "forgot_password" //phone
    case get_transaction_list = "get_transaction_list"
    case menu_category = "menu_category"
    case movies_by_language = "movies_by_language"
    case languages = "languages"
    case movielike = "movie_like"
    case settings = "settings"
    case moviedislike = "movie_dislike"
    case movielikecount = "movie_like_count"
    case search = "search"
    case genres = "genres"
    case movies_by_genre = "movies_by_genre"
    case shows_by_language = "shows_by_language"
    case shows_by_genre = "shows_by_genre"
    case movies_by_category = "movies_by_category"
    case shows_by_category = "series_by_category"
    case livetv  = "livetv"
    case livetv_by_category = "livetv_by_category" //"category_id":"2",filter:"new"
    case livetv_category = "livetv_category"
    case livetv_details  = "livetv_details"
    case movies_by_upcoming = "movies_by_upcoming"
    case latest_movies = "latest_movies"
    case latest_shows = "latest_shows"
    case popular_shows = "popular_shows"
    case popular_movies = "popular_movies"
    case bestv4_stream = "bestv4_stream"
    case homepopular_shows = "homepopular_shows"
    case popular_documentary = "popular_documentary"
    case transaction_add = "transaction_add"
    case check_promocode = "check_promocode"
    case check_user_plan = "check_user_plan"
    case verify_inapp = "in_app_purchase"
    case show_all = "show_all"
//    case login = "login"
//    case signup = "signup"
//    case app_details = "app_details1"
//    case home = "dynamic_home1"
//    case save_to_watchlist = "save-to-watchlist" //"saveToWatchlist" //
//    case remove_watchlist_video = "remove-watchlist-video" //"removeWishlistVideo" //
//    case get_watchlist = "get_watchlist"
//    case movies_details1 = "movies_details1"
//    case show_details = "show_details"
//    case episode1 = "episodes1"
//    case dashboard = "dashboard"
//    case profile = "profile"
//    case profile_update = "profile_update" //user_id,name,email,phone,user_address,password,user_image
//    case subscription_plan = "subscription_plan"
//    case rental_plan = "rental_plan" //movie_id,show_id,
//    case vetifyOTP = "vetifyOTP" //phone,otp
//    case forgot_password = "forgot_password" //phone
//    case get_transaction_list = "get_transaction_list"
//    case menu_category = "menu_category"
//    case movies_by_language = "movies_by_language"
//    case languages = "languages"
//
//    case search = "search"
//    case genres = "genres"
//    case movies_by_genre = "movies_by_genre"
//    case shows_by_language = "shows_by_language"
//    case shows_by_genre = "shows_by_genre"
//    case movies_by_category = "movies_by_category"
//    case shows_by_category = "series_by_category"
//    case livetv  = "livetv"
//    case livetv_by_category = "livetv_by_category" //"category_id":"2",filter:"new"
//    case livetv_category = "livetv_category"
//    case livetv_details  = "livetv_details"
//
//    case latest_movies = "latest_movies"
//    case latest_shows = "latest_shows"
//    case popular_shows = "popular_shows"
//    case popular_movies = "popular_movies"
//    case bestv4_stream = "bestv4_stream"
//    case homepopular_shows = "homepopular_shows"
//    case popular_documentary = "popular_documentary"
//    case transaction_add = "transaction_add"
//    case check_promocode = "check_promocode"
//    case check_user_plan = "check_user_plan"
//    case verify_inapp = "in_app_purchase"
}

class AlamofireResponse
{
    var success: Bool = true
    var code: Int = 200
    var json: JSON = JSON()
    var originalJSON: JSON = JSON()
    var message: String = ""
    
    init(success: Bool, code: Int, json: JSON, originalJSON: JSON, message: String)
    {
        self.success = success
        self.code = code
        self.json = json
        self.message = message
        self.originalJSON = originalJSON
    }
}

class AlamofireModel: NSObject
{
    
    typealias CompletionHandler = (_ response:AlamofireResponse) -> Void
    typealias ErrorHandler = (_ error : Error) -> Void
    
    class func alamofireMethod(_ method: Alamofire.HTTPMethod, apiAction: APIAction, parameters : [String : Any], Header: [String: String], is64Bit: Bool = true, tryAgainOnFail : Bool = false, isLoader: Bool = true, handler:@escaping CompletionHandler, errorhandler : @escaping ErrorHandler)
    {
        var header = Header
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
        
        reachabilityManager?.startListening()
        
        if let r = reachabilityManager
        {
            switch r.isReachable
            {
            case false:
                
                if tryAgainOnFail
                {
                    let alert = UIAlertController(title: "Alert", message: "No Network", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Retry", style: .default, handler: {_ in
                        
                        alamofireMethod(method, apiAction: apiAction, parameters: parameters, Header: header,tryAgainOnFail: tryAgainOnFail, handler: handler, errorhandler: errorhandler)
                        
                    })
                    
                    alert.addAction(action)
                    
                    AppInstance.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                 AppInstance.showMessages(message: "No Network")
                    errorhandler(NSError(domain: "No Network", code: 0, userInfo: nil))
                }
                
            case true:
                print("reachable")
                
                //Not reachable
                var alamofireManager : Alamofire.SessionManager?
                
                var UrlFinal = ""
                do
                {
                    try UrlFinal = baseURL + apiAction.rawValue.asURL().absoluteString
                }catch{}
                
                alamofireManager = Alamofire.SessionManager.default
                alamofireManager?.session.configuration.timeoutIntervalForRequest = 31
                alamofireManager?.session.configuration.timeoutIntervalForResource = 31
                
                var params = parameters
                params["salt"] = "892"//668
                params["sign"] = "12819186c8a146c25c8afe3bbd270c3e"//"438fc9439609f14de992f13696139c6a"
                params["user_id"] = kCurrentUser.user_id //"163"//
                
                print("Parameter Decript:",params)
                var param = [String:Any]()
                if params["is_facebook"]as? String != nil
                {
                    param = params
                }
                else
                {
                    if is64Bit {
                        let data = try! JSONSerialization.data(withJSONObject: params)
                        let base64Representation = data.base64EncodedString()
                        param = ["data": base64Representation]
                    } else {
                        param = params
                    }
                }

                if Tagss == 1
                {
                    param = parameters
                                 
                }
                

                print("Request Log ---------------------------------------------------------")
                print("URL:",UrlFinal)
                print("HEADER:",header)
                print("Parameter:",param)
                print("---------------------------------------------------------End")
                
                
                if isLoader
                {
                    AppInstance.showLoader()
                }
                

                alamofireManager?.request(UrlFinal, method: method, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
                    
                    print("Response Log ---------------------------------------------------------")
                    print("URL:",UrlFinal)
                    print("HEADER:",header)
                    print("Parameter:",param)
                    print("---------------------------------------------------------End")
                    print("RESPONSE org : ",response)
                    if isLoader
                    {
                        AppInstance.hideLoader()
                    }
                    
                    
                    if response.response?.statusCode == 401
                    {
                        //kCurrentUser.logout()
                        //AppInstance.goToLoginScreenPage(transition: true)
                        AppInstance.showMessages(message: "Session Expired!!")
                    }
                    
                    if response.result.isSuccess
                    {
                        if let val = response.result.value
                        {
                            
                            let json : JSON = JSON(val)
                            var data = json["VIDEO_STREAMING_APP"]
                            if json["VIDEO_STREAMING_APP"][0] != JSON.null
                            {
                                data = json["VIDEO_STREAMING_APP"][0]
                            }
                            handler(AlamofireResponse(success: (intFromJSON(data["success"]) == 1), code: intFromJSON(json["status_code"]), json: data,originalJSON: json, message: strFromJSON(data["msg"])))
                        }
                    }
                    else
                    {
                        if response.result.error != nil
                        {
                            let error = response.result.error!
                            
                            if tryAgainOnFail
                            {
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "Retry", style: .default, handler: {_ in
                                    
                                    alamofireMethod(method, apiAction: apiAction, parameters: parameters, Header: header,tryAgainOnFail : tryAgainOnFail, handler: handler, errorhandler: errorhandler)
                                    
                                })
                                
                                alert.addAction(action)
                                
                                AppInstance.window?.rootViewController?.present(alert, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                errorhandler(error)
                            }
                            
                        }
                    }
                })
            }
        }
    }
    
    class func alamofireMethodWithImages(_ method: Alamofire.HTTPMethod, apiAction: APIAction, parameters : [String : Any], Header: [String: String], images : [String : UIImage], handler:@escaping CompletionHandler, errorhandler : @escaping ErrorHandler)
    {
        
        var header = Header
        header["Connection"] = "Close"
        
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
        
        reachabilityManager?.startListening()
        
        if let r = reachabilityManager
        {
            switch r.isReachable
            {
            case false:
                
                errorhandler(NSError(domain: "No Network", code: 0, userInfo: nil))
                
            case true:
                print("reachable")
                
                //Not reachable
                var alamofireManager : Alamofire.SessionManager?
                
                var UrlFinal = ""
                do
                {
                    try UrlFinal = baseURL + apiAction.rawValue.asURL().absoluteString
                }catch{}
                
                alamofireManager = Alamofire.SessionManager.default
                alamofireManager?.session.configuration.timeoutIntervalForRequest = 31
                alamofireManager?.session.configuration.timeoutIntervalForResource = 31
                
                var params = parameters
                params["salt"] = 668
                params["sign"] = "438fc9439609f14de992f13696139c6a"
                params["user_id"] = kCurrentUser.user_id 
                
                let data = try! JSONSerialization.data(withJSONObject: params)
                let base64Representation = data.base64EncodedString()
                let param = ["data": base64Representation]

                print("Request Log ---------------------------------------------------------")
                print("URL:",UrlFinal)
                print("HEADER:",header)
                print("REQUEST Parameter:",parameters)
                print("Encoded Parameter:",param)
                print("---------------------------------------------------------End")
                
                AppInstance.showLoader()
                alamofireManager?.upload(multipartFormData: { (multipartFormData) in
                    
                    
                    for (key,value) in param
                    {
                        multipartFormData.append("\(value)".data(using: .utf8)! , withName: key)
                    }
                    
                    for (key,value) in images
                    {
                        
                        if let data = value.jpegData(compressionQuality: 1)
                        {
                            multipartFormData.append(data, withName: key, fileName: key + ".png", mimeType: "image/png")
                        }
                    }
                    
                }, to: UrlFinal, method : method, headers : header, encodingCompletion: { (encodingResult) in
                    
                    //AppInstance.hideLoader()
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON(completionHandler: { (response) in
                            
                            
                            print("RESPONSE org : ",response)
                             AppInstance.hideLoader()
                            
                            
                            if response.response?.statusCode == 401
                            {
                                //kCurrentUser.logout()
                                //AppInstance.goToLoginScreenPage(transition: true)
                                AppInstance.showMessages(message: "Session Expired!!")
                            }
                            
                            if response.result.isSuccess
                            {
                                if let val = response.result.value
                                {
                                    
                                    let json : JSON = JSON(val)
                                    var data = json["VIDEO_STREAMING_APP"]
                                    if json["VIDEO_STREAMING_APP"][0] != JSON.null
                                    {
                                        data = json["VIDEO_STREAMING_APP"][0]
                                    }
                                    handler(AlamofireResponse(success: (intFromJSON(data["success"]) == 1), code: intFromJSON(json["status_code"]), json: data,originalJSON: json, message: strFromJSON(data["msg"])))
                                }
                            }
                            else
                            {
                                if response.result.error != nil
                                {
                                    let error = response.result.error!
                                    errorhandler(error)
                                    
                                }
                            }
                            
                            
                        })
                        
                    case .failure(let encodingError):
                        AppInstance.hideLoader()
                        errorhandler(encodingError )
                    }
                    
                })
                
                
            }
        }
    }
    
    class func reachabilityCheck( maxRetries: Int = 3, isRecheable: @escaping reachability)
    {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
        
        reachabilityManager?.startListening()
        
        if let r = reachabilityManager
        {
            switch r.isReachable
            {
            case false:
                print("unreachable, retry no. -> " + (abs(maxRetries - 3)).description)
                if maxRetries == 0
                {
                    isRecheable(false)
                }
                else
                {
                    usleep(10000) // = 0.01 seconds
                    reachabilityCheck(maxRetries: (maxRetries-1), isRecheable: isRecheable)
                }
            case true:
                
                isRecheable(true)
            }
        }
    }
}



