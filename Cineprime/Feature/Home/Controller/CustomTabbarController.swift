//
//  CustomTabbarController.swift
//  V4 Stream
//
//  Created by Dimple Panchal on 12/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON

var HomeStorybord = (UIStoryboard(name: "Home", bundle: nil))


//Home Moview Premium Series More
class CustomTabbarController: UIViewController {
    
    @IBOutlet var btnHome: UIButton!
    @IBOutlet var btnMovie: UIButton!
    @IBOutlet var btnPremium: UIButton!
    @IBOutlet var btnSeries: UIButton!
    @IBOutlet var btnMore: UIButton!
    
    @IBOutlet var imgHome: UIImageView!
    @IBOutlet var imgMovie: UIImageView!
    @IBOutlet var imgPremium: UIImageView!
    @IBOutlet var imgSeries: UIImageView!
    @IBOutlet var imgMore: UIImageView!
    
    @IBOutlet var viewHome: UIView!
    @IBOutlet var viewMovie: UIView!
    @IBOutlet var viewPremium: UIView!
    @IBOutlet var viewSeries: UIView!
    @IBOutlet var viewMore: UIView!
    
    private var btnSelected: UIButton?
    private var imgselected: UIImage?
    private var imgdeselected: UIImage?

    @IBOutlet var lblHome: UILabel!
    @IBOutlet var lblMovie: UILabel!
    @IBOutlet var lblPremium: UILabel!
    @IBOutlet var lblSeries: UILabel!
    @IBOutlet var lblMore: UILabel!
    
    private var HomeController: UINavigationController?
    private var MovieController: UINavigationController?
    private var PremiumController: UINavigationController?
    private var SeriesController: UINavigationController?
    private var MoreController: UINavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectHome), name: Notification.Name("selectdHomeTab"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    @objc func selectHome(){
        let resultVC: HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
        resultVC.isMovieIDNotification = true
        let nav = UINavigationController(rootViewController: resultVC)
        nav.navigationBar.isHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nav
    }

    @IBAction func btnTabClick(_ sender: Any) {
        let btn = sender as? UIButton
//        btn?.isSelected = true
//        if btnSelected != btn {
//            btnSelected = btn
//        }
        
        if btn?.isEqual(btnHome) ?? false {
            let resultVC: HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
            let nav = UINavigationController(rootViewController: resultVC)
            nav.navigationBar.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nav
        }
        else if btn?.isEqual(btnMovie) ?? false {
            let resultVC: TVDetailVC = Utilities.viewController(name: "TVDetailVC", storyboard: "Home") as! TVDetailVC
            let nav = UINavigationController(rootViewController: resultVC)
            nav.navigationBar.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nav
            
        }
        else if btn?.isEqual(btnSeries) ?? false {
           let resultVC: WatchlistVC = Utilities.viewController(name: "WatchlistVC", storyboard: "Home") as! WatchlistVC
            let nav = UINavigationController(rootViewController: resultVC)
            nav.navigationBar.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nav
            
        }
        else if btn?.isEqual(btnPremium) ?? false {
                    }
        else if btn?.isEqual(btnMore) ?? false {
            DispatchQueue.main.async {
                let resultVC: OfflinevideoViewController = Utilities.viewController(name: "OfflinevideoViewController", storyboard: "Home") as! OfflinevideoViewController
                let nav = UINavigationController(rootViewController: resultVC)
                nav.navigationBar.isHidden = true
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = nav
            }
        }
    }
    
}
