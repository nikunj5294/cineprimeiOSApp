//
//  SplashVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 19/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var imgMain: UIImageView!
    var isSplashLoad: Bool = false
    var isAppDetailLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.imgMain.image = UIImage.gifImageWithName("splash")
        self.imgMain.image = UIImage.init(named: "logoBlack")
        User().sharedInstance.loadFromDefault()
        self.APIAppDetails()
        if kCurrentUser.user_id != "" {
            self.APIHome()
        }
        
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                AppInstance.showAlertForScreenCapture()
            }
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.isSplashLoad = true
//            self.navigate()
//        }

    }
    
    func navigate() {
        
        if self.isSplashLoad && self.isAppDetailLoad && !UIScreen.main.isCaptured {
            RemoveUnAvailableData()
            if kCurrentUser.user_id != "" {
                AppInstance.goToHomeVC()
            }else{
                let resultVC : LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
    func RemoveUnAvailableData() {
        if let data = UserDefaults.standard.object(forKey: OfflineDownload_KEY) as? [[String:Any]]{
            if data.count > 0{
                var downloadData = [[String:Any]]()
                for i in 0...data.count-1{
                    if let isDownload = data[i][isDownloadComplete_Key] as? Bool{
                        if isDownload{
                            downloadData.append(data[i])
                        }else{
                            let fileManager = FileManager.default
                            do {
                                try fileManager.removeItem(atPath: "\(data[i][MovieFileName_Key] as? String ?? "")")
                                print("Local path removed successfully")
                            } catch let error as NSError {
                                print("------Error",error.debugDescription)
                            }
                        }
                    }
                }
                if downloadData.count > 0{
                    UserDefaults.standard.setValue(downloadData, forKey: OfflineDownload_KEY)
                }else{
                    UserDefaults.standard.removeObject(forKey: OfflineDownload_KEY)
                }
            }else{
                UserDefaults.standard.removeObject(forKey: OfflineDownload_KEY)
            }
        }
    }
    
}

extension SplashVC {
    
    func APIHome() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .home, parameters: param, Header: header,isLoader: false, handler: {res in
            
            homeData = HomeData()
            homeData.update(res.json)
            
        }, errorhandler: {error in
            
        })
    }
    
    func APIAppDetails() {
        
        let param: [String:Any] = ["app_version":1]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .app_details, parameters: param, Header: header, tryAgainOnFail: true, isLoader: false, handler: {res in
            
            if res.success {
                appDetail = AppDetail()
                appDetail.update(res.json)
                self.isAppDetailLoad = true
                self.isSplashLoad = true
                self.navigate()
            }

        }, errorhandler: {error in
            
        })
    }
}
