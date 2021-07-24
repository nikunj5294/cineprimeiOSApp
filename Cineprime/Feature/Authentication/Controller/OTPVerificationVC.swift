//
//  OTPVerificationVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 31/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import Firebase
class OTPVerificationVC: UIViewController {

    
    @IBOutlet weak var txtOtp: UITextField!
    
    var mobile_number = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        let count = self.navigationController!.viewControllers.count
        
        if count > 2 {
            let resultVC = self.navigationController!.viewControllers[count - 3]
            self.navigationController?.popToViewController(resultVC, animated: true)
        }
    }
    
    @IBAction func btnVerifyAction(_ sender: UIButton) {
        
        self.txtOtp.text = Utilities.trim(self.txtOtp.text!)
        
        if self.txtOtp.text == "" {
            Utilities.showMessages(message: "Please enter OTP")
        } else {
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: self.txtOtp.text!)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Sucess")
                    let resultVC: LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
            
            
         
            //self.APIVerifyOTP()
        }
        
    }
}

extension OTPVerificationVC {
 
    func APIVerifyOTP() {
        
        let param : [String:Any] = ["phone": mobile_number,
                                    "otp": self.txtOtp.text!]

        AlamofireModel.alamofireMethod(.post, apiAction: .vetifyOTP, parameters: param, Header: header, handler: {res in
            
            if strFromJSON(res.json["success"]) == "true" || strFromJSON(res.json["success"]) == "1"  {
                let resultVC: LoginVC = Utilities.viewController(name: "LoginVC", storyboard: "Authentication") as! LoginVC
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                Utilities.showMessages(message: strFromJSON(res.json["msg"]))
            }

            
        }, errorhandler: {error in
            
        })
    }
    
}


