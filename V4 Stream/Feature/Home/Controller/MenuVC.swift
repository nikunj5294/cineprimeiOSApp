//
//  MenuVC.swift
//  V4 Stream
//
//  Created by kishan on 15/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var cnsMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cnstTableHeight: NSLayoutConstraint!
    @IBOutlet weak var imgLogout: UIImageView!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewDashboard: UIView!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    var selectedSectionIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if menu.list.count == 0 {
            self.APIMenuCategory()
        }
        self.lblName.text = kCurrentUser.name
        self.lblMobileNumber.text = kCurrentUser.phone
        
    }
    
    func navigateFromSideMenu(VC : UIViewController)
    {
//        if let nav =  self.sideMenuController?.contentViewController as? UINavigationController
//        {
        self.navigationController?.pushViewController(VC, animated: true)
       // }
    }
        
    @IBAction func btnProfileAction(_ sender: UIButton) {
        let resultVC : ProfileVC = Utilities.viewController(name: "ProfileVC", storyboard: "Settings") as! ProfileVC
        navigateFromSideMenu(VC : resultVC)
    }
    
    @IBAction func btnMenuOptionAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.navigationController?.popViewController(animated: false)
            break
        case 1:
            let resultVC : Profile2ViewController = Utilities.viewController(name: "Profile2ViewController", storyboard: "Settings") as! Profile2ViewController
            navigateFromSideMenu(VC : resultVC)
            break
        case 2:
            let resultVC: WatchlistVC = Utilities.viewController(name: "WatchlistVC", storyboard: "Home") as! WatchlistVC
            resultVC.watchlist = 1
            navigateFromSideMenu(VC : resultVC)
                break
        case 3:
            let resultVC : TransactionVC = Utilities.viewController(name: "TransactionVC", storyboard: "Settings") as! TransactionVC
            navigateFromSideMenu(VC : resultVC)
            break
        case 4:
            let resultVC : SubscripionPlanVC = Utilities.viewController(name: "SubscripionPlanVC", storyboard: "Settings") as! SubscripionPlanVC
            navigateFromSideMenu(VC : resultVC)
                break
        case 5:
                let resultVC : SettingsVC = Utilities.viewController(name: "SettingsVC", storyboard: "Settings") as! SettingsVC
                navigateFromSideMenu(VC : resultVC)
                break
            
        case 6:
                let resultVC : HelpViewController = Utilities.viewController(name: "HelpViewController", storyboard: "Home") as! HelpViewController
                navigateFromSideMenu(VC : resultVC)
                break
        case 7:
            let alert = UIAlertController(title: "CINEPRIME", message: "Are you sure you want to Logout?", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
                self.APILogout()
            }
            let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            alert.addAction(action1)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
            break
        default:
            print("ok")
        }
    }
}

extension MenuVC {
    
    func APIMenuCategory() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id] //144
        
        AlamofireModel.alamofireMethod(.post, apiAction: .menu_category, parameters: param, Header: header, handler: {res in
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            menu = Menu()
            menu.update(data)
            
        }, errorhandler: {error in
            
        })
    }
    
    func APILogout() {
    
        let uuid = UIDevice.current.identifierForVendor?.uuidString.lowercased()
        
        let param : [String:Any] = ["imei_number":uuid!]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .logout, parameters: param, Header: header, handler: {res in
            
            if res.success {
                
                kCurrentUser.logout()
                let resultVC : LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                self.navigateFromSideMenu(VC : resultVC)
                
            } else {
                AppInstance.showMessages(message: res.message)
            }
            
        }, errorhandler: {error in
            
        })
    }
    
}
