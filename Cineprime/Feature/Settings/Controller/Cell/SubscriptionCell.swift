//
//  SubscriptionCell.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewarrow: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var buttonback: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtPromocode: UITextField!
    @IBOutlet weak var viewPromocode: UIView!
    
    
    @IBOutlet weak var lblMovies: UILabel!
    @IBOutlet weak var lblWebseries: UILabel!
    @IBOutlet weak var lblVideoQuality: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.txtPromocode.delegate = self
       // self.txtPromocode.attributedPlaceholder = NSAttributedString(string: "Promo Code",
        //attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
