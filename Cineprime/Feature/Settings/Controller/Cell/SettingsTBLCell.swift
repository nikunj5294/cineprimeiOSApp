//
//  SettingsTBLCell.swift
//  V4 Stream
//
//  Created by kishan on 14/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SettingsTBLCell: UITableViewCell {

    @IBOutlet weak var stcEnableOrNotPushNotification: UISwitch!
    @IBOutlet weak var lblSettingsOption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
