//
//  PurchaseSubscriptionVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
//import Razorpay
import StoreKit

class PurchaseSubscriptionVC: UIViewController {

    @IBOutlet weak var viewPlan: UIView!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    
    @IBOutlet weak var btnChangePlan: UIButton!
    
    var SelectedIAProduct: SKProduct!
    
//    var razorpay: RazorpayCheckout!
  //  var razorpayTestKey = "rzp_test_H52R340cv8PI9k"//"rzp_test_lfkKtyo4bggTcC"//
//    var razorpayTestKey = "rzp_live_Pq6qG3SyQGA4nm"//"rzp_live_Pq6qG3SyQGA4nm"//"rzp_test_lfkKtyo4bggTcC"//
//    
//    var secretKey = "3KV7wIZeiOTDEtBgoaRdJt48" //7R6acTkwkoHbIZErEJaSUlNu
    var movie_id = ""
    var show_id = ""
    var promocode = ""
    
    var selectedPlan = SubscriptionData()
    
    var isRental: Bool = false
    
    let regularTextAttribute: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black
    ]
    
    let redTextAttribute: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        razorpay = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
        let firstString = NSMutableAttributedString(string: "You have selected ", attributes: regularTextAttribute)
        let secondString = NSMutableAttributedString(string: selectedPlan.plan_name, attributes: redTextAttribute)
        firstString.append(secondString)
        self.lblText1.attributedText = firstString
        
        let firstString2 = NSMutableAttributedString(string: "You are logged in as ", attributes: regularTextAttribute)
        let secondString2 = NSMutableAttributedString(string: kCurrentUser.name, attributes: redTextAttribute)
        let thirdString2 = NSMutableAttributedString(string: " If you would like to use different account for this subscription ", attributes: regularTextAttribute)
        let fourthString2 = NSMutableAttributedString(string: "Logout", attributes: redTextAttribute)
        firstString2.append(secondString2)
        firstString2.append(thirdString2)
       // firstString2.append(fourthString2)
//        self.lblText2.attributedText = firstString2
        self.lblPhoneNumber.text = "for your registered Mob No: \(kCurrentUser.phone)"
        
        self.viewPlan.layer.borderWidth = 2
//        self.viewPlan.layer.borderColor = appColors.red.cgColor
        
        self.lblPrice.text = "\(selectedPlan.plan_price) \(selectedPlan.currency_code)"
        self.lblDuration.text = selectedPlan.plan_duration
        self.lblPlanName.text  = selectedPlan.plan_name
        
        
        if isRental {
            self.btnChangePlan.isHidden = true
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseSubscriptionVC.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)

    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
//      guard
//        let productID = notification.object as? String;
//        APIAddTransaction(payment_id: productID!.description)
//        AppInstance.showMessages(message: "Product purchased + \(productID ?? "")")
//        let index = products.index(where:
//                                    { product -> Bool in
//          product.productIdentifier == productID
//        })
//      else { return }

//      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangePlanAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProceedAction(_ sender: UIButton) {
        
        if self.promocode != "" {
            APICheckPromocode()
        }
        else if doubleFromStr(self.selectedPlan.plan_price) < 1
        {
            APIAddTransaction(payment_id: Date().timeIntervalSince1970.description)
        } else {
//            self.showPaymentForm()
            callInAppPurchase()
//            CinePrimeProducts.store.buyProduct(SelectedIAProduct)
        }
    }
    
//    Dimple


    
    
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Logout", message: "Are sure you want to logout?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in
            kCurrentUser.logout()
            let resultVC : LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: {_ in
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)

        
    }
    
    func callInAppPurchase() {
        
        AppInstance.showLoader()
        
        InApp.default.buyProduct(withProductID: SelectedIAProduct.productIdentifier) { [self] (result) in
//           self.hideHud()
            
            AppInstance.hideLoader()

           switch (result) {
               case .success(let data):
//                print(data.transaction.transactionIdentifier)
//                print(data.transaction.transactionDate)
                if data.transaction.transactionIdentifier?.count ?? 0 > 0{
                    self.APIAddTransaction(payment_id: self.SelectedIAProduct.productIdentifier)
                }
                break
               case .error(let error):
                   print(error.localizedDescription)
                   break
           }
       }
        
    }
    
}

//extension PurchaseSubscriptionVC: RazorpayPaymentCompletionProtocol {
//
//    internal func showPaymentForm(){
//        let options: [String:Any] = [
//                    "amount": doubleFromStr(self.selectedPlan.plan_price) * 100,
//                    "currency": "INR",
//                    "name": kCurrentUser.name,
//                    "prefill": [
//                        "contact": kCurrentUser.phone
//                    ],
//                    "description":self.selectedPlan.plan_name
//                ]
//        razorpay.open(options)
//
//
//
//
//    }
//
//        public func onPaymentError(_ code: Int32, description str: String){
//            let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//        }
//
//        public func onPaymentSuccess(_ payment_id: String){
//           // payment_id
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.APIAddTransaction(payment_id: payment_id)
//            }
//
//
//        }
//
//}

extension PurchaseSubscriptionVC {
    
    
    func APICheckPromocode() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "promocode":self.promocode]
        
        
        AlamofireModel.alamofireMethod(.post, apiAction: .check_promocode, parameters: param, Header: header,tryAgainOnFail: true, handler: {res in
            

            let json = res.originalJSON["VIDEO_STREAMING_APP"]
            let promocodeStatus = strFromJSON(json["promocode"])
            
            if promocodeStatus == "0" {
                Utilities.showMessages(message: "Inalid Promocode")
            } else if promocodeStatus == "2" {
                Utilities.showMessages(message: "This promocode already used")
            } else {
                AppInstance.goToHomeVC(isAnimated: true)
                Utilities.showMessages(message: "Purchase Succesfull")
            }
            
            
        }, errorhandler: {error in
            
        })
        
    }
    
    func APIAddTransaction(payment_id: String) {

        
        var param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "plan_id": self.selectedPlan.plan_id,
                                    "payment_id": payment_id,
                                    "payment_gateway": "InAppPurchaseApple",
                                    "donation":"0",
                                    "promocode":"iOS"]
        
        if show_id != "" {
            param["show_id"] = show_id
            param["movie_id"] = "0"
        }
        
        if movie_id != "" {
            param["movie_id"] = movie_id
            param["show_id"] = "0"
        }
        
        AlamofireModel.alamofireMethod(.post, apiAction: .transaction_add, parameters: param, Header: header,tryAgainOnFail: true, handler: {res in
            
            if strFromJSON(res.originalJSON["status_code"]) == "200" {
                AppInstance.goToHomeVC(isAnimated: true)
                Utilities.showMessages(message: "Payment Succesfull")
            } else {
                
                let json = res.originalJSON["VIDEO_STREAMING_APP"][0]
                Utilities.showMessages(message: strFromJSON(json["msg"]))
            }
           
        }, errorhandler: {error in
            
        })
        
        
    }
}
