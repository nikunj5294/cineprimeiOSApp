//
//  MovieCategoryCell.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 17/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

protocol MovieCategoryCellDelegate {
    func didTapOnMovie(movieData: MovieData)
//    func didTapOnWebSeries(showData: ShowData)
}
class MovieCategoryCell: UITableViewCell {

    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var clnMovie: UICollectionView!
    var delegate: MovieCategoryCellDelegate?
    
    public var type: Int = 0
    var movies: [MovieData] = [MovieData]()
//    var shows: [ShowData] = [ShowData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clnMovie.delegate = self
        self.clnMovie.dataSource = self
        
        //Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MovieCategoryCell : UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if type == 1 {
            return self.movies.count
//        } else {
//            return self.shows.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.lblTitle.isHidden = true
        if type == 1 {
            let temp = self.movies[indexPath.row]
            cell.lblTitle.text = temp.movie_title
            cell.lblDuration.text = ""//temp.movie_duration
            cell.lblRental.text = temp.movie_access
            cell.viewRental.isHidden = true
//                (temp.movie_access == "Free" || temp.movie_access == "")
            cell.imgThumbnail.sd_setImage(with: URL(string: temp.movie_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
           
        } else {
            cell.viewRental.isHidden = true
//            let temp = self.shows[indexPath.row]
//            cell.lblTitle.text = temp.show_title
            cell.lblDuration.text = ""
//            cell.imgThumbnail.sd_setImage(with: URL(string: temp.show_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))

        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if type == 1 {
            self.delegate?.didTapOnMovie(movieData: self.movies[indexPath.row])
        } else {
            //self.delegate?.didTapOnWebSeries(showData: self.shows[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if type == 1 {
            return CGSize(width: (ScreenWidth-8)/3, height: 210)
        } else {
            return CGSize(width: (ScreenWidth - 50)/2, height: 140)
        }
        
    }
}
