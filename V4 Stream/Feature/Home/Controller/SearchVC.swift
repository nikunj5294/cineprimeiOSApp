//
//  SearchVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 18/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var viewMovie: UIView!
    @IBOutlet weak var clnMovie: UICollectionView!
    @IBOutlet weak var viewShow: UIView!
    @IBOutlet weak var clnShow: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    var searchText = ""
    var movies = MoviesList()
    var shows = ShowsList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewShow.isHidden = true
        self.viewMovie.isHidden = true
        self.APISearch()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension SearchVC : UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == clnShow
        {
//            return self.shows.list.count
            return 0
        }
        else
        {
            return self.movies.list.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.lblTitle.isHidden = true
        if collectionView == self.clnShow {
//            let temp = self.shows.list[indexPath.row]
//            cell.lblTitle.text = temp.show_title
            cell.lblDuration.text = ""
            cell.lblRental.text = ""
            cell.viewRental.isHidden = true
//            cell.imgThumbnail.sd_setImage(with: URL(string: temp.show_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            
        } else {
             let temp = self.movies.list[indexPath.row]
             cell.lblTitle.text = temp.movie_title
             cell.lblDuration.text = ""
             cell.lblRental.text = temp.movie_access
            cell.viewRental.isHidden = true
//                (temp.movie_access == "Free" || temp.movie_access == "")
             cell.imgThumbnail.sd_setImage(with: URL(string: temp.movie_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        }
        

        
        return cell
            

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.clnShow  {
            let resultVC : ShowDetailVC = Utilities.viewController(name: "ShowDetailVC", storyboard: "Home") as! ShowDetailVC
//            resultVC.show_id = self.shows.list[indexPath.row].show_id
            self.navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
            resultVC.movie_id = self.movies.list[indexPath.row].movie_id
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.clnShow
        {
            return CGSize(width: (ScreenWidth/2) - 20, height: 150)
        } else {
            let cellWidth = (ScreenWidth - 8) / 3
            return CGSize(width: cellWidth, height: 210)
        }
        
    }
  
}


extension SearchVC {
    
    func APISearch() {
        let param : [String:Any] = ["search_text":searchText]
        
        AlamofireModel.alamofireMethod(.post, apiAction: APIAction.search, parameters: param, Header: header, handler: {res in
            
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            self.movies.update(data["movies"])
//            self.shows.update(data["shows"])
            self.clnShow.reloadData()
            self.clnMovie.reloadData()
//            self.viewShow.isHidden = (self.shows.list.count == 0)
            self.viewMovie.isHidden = (self.movies.list.count == 0)
//            self.lblNoData.isHidden = !((self.shows.list.count == 0) && (self.movies.list.count == 0))
            
        }, errorhandler: {error in
            
        })
    }
}
