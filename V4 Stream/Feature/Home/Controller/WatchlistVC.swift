//
//  WatchlistVC.swift
//  V4 Stream
//
//  Created by jaydip kapadiya on 18/03/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class WatchlistVC: UIViewController {

    var arrtemp = NSArray()
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var viewerror: UIView!
    var watchlist = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        APIwatchlist()
        
        if watchlist != 1
        {
            btnback.isHidden = true
            SharedManager.sharedInstance().addTabBar(self)
            SharedManager.sharedInstance().bringTabbarToFront()
            SharedManager.sharedInstance().footerController?.btnHome.isSelected = false//true
            SharedManager.sharedInstance().footerController?.btnMovie.isSelected = false
    //      SharedManager.sharedInstance().footerController?.btnPremium.isSelected = false
            SharedManager.sharedInstance().footerController?.btnSeries.isSelected = false
            SharedManager.sharedInstance().footerController?.btnMore.isSelected = false
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func APIwatchlist() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        Tagss = 1
        let api = APIAction.get_watchlist
       
        AlamofireModel.alamofireMethod(.post, apiAction: api, parameters: param, Header: header, handler: {res in
            Tagss = 0
            let jsonText = strFromJSON(res.originalJSON)
            var dictonary:NSDictionary?
            
            if let data = jsonText.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                    
                    if let myDictionary = dictonary
                    {
                        let arreatch = myDictionary["VIDEO_STREAMING_APP"] as? NSArray ?? []
                        if arreatch.count != 0
                        {
                            let dict = arreatch[0]as? NSDictionary ?? [:]
                            self.arrtemp = dict["data"]as? NSArray ?? []
                            if self.arrtemp.count == 0
                            {
                                self.viewerror.isHidden = false
                            }else{
                                self.viewerror.isHidden = true
                            }
                        }
                       else
                        {
                            self.viewerror.isHidden = false
                        }
                    }
                    self.collection.delegate = self
                    self.collection.dataSource  = self
                    self.collection.reloadData()
                } catch let error as NSError {
                    print(error)
                }
            }
           
            
        }, errorhandler: {error in
            
        })
    }
    
    func APIRemoveFromWatchList(movie_id : String) {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_videos_id": movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .remove_watchlist_video, parameters: param, Header: header,is64Bit: false, handler: {res in

            self.APIwatchlist()
            
        }, errorhandler: {error in
            
        })
    }
}

extension WatchlistVC:UICollectionViewDelegate,UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrtemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let temp = arrtemp[indexPath.row] as? NSDictionary ?? [:]
        cell.imgThumbnail.sd_setImage(with: URL(string: temp["movie_poster"]as? String ?? ""), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        cell.lblDuration.text = temp["duration"]as? String ?? ""
        cell.lblTitle.text = temp["movie_title"]as? String ?? " "
        cell.lblRental.text =  temp["movie_language"]as? String ?? " "
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked),
                                     for: .touchUpInside)
       // cell.lblTitle.isHidden = true
        cell.btnPlay.layer.cornerRadius = 15.0
        cell.btnPlay.clipsToBounds = true
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(btnPlay_Clicked),
                                 for: .touchUpInside)
        return cell
    }
    
    @objc func btnDelete_Clicked(sender:UIButton)
    {
        let temp = arrtemp[sender.tag] as? NSDictionary ?? [:]
        self.APIRemoveFromWatchList(movie_id: temp["movie_videos_id"]as? String ?? (temp["movie_videos_id"]as? Int)?.description ?? "")
        
    }
    
    @objc func btnPlay_Clicked(sender:UIButton)
    {
        let temp = arrtemp[sender.tag] as? NSDictionary ?? [:]
        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
        resultVC.movie_id = temp["movie_videos_id"]as? String ?? (temp["movie_videos_id"]as? Int)?.description ?? ""
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let temp = arrtemp[indexPath.row] as? NSDictionary ?? [:]
        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
        resultVC.movie_id = temp["movie_videos_id"]as? String ?? ""
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (ScreenWidth - 20), height: 120)
        
    }
}

