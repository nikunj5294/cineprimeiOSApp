//
//  LoginVC.swift
//  V4 Stream
//
//  Created by kishan on 14/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import AuthenticationServices

class LoginVC: UIViewController,GIDSignInDelegate {

    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgRememberMe: UIImageView!
    @IBOutlet weak var imgage: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var imgPAsswordEye: UIImageView!
    @IBOutlet weak var lblPassword:UILabel!
    @IBOutlet weak var lblOutsideindia:UILabel!

    
    @IBOutlet weak var viewAppleSignIn: UIView!
    @IBOutlet weak var viewGoogleSignIn: UIView!
    @IBOutlet weak var viewFacebookSignIn: UIView!
    
    var countryCode = "+91"
    var ageselect = "0"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setPlaceHolder()
        
        imgage.isHidden = true
        if kCurrentUser.last_login_phone != "" {
            self.txtMobileNumber.text = kCurrentUser.last_login_phone
            self.txtPassword.text = kCurrentUser.last_login_password
            imgRememberMe.isHidden = false
        } else {
            imgRememberMe.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupAppleSignIn()
        }
        
        lblOutsideindia.text = "* Users from outside India have to Login with \n   Facebook and Google"
        
        let cornerRadius = CGFloat(5.0)
        viewAppleSignIn.layer.cornerRadius = cornerRadius
        viewFacebookSignIn.layer.cornerRadius = cornerRadius
        viewGoogleSignIn.layer.cornerRadius = cornerRadius
        
//        performExistingAccountSetupFlows()

        // Do any additional setup after loading the view.
    }
    
    /************Apple Sign In Setup************/
      
    func setupAppleSignIn() {
        
        if #available(iOS 13.0, *) {
            let btnAuthorization = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
            btnAuthorization.frame = CGRect(x: 0, y: 0, width: 300, height: viewAppleSignIn.frame.size.height)
            btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            viewAppleSignIn.addSubview(btnAuthorization)
        }else{
            viewAppleSignIn.isHidden = true
        }
        
        
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.CheckVersion()
    }
    @IBAction func btnSkipAction(_ sender: UIButton) {
        self.view.endEditing(true)
        AppInstance.goToHomeVC()
    }
    
    @IBAction func btnRememberMeAction(_ sender: Any) {
        imgRememberMe.isHidden = !imgRememberMe.isHidden
    }
    
    @IBAction func btnAgeAction(_ sender: Any) {
        if ageselect == "0"
        {
            ageselect = "1"
        }
        else
        {
            ageselect = "0"
        }
        imgage.isHidden = !imgage.isHidden
    }
    
    @IBAction func btnCountryCodeAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let resultVC : CountryPickerVC = Utilities.viewController(name: "CountryPickerVC", storyboard: "CountryPicker") as! CountryPickerVC
        resultVC.delegate = self
        self.present(resultVC, animated: true, completion: nil)
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)

        if self.validation() {
            self.APILogin()
        }
        
    }
    @IBAction func btnPasswordEyeAction(_ sender: UIButton) {
        
        if self.txtPassword.isSecureTextEntry {
            self.txtPassword.isSecureTextEntry = false
            self.imgPAsswordEye.image = UIImage(named: "ic_eye")
            self.imgPAsswordEye.tintColor = .white
        } else {
            self.txtPassword.isSecureTextEntry = true
            self.imgPAsswordEye.image =  UIImage(named: "ic_eye_close")
            self.imgPAsswordEye.tintColor = .white
        }
    }
    
    @IBAction func btnappleUpAction(_ sender: UIButton)
    {
      
    }
    
    @IBAction func btnSignUpAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let resultVC : SignUpVC = Utilities.viewController(name: "SignUpVC", storyboard: "Authentication") as! SignUpVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnForgotPasswordAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let resultVC : ForgotPasswordVC = Utilities.viewController(name: "ForgotPasswordVC", storyboard: "Authentication") as! ForgotPasswordVC
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @objc func actionHandleAppleSignin() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    @IBAction func btnapplelogin(_ sender: UIButton)
    {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    @IBAction func btnGoogleLogin(_ sender: UIButton)
    {
    
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        // When user is signed in
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }else
            {
              
                Profile.loadCurrentProfile
                { (profile, error) in

                    let param : [String:Any] = ["name":  user?.user.displayName ?? "","is_facebook": user?.user.uid ?? "","phone":user?.user.phoneNumber ?? "","s_type":"google"]
                    
                    AlamofireModel.alamofireMethod(.post, apiAction: .facebook, parameters: param, Header: header, handler: {res in
                        if res.success {
//                            kCurrentUser.update(res.json)
//                          Dimple
                            let dictTemp = res.json.dictionary! as Dictionary
                            let userdict = dictTemp["user_list"]![0]
                            kCurrentUser.update(JSON(userdict))
                            AppInstance.goToHomeVC(isAnimated: true)
                        } else {
                            AppInstance.showMessages(message: res.message)
                        }

                    }, errorhandler: {error in

                    })
                }
            }
        })
    }
    // Start Google OAuth2 Authentication
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?)
    {
        
        // Showing OAuth2 authentication window
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
      // Close OAuth2 authentication window
      dismiss(animated: true) {() -> Void in }
    }
    
//    func facebooklogin() {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: [ .publicProfile ], viewController: self) { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success(let _, let _, let _):
//                self.getFBUserData()
//            }
//        }
//    }
//
//    func getFBUserData(){
//        if((AccessToken.current) != nil){
//            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                   // self.dict = result as! [String : AnyObject]
//                    print(result!)
//                    //print(self.dict)
//                }
//            })
//        }
//    }
    
    
    
    @IBAction func btnFacebookLogin(_ sender: UIButton)
    {
        //self.facebooklogin()
        let loginManager = LoginManager()

        loginManager.logIn(permissions: ["email","public_profile"], from: self) { [weak self] (result, error) in

            guard error == nil else {
                // Error occurred
                print(error!.localizedDescription)
                return
            }

            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }

            Profile.loadCurrentProfile { (profile, error) in

                let param : [String:Any] = ["name":  profile?.name ?? "","is_facebook": profile?.userID ?? "","phone":"","s_type":"facebook"]

                AlamofireModel.alamofireMethod(.post, apiAction: .facebook, parameters: param, Header: header, handler: {res in
                    if res.success {
//                        kCurrentUser.update(res.json)
//                        Dimple
                        let dictTemp = res.json.dictionary! as Dictionary
                        let userdict = dictTemp["user_list"]![0]
                        kCurrentUser.update(JSON(userdict))

                        AppInstance.goToHomeVC(isAnimated: true)
                    } else {
                        AppInstance.showMessages(message: res.message)
                    }

                }, errorhandler: {error in

                })
            }
        }
    }
    
    func setPlaceHolder() {
        
        self.txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Enter Mobile No",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        imgRememberMe.image = imgRememberMe.image?.withRenderingMode(.alwaysTemplate)
        imgEmail.image = imgEmail.image?.withRenderingMode(.alwaysTemplate)
        imgPassword.image = imgPassword.image?.withRenderingMode(.alwaysTemplate)
        
    }
    
    func validation() -> Bool {
        
        self.txtMobileNumber.text = Utilities.trim(self.txtMobileNumber.text!)
        self.txtPassword.text = Utilities.trim(self.txtPassword.text!)
        
        if self.txtMobileNumber.text == "" {
            AppInstance.showMessages(message: "Please enter mobile no")
        }
        else if !Utilities.isValidContactNumber(self.txtMobileNumber.text!) {
            AppInstance.showMessages(message: "Please enter valid mobile no")
        }
        else if self.txtPassword.text == "" {
            AppInstance.showMessages(message: "Please enter password")
        }
//        else if self.ageselect == "0"
//        {
//            AppInstance.showMessages(message: "Please Verify your age")
//        }
        else {
            return true
        }
        
        return false
    }
}

extension LoginVC: CountryPickerVCDelegate {

    
    func countryDidSelect(name: String, dial_code: String) {
        self.countryCode = dial_code
        self.btnCountryCode.setTitle(dial_code, for: .normal)
        
    }
}

extension LoginVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.txtMobileNumber:
            self.txtPassword.becomeFirstResponder()
            break
        case self.txtPassword:
            self.txtPassword.resignFirstResponder()
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


extension LoginVC {
    
    func aleartmsg(msg : String)
    {
        let refreshAlert = UIAlertController(title: "CINEPRIME", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if let url = URL(string: "https://apps.apple.com/us/app/cineprime/id1561387750") {
                UIApplication.shared.open(url)
            }
        }))
        
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func CheckVersion() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let param : [String:Any] = ["version": appVersion ?? "0.0"] //144
        Tagss = 1
        AlamofireModel.alamofireMethod(.post, apiAction: APIAction.ios_v_chek, parameters: param, Header: header, handler: {res in
            Tagss = 0
            let jsonText = strFromJSON(res.originalJSON)
            var dictonary:NSDictionary?
            
            if let data = jsonText.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                    
                    if let myDictionary = dictonary
                    {
                        let arreatch = myDictionary["VIDEO_STREAMING_APP"] as? NSArray ?? []
                        let dicttemp = arreatch[0]as? NSDictionary ?? [:]
                        if dicttemp["success"]as? String == "0"
                        {
                            self.aleartmsg(msg: dicttemp["msg"]as? String ?? "")
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
           
            
        }, errorhandler: {error in
            
        })
    }
    
    func APILogin() {
    
        let uuid = UIDevice.current.identifierForVendor?.uuidString.lowercased()
        
        let param : [String:Any] = ["country_code": "+91",
                                    "email": self.txtMobileNumber.text!,
                                    "password": self.txtPassword.text!,
                                    "imei_number":uuid!]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .login, parameters: param, Header: header, handler: {res in
            
            if res.success {
                
                if self.imgRememberMe.isHidden == true {
                    kCurrentUser.last_login_phone = ""
                    kCurrentUser.last_login_password = ""
                } else {
                    kCurrentUser.last_login_phone = self.txtMobileNumber.text!
                    kCurrentUser.last_login_password = self.txtPassword.text!
                }
                
                kCurrentUser.update(res.json)
                AppInstance.goToHomeVC(isAnimated: true)
            } else {
                AppInstance.showMessages(message: res.message)
            }
            
        }, errorhandler: {error in
            
        })
    }
    
  
}

extension LoginVC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding
{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
    {
        return view.window!
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential
        {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            
            let email = appleIDCredential.email;
            print(appleIDCredential)
            
            var id  = userIdentifier
 //
             if id == ""
             {
                 id = appleIDCredential.fullName?.givenName ?? ""
             }
             if id == ""
             {
                 id = appleIDCredential.fullName?.nickname ?? ""
             }
             if id == ""
             {
                 id = appleIDCredential.fullName?.familyName ?? ""
             }
            
            let last_name = appleIDCredential.fullName?.familyName ?? "";
            
            var name = appleIDCredential.fullName?.givenName ?? "" + "\n\(appleIDCredential.fullName?.nickname ?? "")" + "\n\(appleIDCredential.fullName?.namePrefix ?? "")" + "\n\(appleIDCredential.fullName?.middleName ?? "")" + "\n\(last_name)" + "\n\(id)"
//            self.lblPassword.text = name
//            AppInstance.showMessages(message:name)

           if last_name != ""
           {
                if name == ""
                {
                    name = appleIDCredential.fullName?.nickname ?? ""
                    
                    if name == ""
                    {
                        name = appleIDCredential.fullName?.namePrefix ?? ""
                    }
                    else
                    {
                        name = "\(name)" + " \(last_name)"
                    }
                }
                else
                {
                    name = "\(name)" + " \(last_name)"
                }
           }
           else if name == ""
           {
                name = appleIDCredential.fullName?.nickname ?? ""
                
                if name == ""
                {
                    name = appleIDCredential.fullName?.namePrefix ?? ""
                }
           }
            
            print(appleIDCredential.fullName?.nickname ?? "")

            let param : [String:Any] = ["name":" ","is_facebook": id,"phone":"","s_type":"apple"]
//            let param : [String:Any] = ["name":  user?.user.displayName ?? "","is_facebook": user?.user.uid ?? "","phone":user?.user.phoneNumber ?? ""]
            
            AlamofireModel.alamofireMethod(.post, apiAction: .facebook, parameters: param, Header: header, handler: {res in
                if res.success {

//                  Dimple
                    let dictTemp = res.json.dictionary! as Dictionary
                    let userdict = dictTemp["user_list"]![0]
                    kCurrentUser.update(JSON(userdict))
                    AppInstance.goToHomeVC(isAnimated: true)
                } else {
                    AppInstance.showMessages(message: res.message)
                }

            }, errorhandler: {error in

            })
            
            break
        default:
            break
        }
    }
    
    
}
