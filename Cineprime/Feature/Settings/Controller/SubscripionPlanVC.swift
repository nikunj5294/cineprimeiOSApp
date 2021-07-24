//
//  SubscripionPlanVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import StoreKit

class SubscripionPlanVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNavigationObj: UIView!
    
    
    var selectedPlan = SubscriptionData()
    var promocode = ""
    var current_plan = ""
    var IAproducts: [SKProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100.0
        getIAPStoreItems()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.APICheckUserPlan()
        self.APISubscripanPlan()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.isScrollEnabled = (self.tableView.contentSize.height + self.viewNavigationObj.frame.size.height) > UIScreen.main.bounds.height ? true : false
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func getIAPStoreItems(){
        
        CinePrimeProducts.store.requestProducts{ [weak self] success, products in
          guard let self = self else { return }
          if success {
            self.IAproducts = products!
          }
        }
    }
    
    @objc func btnProceedAction(_ sender: UIButton)
    {
        
        if kCurrentUser.name.count == 0 || kCurrentUser.phone.count == 0{
            
            let alertObj = UIAlertController(title: "CINEPRIME", message: "Please complete your profile before purchase the plan", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action) in
                let resultVC : ProfileVC = Utilities.viewController(name: "ProfileVC", storyboard: "Settings") as! ProfileVC
                self.navigationController?.pushViewController(resultVC, animated: false)
            }
            
            let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                alertObj.dismiss(animated: true, completion: nil)
            }
            
            alertObj.addAction(action2)
            alertObj.addAction(action1)
            self.present(alertObj, animated: true, completion: nil)
            
        }else{
            
            if self.current_plan != subscription.list[sender.tag].plan_name
            {
                self.selectedPlan = subscription.list[sender.tag]
            } else {
                Utilities.showMessages(message: "You have purchased this plan")
                return
            }
            if self.selectedPlan.plan_id != "" {
      
                let resultVC: PurchaseSubscriptionVC = Utilities.viewController(name: "PurchaseSubscriptionVC", storyboard: "Settings") as! PurchaseSubscriptionVC
                
                if selectedPlan.plan_name.uppercased() == "V4 STREAM PREMIUM"
                {
                    resultVC.promocode = Utilities.trim(self.promocode)
                }
                resultVC.selectedPlan = self.selectedPlan
                
                if(self.IAproducts.count > 0)
                {
                    if (self.selectedPlan.plan_id == "1")//yearly
                    {
                        resultVC.SelectedIAProduct = self.IAproducts[0]
                        for prod1 in self.IAproducts
                        {
                            if(prod1.productIdentifier == CinePrimeProducts.Pyearly)
                            {
                                resultVC.SelectedIAProduct = prod1
                                break
                            }
                        }
                    }
                    else if(self.selectedPlan.plan_id == "2")//halfyearly
                    {
                        for prod1 in self.IAproducts
                        {
                            if(prod1.productIdentifier == CinePrimeProducts.PhalfYearly)
                            {
                                resultVC.SelectedIAProduct = prod1
                                break
                            }
                        }
                    }
                    else if(self.selectedPlan.plan_id == "3")//quarterly
                    {
                        for prod1 in self.IAproducts
                        {
                            if(prod1.productIdentifier == CinePrimeProducts.Pquarterly)
                            {
                                resultVC.SelectedIAProduct = prod1
                                break
                            }
                        }
                    }
                                    
                    print("Promocode --------",self.promocode)
                    print("SelectedIAProduct --------",resultVC.SelectedIAProduct.productIdentifier)
                    
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
                else
                {
                    AppInstance.showMessages(message: "Cant find Products From App Store")
                }

            } else {
                AppInstance.showMessages(message: "Please select plan")
            }
        }
    }

}

extension SubscripionPlanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscription.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SubscriptionCell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
        
        let temp = subscription.list[indexPath.row]
        
        cell.viewMain.layer.borderWidth = 0
        cell.buttonback.tag = indexPath.row
        cell.buttonback.addTarget(self, action: #selector(btnProceedAction), for: .touchUpInside)
        cell.lblPrice.text = "\(temp.plan_price) \(temp.currency_code)"
        cell.lblDuration.text = temp.plan_duration
        cell.lblPlanName.text  = temp.plan_name
        cell.lblMovies.setHTMLFromString(htmlText: temp.plan_description)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.current_plan != subscription.list[indexPath.row].plan_name {
            self.selectedPlan = subscription.list[indexPath.row]
        } else {
            Utilities.showMessages(message: "You have purchased this plan")
        }
    }
    
    @IBAction func txtPromocodeValueChanged(_ sender: UITextField) {
        self.promocode = sender.text ?? ""
    }

}


extension SubscripionPlanVC {
    
    func APISubscripanPlan() {

        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .subscription_plan, parameters: param, Header: header, isLoader: (subscription.list.count == 0), handler: {res in
            subscription = Subscription()
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            print(data)
            subscription.update(data)
            self.tableView.reloadData()
            
            self.tableView.isScrollEnabled = (self.tableView.contentSize.height + self.viewNavigationObj.frame.size.height) > UIScreen.main.bounds.height ? true : false
            
        }, errorhandler: {error in
            
        })
    }

    func APICheckUserPlan() {

        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .check_user_plan, parameters: param, Header: header, handler: {res in
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            self.current_plan = strFromJSON(data["current_plan"])
        }, errorhandler: {error in
            
        })
    }
    
}

extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}
