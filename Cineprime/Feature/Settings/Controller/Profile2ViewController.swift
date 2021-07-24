//
//  Profile2ViewController.swift
//  V4 Stream
//
//  Created by jaydip kapadiya on 08/04/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class Profile2ViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEdit.layer.cornerRadius = 8.0
        btnEdit.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.APIProfile()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnEdit(_ sender: UIButton) {
        let resultVC : ProfileVC = Utilities.viewController(name: "ProfileVC", storyboard: "Settings") as! ProfileVC
        self.navigationController?.pushViewController(resultVC, animated: false)
    }
}
extension Profile2ViewController {
    
    func APIProfile() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .profile, parameters: param, Header: header, handler: {res in
            
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            
            self.lblName.text = strFromJSON(data["name"])
    
        }, errorhandler: {error in
            
        })
    }
}
