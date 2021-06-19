//
//  InAppSubscriptionVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 12/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyJSON
import SideMenuSwift

class InAppSubscriptionVC: UIViewController {
    
    var products: [String: SKProduct] = [:]
    @IBOutlet weak var viewIndicatorContainer: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imgCheckPrivacy: UIImageView!
    @IBOutlet weak var imgCheckTerms: UIImageView!
    @IBOutlet weak var viewMonthly: GradientView!
    @IBOutlet weak var viewYearly: GradientView!
    
    let monthlySubID = "com.accolade.v4stream.MonthlySubscription"
    let yearlySubID = "com.accolade.v4stream.YearlySubscription"
    var selectedPlanId = ""
    
    let imgSelected = UIImage(named: "ic_check")
    let imgUnSelected = UIImage(named: "ic_uncheck")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedPlanId = monthlySubID
        self.manageSelectedPlan()
        self.fetchProducts()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMonthlyAction(_ sender: UIButton) {
        self.selectedPlanId = monthlySubID
        self.manageSelectedPlan()
    }
    
    @IBAction func btnYearlyAction(_ sender: UIButton) {
        self.selectedPlanId = yearlySubID
        self.manageSelectedPlan()
    }
    
    @IBAction func btnPayAction(_ sender: UIButton) {
        
        if self.imgCheckPrivacy.image == self.imgUnSelected {
            AppInstance.showMessages(message: "Please accept privacy policy")
        } else if self.imgCheckTerms.image == self.imgUnSelected {
            AppInstance.showMessages(message: "Please accept terms & conditions")
        } else {
            if let product = products[self.selectedPlanId] {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
                self.showIndicator()
            }
        }
    }
    
    @IBAction func btnRestoreAction(_ sender: UIButton) {
        
        if (SKPaymentQueue.canMakePayments()) {
           self.showIndicator()
           SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            Utilities.showMessages(message: "You can not make it")
        }
    }

    
    @IBAction func btnCheckPrvacyAction(_ sender: UIButton) {

        if self.imgCheckPrivacy.image == self.imgSelected {
            self.imgCheckPrivacy.image = self.imgUnSelected
        } else {
            self.imgCheckPrivacy.image = self.imgSelected
        }
        
    }

    @IBAction func btnCheckTermsAction(_ sender: UIButton) {
        
        if self.imgCheckTerms.image == self.imgSelected {
            self.imgCheckTerms.image = self.imgUnSelected
        } else {
            self.imgCheckTerms.image = self.imgSelected
        }
    }
    
    @IBAction func btnShowTermsAction(_ sender: UIButton) {
        let resultVC : WebLinkVC = Utilities.viewController(name: "WebLinkVC", storyboard: "Settings") as! WebLinkVC
        resultVC.link = termsLink
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnPrivacyPolicyAction(_ sender: UIButton) {
        let resultVC : WebviewVC = Utilities.viewController(name: "WebviewVC", storyboard: "Settings") as! WebviewVC
        resultVC.titleStr = "Privacy Policy"
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func manageSelectedPlan() {
        
        if self.selectedPlanId == self.monthlySubID {
            self.viewMonthly.borderColor = appColors.red
          //  self.viewYearly.borderColor = .white
        } else {
            self.viewMonthly.borderColor = .white
           // self.viewYearly.borderColor = appColors.red
        }
    }
    func showIndicator() {
        self.viewIndicatorContainer.isHidden = false
        self.indicator.startAnimating()
    }
    
    func hideIndicator() {
        self.indicator.stopAnimating()
        self.viewIndicatorContainer.isHidden = true
    }
}

extension InAppSubscriptionVC: SKProductsRequestDelegate {
    
    func fetchProducts() {
        AppInstance.showLoader()
        let productIDs = Set([monthlySubID,yearlySubID])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func purchase(productID: String) {
        if let product = products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            AppInstance.hideLoader()
        }
        
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            
            print("Valid: \(product)")
            products[product.productIdentifier] = product
        }
        
    /*
        DispatchQueue.main.async {
            if let product = self.products[self.yearlySubID] {
                self.lblYearlyPrice.text = "\(product.priceLocale) \(product.price))"
                self.lblYearlyTitle.text = product.localizedTitle
            }
            
            if let product = self.products[self.monthlySubID] {
                self.lblMonthlyPrice.text = "\(product.priceLocale) \(product.price))"
                self.lblMonthlyTitle.text = product.localizedTitle
            }
        }*/

        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
        
        DispatchQueue.main.async {
            AppInstance.hideLoader()
        }
         
    }
    
}

extension AppDelegate: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.hideSubscriptionIndicator()
        Utilities.showMessages(message: error.localizedDescription)
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                self.hideSubscriptionIndicator()
                Utilities.showMessages(message: "Transaction Failed")

                print("Transaction Failed \(transaction)")
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                self.hideSubscriptionIndicator()
                self.purchaseSuccessPopup()
                print("Transaction purchased or restored: \(transaction)")
            case .deferred, .purchasing:
                print("Transaction in progress: \(transaction)")
            }
        }
    }
    
    func hideSubscriptionIndicator() {
        
        if let topVC = AppInstance.topVC() {
            if let nav = topVC as? UINavigationController {
                if nav.viewControllers.count > 0 {
                    if let resultVC = nav.viewControllers[nav.viewControllers.count - 1] as? InAppSubscriptionVC {
                        resultVC.hideIndicator()
                    }
                }
            } else if let sidemenu = topVC as? SideMenuController {
                if let nav = sidemenu.contentViewController as? UINavigationController  {
                    if nav.viewControllers.count > 0 {
                        if let resultVC = nav.viewControllers[nav.viewControllers.count - 1] as? InAppSubscriptionVC {
                            resultVC.hideIndicator()
                        }
                    }
                }

            }
        }
    }
    
    func purchaseSuccessPopup() {
        
        let alert : UIAlertController = UIAlertController(title: "Subscription", message: "Purchase made successfully", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            
            if kCurrentUser.user_id != "" {
                AppInstance.goToHomeVC()
            }

        })
        
        alert.addAction(yesAction)
        
        AppInstance.window!.rootViewController!.present(alert, animated: true, completion: nil)
        
    }
    
    func verifyInAppReceipt() {
        
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                test(receiptData,receiptString)
                APIValidateReceipt(receiptString)
                print("receipt:",receiptString)
            }
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
            }
        } else {
            
            print("You dont have order anything")
        }
    }
    
    func test(_ data: Data, _ receipt: String) {
        
        
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        
        let dict: [String:Any] = ["receipt-data": receipt,
                                  "password":"9a12b4bb60d24467a16f0803178e9f5c",
                                  "exclude-old-transactions":true]
        
        var request = URLRequest(url: url)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                let object = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = object as? [String: Any] else {
                    return
            }
            print("test result")
            print(json)
            print(JSON(json))

            // Your application logic here.
        }
        task.resume()
    }
    
    func APIValidateReceipt(_ receipt: String) {
        
        let param : [String:Any] = ["receipt_data":receipt]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .verify_inapp, parameters: param, Header: [:],is64Bit: false, handler:{res in
            
            if boolFromStr(strFromJSON(res.originalJSON["is_active"])) {
                isInAppPremium = true
            }
            
        }, errorhandler: {error in
            AppInstance.showMessages(message: error.localizedDescription)
        })
        
    }
    
}

