//
//  AboutUsVC.swift
//  V4 Stream
//
//  Created by kishan on 15/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import WebKit

class AboutUsVC: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblVersion.text = appDetail.app_version
        self.lblCompany.text = "cineprime"//appDetail.app_company
        self.lblEmail.text = appDetail.app_email
        self.lblWebsite.text = appDetail.app_website
        self.lblContact.text = appDetail.app_contact
        self.lblAbout.text = appDetail.app_about.html2String
        self.imgLogo.sd_setImage(with: URL(string: appDetail.app_logo), placeholderImage: UIImage(named: "ic_profile_top_bg"))
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
