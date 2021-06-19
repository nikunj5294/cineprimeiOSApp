//
//  ForgotPasswordVC.swift
//  V4 Stream
//
//  Created by kishan on 15/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtMobileNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPlaceHolder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSendAction(_ sender: UIButton) {
        
        if self.validation() {
            self.APIForgotPassword()
        }
        
    }
    func setPlaceHolder() {
        
        self.txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Enter Mobile Number",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func validation() -> Bool {
        
        self.txtMobileNumber.text = Utilities.trim(self.txtMobileNumber.text!)
        
        if self.txtMobileNumber.text == "" {
            AppInstance.showMessages(message: "Please enter mobile number")
        } else if !Utilities.isValidContactNumber(self.txtMobileNumber.text!) {
            AppInstance.showMessages(message: "Please enter valid mobile number")
        } else {
            return true
        }
        
        return false
    }
    
}

extension ForgotPasswordVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.txtMobileNumber:
            self.txtMobileNumber.resignFirstResponder()
            break
        default:
            print("")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtMobileNumber && !Utilities.isBackSpace(string){
            
            if textField.text!.count > 13 {
                return false
            }
        }
        return true
    }
}

extension ForgotPasswordVC {
    
    func APIForgotPassword() {
        
        let param : [String:Any] = ["email": self.txtMobileNumber.text!,"phone": self.txtMobileNumber.text!]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .forgot_password, parameters: param, Header: header, handler: {res in
            
            self.navigationController?.popViewController(animated: true)
            AppInstance.showMessages(message: res.message)
            
        }, errorhandler: {error in
            
        })
    }
    
}
