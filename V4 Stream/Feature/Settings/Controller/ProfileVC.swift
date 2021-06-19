//
//  ProfileVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!

    @IBOutlet weak var viewNoData: UIView!
    var imagePicker = UIImagePickerController()
    var isProfileImageSet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPassword.isUserInteractionEnabled = false
        self.setPlaceHolder()
        self.APIProfile()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        let resultVC : ChangePasswordViewController = Utilities.viewController(name: "ChangePasswordViewController", storyboard: "Settings") as! ChangePasswordViewController
        resultVC.phone = txtMobile.text ?? ""
        self.navigationController?.pushViewController(resultVC, animated: false)
        
    }
    
    @IBAction func btnProfilePicAction(_ sender: UIButton) {
       // self.pickPhoto()
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if self.validation() {
            self.APIEditProfile()
        }
    }
    
    func setPlaceHolder() {
        
        self.txtMobile.delegate = self
        
        self.txtName.attributedPlaceholder = NSAttributedString(string: "Enter name",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "Enter Phone",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func validation() -> Bool {
        self.txtName.text = Utilities.trim(self.txtName.text!)
        self.txtMobile.text = Utilities.trim(self.txtMobile.text!)
        self.txtPassword.text = Utilities.trim(self.txtPassword.text!)
        
        if self.txtName.text == "" {
            AppInstance.showMessages(message: "Please enter name")
        } else if self.txtMobile.text == "" {
            AppInstance.showMessages(message: "Please enter mobile number")
        } else if !Utilities.isValidContactNumber(self.txtMobile.text!) {
            AppInstance.showMessages(message: "Please enter valid mobile number")
        } else {
            return true
        }
        return false
    }
}

extension ProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtMobile && !Utilities.isBackSpace(string){
            
            if textField.text!.count > 13 {
                return false
            }
        }
        return true
    }
    
}
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto()
    {
        self.imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.imgProfile
            alert.popoverPresentationController?.sourceRect = self.imgProfile.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            AppInstance.showMessages(message: "You don't have camera")
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            let img = Utilities.resizeImage(image: image)
            self.imgProfile.image = img
            self.isProfileImageSet = true
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }

    
}
extension ProfileVC {
    
    func APIProfile() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .profile, parameters: param, Header: header, handler: {res in
            
            self.viewNoData.isHidden = true
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            self.txtName.text = strFromJSON(data["name"])
            self.txtMobile.text = strFromJSON(data["phone"])
            self.txtPassword.text = "*******"
          //  let user_image = strFromJSON(data["user_image"])
           // self.imgProfile.sd_setImage(with: URL(string: user_image), placeholderImage: UIImage(named: "ic_profile_sd"))
            
            if(strFromJSON(data["s_type"]) != "")
            {
                //Hide change password btn
                self.btnChangePassword.isHidden = true
            }
            else
            {
                self.btnChangePassword.isHidden = false
            }
        }, errorhandler: {error in
            
        })
    }
    
    func APIEditProfile() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "name": self.txtName.text!,
                                    "phone": self.txtMobile.text!,
                                    "password": self.txtPassword.text!,
                                    "email": "",
                                    "user_address": ""]
        

        var images: [String:UIImage] = [String:UIImage]()
        
        if self.isProfileImageSet {
            images["user_image"] = self.imgProfile.image!
        }
        
        AlamofireModel.alamofireMethodWithImages(.post, apiAction: .profile_update, parameters: param, Header: [:], images: images, handler: {res in
            
            
        }, errorhandler: {error in
            
        })
    }
    
}
