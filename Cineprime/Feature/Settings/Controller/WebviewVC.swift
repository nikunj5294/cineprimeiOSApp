//
//  WebviewVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 18/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import WebKit

class WebviewVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    
    var titleStr : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.lblTitle.text = titleStr
        self.lblPolicy.text = appDetail.app_privacy.html2String
        

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
