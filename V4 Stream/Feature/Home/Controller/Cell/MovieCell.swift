//
//  MovieCell.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var lblRental: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var viewRental: GradientView!
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lbllanguage: UILabel!
    @IBOutlet weak var progress: UIProgressView!
}
