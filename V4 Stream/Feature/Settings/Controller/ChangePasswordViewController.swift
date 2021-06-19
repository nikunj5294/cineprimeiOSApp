//
//  ChangePasswordViewController.swift
//  V4 Stream
//
//  Created by jaydip kapadiya on 03/04/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtoldpassword: UITextField!
    @IBOutlet weak var txtnewpassword: UITextField!
    @IBOutlet weak var txtconfirmpassword: UITextField!
    var phone = String()
    @IBOutlet weak var viewNoData: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPlaceHolder()
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if self.validation() {
            self.APIEditProfile()
        }
    }
    
    func setPlaceHolder() {
        
        self.txtoldpassword.attributedPlaceholder = NSAttributedString(string: "Enter Old Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtnewpassword.attributedPlaceholder = NSAttributedString(string: "Enter New Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtconfirmpassword.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func validation() -> Bool {
        self.txtoldpassword.text = Utilities.trim(self.txtoldpassword.text!)
        self.txtnewpassword.text = Utilities.trim(self.txtnewpassword.text!)
        self.txtconfirmpassword.text = Utilities.trim(self.txtconfirmpassword.text!)
        
        if self.txtoldpassword.text == "" {
            AppInstance.showMessages(message: "Please enter old password")
        } else if self.txtnewpassword.text == "" {
            AppInstance.showMessages(message: "Please enter new password")
        } else if txtnewpassword.text != txtconfirmpassword.text {
            AppInstance.showMessages(message: "new password and conform password not match")
        } else {
            return true
        }
        return false
    }
}

extension ChangePasswordViewController {
    
    
    func APIEditProfile() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "phone": phone,
                                    "password": self.txtconfirmpassword.text!]
        

        var images: [String:UIImage] = [String:UIImage]()
        
        AlamofireModel.alamofireMethodWithImages(.post, apiAction: .profile_update, parameters: param, Header: [:], images: images, handler: {res in
            
            
        }, errorhandler: {error in
            
        })
    }
    
}
