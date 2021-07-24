//
//  SignUpVC.swift
//  V4 Stream
//
//  Created by kishan on 15/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import Firebase
class SignUpVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtSelectBirthDate: UITextField!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var btnCountryCode: UIButton!
    
    var countryCode = "+91"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPlaceHolder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnCountryCodeAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let resultVC : CountryPickerVC = Utilities.viewController(name: "CountryPickerVC", storyboard: "CountryPicker") as! CountryPickerVC
        resultVC.delegate = self
        self.present(resultVC, animated: true, completion: nil)
    }
    @IBAction func btnBithdateAction(_ sender: UIButton) {
        
        let resultVC : DatePickerVC = Utilities.viewController(name: "DatePickerVC", storyboard: "Authentication") as! DatePickerVC
        resultVC.delegate = self
        resultVC.maxDate = Date().timeIntervalSince1970
        self.present(resultVC, animated: true, completion: nil)
    }
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        
        if self.validation() {
            self.APIRegister()
        }
    }
    func setPlaceHolder() {
        
        self.txtName.attributedPlaceholder = NSAttributedString(string: "Enter Your Name",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Enter Mobile No",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtSelectBirthDate.attributedPlaceholder = NSAttributedString(string: "Select Birthdate",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
   
        imgCalender.image = imgCalender.image?.withRenderingMode(.alwaysTemplate)
    }
    
    func validation() -> Bool {
        
        self.txtName.text = Utilities.trim(self.txtName.text!)
        self.txtMobileNumber.text = Utilities.trim(self.txtMobileNumber.text!)
        self.txtPassword.text = Utilities.trim(self.txtPassword.text!)
        self.txtConfirmPassword.text = Utilities.trim(self.txtConfirmPassword.text!)
        self.txtSelectBirthDate.text = Utilities.trim(self.txtSelectBirthDate.text!)
        
        if self.txtName.text == "" {
            AppInstance.showMessages(message: "Please enter name")
        } else if self.txtMobileNumber.text == "" {
            AppInstance.showMessages(message: "Please enter mobile no")
        } else if !Utilities.isValidContactNumber(self.txtMobileNumber.text!) {
            AppInstance.showMessages(message: "Please enter valid mobile no")
        } else if self.txtPassword.text == "" {
            AppInstance.showMessages(message: "Please enter password")
        } else if self.txtConfirmPassword.text == "" {
            AppInstance.showMessages(message: "Please enter confirm password")
        } else if self.txtConfirmPassword.text != self.txtPassword.text {
            AppInstance.showMessages(message: "Confirm password doesn't match")
        }
//        else if self.txtSelectBirthDate.text == "" {
//            AppInstance.showMessages(message: "Please select birthdate")
//        }
        else {
            return true
        }
        
        return false
    }
    
}

extension SignUpVC : DatePickerVCDelegate {
    func dateDidSelect(timeStamp: Double) {
        self.txtSelectBirthDate.text = Utilities.getStrDateFromTimeStamp(timeStamp, "dd MMM yyyy")
    }
}

extension SignUpVC: CountryPickerVCDelegate {

    
    func countryDidSelect(name: String, dial_code: String) {
        
        self.countryCode = dial_code
        self.btnCountryCode.setTitle(dial_code, for: .normal)
        
    }
}

extension SignUpVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.txtName:
            self.txtMobileNumber.becomeFirstResponder()
            break
        case self.txtMobileNumber:
            self.txtPassword.becomeFirstResponder()
            break
        case self.txtPassword:
            self.txtConfirmPassword.becomeFirstResponder()
            break
        case self.txtConfirmPassword:
            self.txtConfirmPassword.resignFirstResponder()
            self.btnBithdateAction(UIButton())
            break
        default:
            print("")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtMobileNumber && !Utilities.isBackSpace(string){
            
            if self.countryCode == "+91" && textField.text!.count > 9 {
                return false
            } else if textField.text!.count > 13 {
                return false
            }
        }
        return true
    }
}

extension SignUpVC {
    
    func APIRegister() {
        
        let param : [String:Any] = ["name": self.txtName.text!,
                                    "code": self.countryCode,
                                    "email": self.txtMobileNumber.text!,
                                    "password": self.txtPassword.text!]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .signup, parameters: param, Header: header, handler: {res in
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            let success = strFromJSON(data["success"])
            
            if success == "1"{
                if self.countryCode == "+91" {
                    PhoneAuthProvider.provider().verifyPhoneNumber("+91\(self.txtMobileNumber.text!)", uiDelegate: nil) { (verificationID, error) in
                      if let error = error {
                        print(error.localizedDescription)
                        return
                      }
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                        let resultVC: OTPVerificationVC = Utilities.viewController(name: "OTPVerificationVC", storyboard: "Authentication") as! OTPVerificationVC
                        resultVC.mobile_number = self.txtMobileNumber.text!
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    }
                    
                } else {
                    self.navigationController?.popViewController(animated: true)
                    AppInstance.showMessages(message: res.message)
                }
            }else{
                self.navigationController?.popViewController(animated: true)
                AppInstance.showMessages(message: res.message)
            }
            
        }, errorhandler: {error in
            
        })
    }

}


