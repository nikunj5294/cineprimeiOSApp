//
//  CountryPickerCell.swift
//  ezRecorder
//
//  Created by Kishan Kasundra on 08/07/20.
//  Copyright © 2020 ezdi. All rights reserved.
//

import UIKit

class CountryPickerCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDialCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

