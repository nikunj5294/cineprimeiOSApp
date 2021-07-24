//
//  TransactionSubsCell.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 11/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class TransactionSubsCell: UITableViewCell {

    @IBOutlet weak var lblPlanType: UILabel!
    @IBOutlet weak var lblPlanAmount: UILabel!
    @IBOutlet weak var lblPaymentId: UILabel!
    @IBOutlet weak var lblSubscribedOn: UILabel!
    @IBOutlet weak var lblExpiredOn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
