//
//  SeasionDetailVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 14/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import DropDown

class ShowDetailVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewRental: UIView!
    @IBOutlet weak var lblRentalMessage: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var btnSubscribeNow: UIButton!
    @IBOutlet weak var viewPlayerContainer: PlayerView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var tblSeaon: UITableView!
    @IBOutlet weak var tblSeasionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSelectSeasion: UIButton!
    @IBOutlet weak var lblEpisodeHeader: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var cnstPlayerHeight: NSLayoutConstraint!
//    @IBOutlet weak var cnstPlayViewWidth: NSLayoutConstraint!
//    @IBOutlet weak var cnstPlayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var show_id = ""
    var showDetail = ShowDetail()
    var selectedSeasion = SeasonData()
    var episode = Episode()
    var selectedEpisode = EpisodeData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.cnstPlayViewWidth.constant = ScreenWidth
        self.viewPlayerContainer.delegate = self
        self.APIShowDetail()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewPlayerContainer.stopPlayer()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSeasionDropDownAction(_ sender: UIButton) {
        
        /*
        let dropDown = DropDown()
        dropDown.anchorView = self.btnSelectSeasion
        dropDown.width = self.btnSelectSeasion.frame.width
        dropDown.dataSource = self.showDetail.season_list.map({$0.season_name})
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if self.selectedSeasion.season_name != item {
                self.lblEpisodeHeader.text = item
                self.selectedSeasion = self.showDetail.season_list[index]
                self.APISGetEpisodes()
                dropDown.hide()
            }

        }*/
        
    }
    
    @IBAction func btnPlayAction(_ sender: UIButton) {
        self.viewPlayerContainer.isHidden = false
        self.viewPlayerContainer.startEpisode(videoUrl: self.selectedEpisode.video_url, languages: [], resolutions: self.selectedEpisode.resolutions)
    }
        
    @IBAction func btnSubscribeAction(_ sender: UIButton) {
        
        if self.showDetail.show_video_access.lowercased() == "rental" {
            self.APIRentalPlan()
        } else if self.showDetail.show_video_access.lowercased() == "premium" {
           // let resultVC: SubscripionPlanVC = Utilities.viewController(name: "SubscripionPlanVC", storyboard: "Settings") as! SubscripionPlanVC
            let resultVC: InAppSubscriptionVC = Utilities.viewController(name: "InAppSubscriptionVC", storyboard: "Settings") as! InAppSubscriptionVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }

    
    func setData() {
        
        self.lblTitle.text = self.showDetail.show_name
        let temp = self.showDetail.genre_list.map({$0.genre_name})
        if temp.count > 0 {
            self.lblGenre.text = temp[0]
        } else {
            self.lblGenre.text = "-"
        }
        self.imgPoster.sd_setImage(with: URL(string: self.showDetail.show_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        
        self.lblMovieName.text = self.selectedEpisode.episode_title
        self.lblEpisodeHeader.text = self.showDetail.show_name
        
        
        self.tblSeasionHeight.constant = CGFloat(self.episode.list.count * 120)
        self.tblSeaon.reloadData()
        self.lblDate.text = self.selectedEpisode.release_date
        self.lblDuration.text = self.selectedEpisode.duration
        self.lblLanguage.text = self.selectedEpisode.language_name


        self.viewRental.isHidden = true
        self.viewPlayerContainer.isHidden = true
        self.viewPlayerContainer.stopPlayer()
        
        if self.selectedEpisode.video_access.lowercased() != "free" && self.showDetail.show_video_access.lowercased() == "premium" && (self.selectedEpisode.check_plan == "false" || self.selectedEpisode.check_plan == "0") && !isInAppPremium {
            
            self.lblRentalMessage.text  = "You need a premium membership to watch this video. Click here to start your membership"
            self.btnSubscribeNow.setTitle("Subscribe Now", for: .normal)
            self.viewRental.isHidden = false
            
        } else if self.selectedEpisode.video_access.lowercased() != "free" && self.selectedEpisode.video_access.lowercased() == "rental" && self.selectedEpisode.rental_plan != "active" {
            
            self.lblRentalMessage.text  = "To watch this video, you need to rent it. Click here to rent movie"
            self.btnSubscribeNow.setTitle("Rent Now", for: .normal)
            self.view.layoutIfNeeded()
            self.viewRental.isHidden = false
            
        } else {
            
//            self.viewPlayerContainer.isHidden = false
//            self.viewPlayerContainer.startEpisode(videoUrl: self.selectedEpisode.video_url, languages: [], resolutions: self.selectedEpisode.resolutions)
            
        }

        
    }

}

extension ShowDetailVC: PlayerViewDelegate {
    
    func didTapOnPlayer(isHideMode: Bool) {
        self.imgBack.isHidden =  isHideMode
    }
    
    func didtaptoBAck() {
        
    }
    func playHeightChanged(height: CGFloat, isFullMode: Bool) {
        
        self.cnstPlayerHeight.constant = height
        self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: ScreenWidth, height: self.scrollView.frame.height) , animated: true)
        
        if !isFullMode {
            self.scrollView.isScrollEnabled = true
//            self.cnstPlayViewWidth.constant = ScreenWidth
//            self.cnstPlayViewHeight.constant =  self.cnstPlayerHeight.constant
            self.viewPlayerContainer.transform = self.viewPlayerContainer.transform.rotated(by: -(.pi / 2))
            viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
            self.imgBack.isHidden = false
        } else {
            self.scrollView.isScrollEnabled = false
//            self.cnstPlayViewWidth.constant = self.cnstPlayerHeight.constant
//            self.cnstPlayViewHeight.constant = ScreenWidth
            let guide = self.view.safeAreaLayoutGuide
            self.viewPlayerContainer.transform = self.viewPlayerContainer.transform.rotated(by: .pi / 2)
            viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: guide.layoutFrame.size.width, height: guide.layoutFrame.size.height)
            self.imgBack.isHidden = true
        }
        
    }
    
}

extension ShowDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episode.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SeasionCell = tableView.dequeueReusableCell(withIdentifier: "SeasionCell", for: indexPath) as! SeasionCell
        
        let temp = self.episode.list[indexPath.row]
        
        if self.selectedEpisode.episode_title == temp.episode_title {
            cell.lblTitle.textColor = appColors.red
        } else {
            cell.lblTitle.textColor = .white
        }
        
        cell.lblTitle.text = temp.episode_title
        cell.imgMain.sd_setImage(with: URL(string: temp.episode_image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEpisode = self.episode.list[indexPath.row]
        self.tblSeaon.reloadData()
        self.setData()
    }
}
extension ShowDetailVC {
    
    func APIShowDetail() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "show_id": self.show_id]

        AlamofireModel.alamofireMethod(.post, apiAction: .show_details, parameters: param, Header: header, handler: {res in
            self.showDetail.update(res.originalJSON["VIDEO_STREAMING_APP"])
            
            if self.showDetail.season_list.count > 0 {
                self.selectedSeasion =  self.showDetail.season_list[0]
                self.APISGetEpisodes()
            }
            
        }, errorhandler: {error in
            
        })
    }
    
    
    func APISGetEpisodes() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    //"series_id": self.selectedSeasion.season_id,
                                    "series_id": self.show_id,
                                    
        ]

        AlamofireModel.alamofireMethod(.post, apiAction: .episode1, parameters: param, Header: header, handler: {res in
            
            self.episode = Episode()
            self.episode.update(res.originalJSON["VIDEO_STREAMING_APP"])
            if self.episode.list.count > 0 {
                self.selectedEpisode = self.episode.list[0]
                self.setData()
                self.viewNoData.isHidden = true
            }
            
        }, errorhandler: {error in
            
        })
    }
    
    func APIRentalPlan() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id, "show_id": self.show_id,"movie_id": "0"]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .rental_plan, parameters: param, Header: header, handler: {res in
            let rentals = Subscription()
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            rentals.update(data)
            
            if rentals.list.count > 0 {
             
                let resultVC: PurchaseSubscriptionVC = Utilities.viewController(name: "PurchaseSubscriptionVC", storyboard: "Settings") as! PurchaseSubscriptionVC
                resultVC.show_id = self.show_id
                resultVC.selectedPlan = rentals.list[0]
                resultVC.selectedPlan .plan_price = self.selectedEpisode.rental_price
                resultVC.isRental = true
                self.navigationController?.pushViewController(resultVC, animated: true)
                
            }
            
            
        }, errorhandler: {error in
            
        })
    }
}
