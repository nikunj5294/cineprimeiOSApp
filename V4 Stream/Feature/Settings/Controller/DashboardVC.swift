//
//  DashboardVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCurrentPlan: UILabel!
    @IBOutlet weak var lblSubScriptionExpire: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewNoData.isHidden = true
        self.APIDashboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        let resultVC: ProfileVC = Utilities.viewController(name: "ProfileVC", storyboard: "Settings") as! ProfileVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnUpgradePlanAction(_ sender: UIButton) {
        //let resultVC: SubscripionPlanVC = Utilities.viewController(name: "SubscripionPlanVC", storyboard: "Settings") as! SubscripionPlanVC
        let resultVC: InAppSubscriptionVC = Utilities.viewController(name: "InAppSubscriptionVC", storyboard: "Settings") as! InAppSubscriptionVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }

}


extension DashboardVC {
    
    func APIDashboard() {
        
        let param: [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .dashboard, parameters: param, Header: [:], handler: {res in
            
            self.viewNoData.isHidden = true
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            
            let user_image = strFromJSON(data["user_image"])
            self.imgProfile.sd_setImage(with: URL(string: user_image), placeholderImage: UIImage(named: "ic_profile_sd"))
            if data["name"].description != "" {
                self.lblName.text = data["name"].description
            }
            if data["current_plan"].description != "" {
                self.lblCurrentPlan.text = "Current Plan: " + data["current_plan"].description
            }
            if data["expires_on"].description != "" {
                self.lblSubScriptionExpire.text = "Subscription expires on: " + data["expires_on"].description
            }
            if data["last_invoice_date"].description != "" {
                self.lblDate.text = "Date: " + data["last_invoice_date"].description
            }
            if data["last_invoice_plan"].description != "" {
                self.lblPlan.text = "Plan: " + data["last_invoice_plan"].description
            }
            if data["last_invoice_amount"].description != "" {
                self.lblAmount.text = "Amount: " + data["last_invoice_amount"].description
            }
            
             
            
        }, errorhandler: {error in
            
        })
    }
}

