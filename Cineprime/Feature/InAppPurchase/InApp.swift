//
//  InApp.swift
//  InAppPurchase
//
//  Created by Lokesh Dudhat on 17/12/19.
//  Copyright © 2019 BhavinR. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit


// InApp result
public enum ProductResult {
    case success(retrievedProducts: [SKProduct])
    case error(error: String)
}

// InApp Upload Receipt result
public enum ReceiptResult {
    case success(data: Data, response: URLResponse?)
    case error(error: Error?)
}

// MARK:
class InApp: NSObject {
    
    //MARK:- Variables -
    static var `default` = InApp()
    
    // MARK:- Override Methods -
    override init() {
        super.init()
    }
    
    deinit {
        
    }
    
}

// MARK: - Custom methods -
extension InApp {
    
    func initMethod() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased:
                    self.receiptValidate(id: purchase.productId)
                case .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
    func retriveAllProduct(_ productIds: Set<String>, complition: ((ProductResult) -> Void)? = nil) {
        
        SwiftyStoreKit.retrieveProductsInfo(productIds) { result in
            if result.retrievedProducts.count > 0 {
                complition?(.success(retrievedProducts: Array(result.retrievedProducts)))
            }
            else if result.invalidProductIDs.count > 0 {
                complition?(.error(error: "Invalid product identifier: \(result.invalidProductIDs)"))
            }
            else if let error = result.error {
                complition?(.error(error: error.localizedDescription))
            }
        }
    }
    
    func buyProduct(withProductID productID: String, complition: ((PurchaseResult) -> Void)? = nil) {
        if SwiftyStoreKit.canMakePayments {
            SwiftyStoreKit.purchaseProduct(productID) { (result) in
                complition?(result)
            }
        }
        else {
            complition?(.error(error: SKError(SKError.unknown, userInfo: ["error" : "Cant make payments"])))
        }
    }
    
    /*
    func receiptValidation(withURL url: String, password: String = "", complition: ((ReceiptResult) -> Void)? = nil) {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict = ["receiptData" : recieptString]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: url)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let header = ["accept":"application/json",
                                 "contentType":"application/json",
                                 "Authorization":"Bearer " + APICallManager.authToken]
            
            storeRequest.allHTTPHeaderFields = header
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: {(data, response, error) in
                if let data = data {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        print("=======>",jsonResponse)
                        if let date = self.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                            print(date)
                        }
                    } catch let parseError {
                        complition?(.error(error: parseError))
                    }
                    complition?(.success(data: data, response: response))
                }
                else {
                    complition?(.error(error: error))
                }
                
            })
            task.resume()
        } catch let parseError {
            complition?(.error(error: parseError))
        }
    }*/
    
    
    
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        if let recieptInfo: String = jsonResponse["latest_receipt_info"] as? String {
            let decodedData = Data(base64Encoded: recieptInfo)!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            print(decodedString)
        }
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
}

extension InApp {
    
    func receiptValidate(id:String) {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        self.CallReceiptValidationAPI(id: id, strReceipt: recieptString!)
        
        /*
         self.showHud()
         let url = "http://betting.inexture.com/api/verify-receipt"
         InApp.default.receiptValidation(withURL: url) { (result) in
         self.hideHud()
         switch (result) {
         case .success(let data, let response):
         self.getUserCoinsDetails()
         break
         case .error(let error):
         break
         }
         }*/
    }
    /*
    func CallReceiptValidationAPI(id: String, strReceipt:String) {
        
        if APICallManager.sharedInstance.isInternetAvailable() == false {
            showToaster(message: AppStrings.shared.alert_no_internet)
        }
        
        let dictParam : NSMutableDictionary = ["receiptData":strReceipt]
        
        APICallManager.sharedInstance.callWebService(apiUrl: APIPath.verify_receipt.rawValue, parameters: dictParam, httpMethod: .post) { (success, response) in
            
            if success == true {
                //                    let dictData = response as! [String:Any]
                let coins = id.replacingOccurrences(of: "com.klashapp.", with: "").replacingOccurrences(of: "KlashCoins", with: "").integerValue ?? 0
                Analytics.logEvent("buy_klash_coins", parameters: [
                    "coins": coins
                ])
                UIApplication.topViewController()?.getUserDetails()
            }
            else {
                
            }
        }
        
    }*/

}
