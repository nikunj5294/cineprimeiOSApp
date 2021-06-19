//
//  PaymentVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 11/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import Alamofire
//import Razorpay

class PaymentVC : UIViewController//, RazorpayPaymentCompletionProtocol
{

// typealias Razorpay = RazorpayCheckout

//    var razorpay: RazorpayCheckout!
  //  var razorpayTestKey = "rzp_test_lfkKtyo4bggTcC"
//    var razorpayTestKey = "rzp_live_Pq6qG3SyQGA4nm"

//    var secretKey = "3KV7wIZeiOTDEtBgoaRdJt48"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        razorpay = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        self.showPaymentForm()
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    internal func showPaymentForm(){
//        let options: [String:Any] = [
//                    "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
//                    "currency": "INR",//We support more that 92 international currencies.
//                  //  "order_id": order_id,
//                    "name": "v4Stream",
//                ]
//        razorpay.open(options)
//
//
//    }
    
//    public func onPaymentError(_ code: Int32, description str: String){
//        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//    }
//
//    public func onPaymentSuccess(_ payment_id: String){
//        
//        {
//          "razorpay_payment_id": "pay_29QQoUBi66xm2f",
//          "razorpay_order_id": "order_9A33XWu170gUtm",
//          "razorpay_signature": "9ef4dffbfd84f1318f6739a3ce19f9d85851857ae648f114332d8401e0949a3d"
//        }
//        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//    }
    
//    func createOrder() {
//
//
//        //https://api.razorpay.com/v1/orders
//    }
//
//    func APIcreateOrderId() {
//
//        var alamofireManager : Alamofire.SessionManager?
//
//        alamofireManager = Alamofire.SessionManager.default
//        alamofireManager?.session.configuration.timeoutIntervalForRequest = 31
//        alamofireManager?.session.configuration.timeoutIntervalForResource = 31
//
//        let headerData: [String:String] = ["api_key": self.secretKey,
//                                           "api_key_key": self.secretKey ]
//
//
//        let data = try! JSONSerialization.data(withJSONObject: headerData)
//        let base64Representation = data.base64EncodedString()
//        let header: [String:String] = ["Authorization": base64Representation]
//
//        let params : [String:Any] = ["amount":100,
//                                     "currency":"INR",
//                                     "receipt":Date().timeIntervalSince1970.description,
//                                     "payment_capture":1]
//
//        alamofireManager?.request("https://api.razorpay.com/v1/orders", method: .post, parameters: params, encoding: URLEncoding.default, headers: headerData).responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
//
//            print(response)
//                    //self.showPaymentForm(order_id: String)
//        })
//    }
}
