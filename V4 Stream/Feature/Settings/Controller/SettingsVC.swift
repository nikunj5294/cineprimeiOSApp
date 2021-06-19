//
//  SettingsVC.swift
//  V4 Stream
//
//  Created by kishan on 14/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
//    var settingsOption = ["Enable Push Notification","Production and Collaboration","Privacy Policy","Terms & Conditions","Refund Policy"]
    var settingsOption = ["Enable Push Notification","Privacy Policy","Terms & Conditions","Refund Policy"]

    var dictdata = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.APISetting()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SettingsTBLCell = tableView.dequeueReusableCell(withIdentifier: "SettingsTBLCell", for: indexPath) as! SettingsTBLCell
        
        cell.stcEnableOrNotPushNotification.isHidden = true
        cell.lblSettingsOption.text? = settingsOption[indexPath.row]
        
        if indexPath.row == 0
        {
            cell.stcEnableOrNotPushNotification.isHidden = false
        }
        else
        {
            cell.stcEnableOrNotPushNotification.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
//        if indexPath.row == 1
//        {
//            let resultVC : WebLinkVC = Utilities.viewController(name: "WebLinkVC", storyboard: "Settings") as! WebLinkVC
//            resultVC.titleStr = "Production and Collaboration"
//            resultVC.link = ""//self.dictdata["app_about"]as? String ?? ""
//            self.navigationController?.pushViewController(resultVC, animated: true)
//        }
//        else
        if indexPath.row == 1
        {
            let resultVC : WebLinkVC = Utilities.viewController(name: "WebLinkVC", storyboard: "Settings") as! WebLinkVC
            resultVC.titleStr = "Privacy Policy"
            resultVC.Data = self.dictdata["app_privacy"]as? String ?? ""
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        else if indexPath.row == 2
        {
            let resultVC : WebLinkVC = Utilities.viewController(name: "WebLinkVC", storyboard: "Settings") as! WebLinkVC
            resultVC.titleStr = "Terms & Conditions"
            resultVC.Data = self.dictdata["app_tc"]as? String ?? ""
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        else if indexPath.row == 3
        {
            let resultVC : WebLinkVC = Utilities.viewController(name: "WebLinkVC", storyboard: "Settings") as! WebLinkVC
            resultVC.titleStr = "Refund policy"
            resultVC.Data = self.dictdata["app_refund_p"]as? String ?? ""
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    } 
}

extension SettingsVC {
    
    func APISetting() {
       
        AlamofireModel.alamofireMethod(.post, apiAction: .settings,  parameters : [:], Header: header, handler: {res in
            

            let jsonText = strFromJSON(res.originalJSON)
            var dictonary:NSDictionary?
            
            if let data = jsonText.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                    
                    if let myDictionary = dictonary
                    {
                        let arreatch = myDictionary["VIDEO_STREAMING_APP"] as? NSArray ?? []
                        if arreatch.count != 0
                        {
                            let dict = (arreatch[0]as? NSDictionary)?.value(forKey: "0")as? NSArray ?? []
                            self.dictdata = dict[0]as? NSDictionary ?? [:]
                           
                            
                        }
                        else
                        {
                            
                        }
                    }
                
                } catch let error as NSError {
                    print(error)
                }
            }
           
            
           
            
        }, errorhandler: {error in
            
        })
    }
    
}
