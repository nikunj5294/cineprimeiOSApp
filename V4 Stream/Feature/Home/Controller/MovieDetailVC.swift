//
//  MovieDetailVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 18/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import DropDown
import AVKit
import AVFoundation
import SVProgressHUD
import SQLite3
import FirebaseDynamicLinks
import WLM3U

class Celebritescell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
}

class MovieDetailVC: UIViewController, AVAssetDownloadDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgPosterq: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lbllike: UILabel!
    @IBOutlet weak var lblunlike: UILabel!
    @IBOutlet weak var clnMovie: UICollectionView!
    @IBOutlet weak var clncelebraties: UICollectionView!
    @IBOutlet weak var clntrailers: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMovie: UILabel!
    @IBOutlet weak var viewRental: UIView!
    @IBOutlet weak var btnWatchlist: UIButton!
    @IBOutlet weak var lblRentalMessage: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var btnSubscribeNow: UIButton!
    @IBOutlet weak var viewPlayerContainer: PlayerView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var btnRentalTag: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var imgWatchListTick: UIImageView!
    @IBOutlet weak var cnstPlayerHeight: NSLayoutConstraint!
//    @IBOutlet weak var cnstPlayViewWidth: NSLayoutConstraint!
//    @IBOutlet weak var cnstPlayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblExpiryRent: UILabel!
    @IBOutlet weak var viewtrailer: UIView!
    @IBOutlet weak var viewmoviecast: UIView!
    var isShow: Bool = false
    var movie_id = ""
    var movieDetail = MovieDetail()
    var db:DBHelper = DBHelper()
    var playerTime:Double = 0
    
    var configuration: URLSessionConfiguration?
    var downloadSession: AVAssetDownloadURLSession!
    var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    
    @IBOutlet weak var viewDownloadObj: UIView!
    @IBOutlet weak var viewDislikeObj: UIView!
    var player: AVAudioPlayer?

    @IBOutlet weak var lblHeightConstraintObj: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDislikeObj.isHidden = true
//        viewDownloadObj.isHidden = true
        //self.cnstPlayViewWidth.constant = ScreenWidth
        self.viewPlayerContainer.delegate = self
        self.APIMovieDetail()
        self.APIGetDurationWatch()
//        self.viewPlayerContainer.backgroundColor = .green
////        self.viewPlayerContainer.transform = self.viewPlayerContainer.transform.rotated(by: .pi / 2)
////        cnstPlayViewHeight.constant = 800
////        cnstPlayViewWidth.constant = 814
//        cnstPlayViewHeight.constant = 814
//        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCallReceivedMovieID(notification:)), name: Notification.Name("receivedMovieID"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewPlayerContainer.stopPlayer()
        APIAddDurationWatch()
        print("viewWillDisappear ::::: ")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear ::::: ")
    }
    
    @IBAction func btnWatchListAction(_ sender: UIButton) {
        PlayLikeButton()
        if(sender.tag == 1)
        {
            if self.movieDetail.is_available == "1" {
                APIRemoveFromWatchList()
            } else {
                APISaveToWatchList()
            }
        }else if (sender.tag == 2)
        {
            //arrdownload.add(self.movieDetail.video_url)
//            db.insert(id: 1, name: "jaydip", age: 1)
//            let view = OfflinevideoViewController.init()
//            view.reloadData()
         
//            downloadMovie(strMovie: self.movieDetail.video_url)
            
            var isAlreadyDownloaded = false
            
            if let data = UserDefaults.standard.object(forKey: OfflineDownload_KEY) as? [[String:Any]]{
                if data.count > 0{
                    data.forEach { (dictData) in
                        if dictData[MovieID_Key] as! String == self.movieDetail.movie_id && dictData[FileURL_Key] as! String == self.movieDetail.download_url{
                            isAlreadyDownloaded = true
                        }
                    }
                }
            }
            
            if !isAlreadyDownloaded{
                
                let alert = UIAlertController(title: "CINEPRIME", message: "Are you sure you want to Download?", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
                    let fileURLToDownload = URL(string: self.movieDetail.download_url)
                    let urlData = URL.createFolder(folderName: kCurrentUser.user_id)
                    
                    if fileURLToDownload != nil{
                        let destinationUrl = urlData!.appendingPathComponent("\(self.movieDetail.movie_id)+"+fileURLToDownload!.lastPathComponent)
                        
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
                        let destinationPathFinal = documentsPath.appendingPathComponent("\(kCurrentUser.user_id)/\(self.movieDetail.movie_id)+\(fileURLToDownload!.lastPathComponent)")
                        
                        let dataDict = [TitleName_Key:self.movieDetail.movie_title,
                                        FileURL_Key:self.movieDetail.download_url,
                                        imageData_Key: self.imgPoster.image?.jpegData(compressionQuality: 1.0) ?? Data(),
                                        progressData_Key: 0.0,
                                        isDownloadComplete_Key:false,
                                        MovieID_Key:self.movieDetail.movie_id,
                                        MovieFileName_Key:destinationPathFinal,
                                        MovieDuration_Key: self.movieDetail.movie_duration] as [String : Any]
                        
                        if let data = UserDefaults.standard.object(forKey: OfflineDownload_KEY) as? [[String:Any]]{
                            if data.count > 0{
                                var downloadedData = data
                                downloadedData.append(dataDict)
                                UserDefaults.standard.setValue(downloadedData, forKey: OfflineDownload_KEY)
                            }
                        }else{
                            UserDefaults.standard.setValue([dataDict], forKey: OfflineDownload_KEY)
                        }
                        
                        DMClass.sharedInstance.DownloadMovie(url: fileURLToDownload!, destinationUrl: destinationUrl)
                    }
                }
                let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
                
               
            }else{
                let alert = UIAlertController(title: "CINEPRIME", message: "This movie is already in downloaded list.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
            }
            
        }else if (sender.tag == 3)
        {
            
            callAPI()
          
        }else if (sender.tag == 4)
        {
            APImovielike()
            
        }else
        {
            APImoviedislike()
            
        }
    }
    
    
    func setupAssetDownload(videoUrl: String) {
        // Create new background session configuration.
        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
       
          // Create a new AVAssetDownloadURLSession with background configuration, delegate, and queue
        downloadSession = AVAssetDownloadURLSession(configuration: configuration!,
                                                      assetDownloadDelegate: self,
                                                      delegateQueue: OperationQueue.main)

        if let url = URL(string: videoUrl){
            let asset = AVURLAsset(url: url)

            // Create new AVAssetDownloadTask for the desired asset
            let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
                                                                     assetTitle: "Some Title",
                                                                     assetArtworkData: nil,
                                                                     options: nil)
            // Start task and begin download
            downloadTask?.resume()
        }
    }//end method

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        // Do not move the asset from the download location
        UserDefaults.standard.set(location.relativePath, forKey: "testVideoPath")
    }
    
    
    func callAPI()  {
        
        
        AppInstance.showLoader()

        guard let link = URL(string: "https://cineprime.app/myrefer.php?Id=\(self.movieDetail.movie_id)") else { return }
        let dynamicLinksDomainURIPrefix = "https://cineprime.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)

        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.CinePrime")
        linkBuilder?.iOSParameters?.appStoreID = "1561387750"
        linkBuilder?.iOSParameters?.minimumAppVersion = "3.4"

        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "ott.cineprime")
        linkBuilder?.androidParameters?.minimumVersion = 1

        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = self.movieDetail.movie_title
        linkBuilder?.socialMetaTagParameters?.descriptionText = "Click to Watch Movie"
        linkBuilder?.socialMetaTagParameters?.imageURL = URL(string: self.movieDetail.movie_image)

        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink)")
        
        linkBuilder!.shorten() { url, warnings, error in
            if let urlObj = url{
                
                AppInstance.hideLoader()

                let textShare = [ urlObj ]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func btnReadMoreAction(_ sender: UIButton)
    {
        if self.lblDescription.numberOfLines == 0 {
            self.lblDescription.numberOfLines = 3
            self.btnReadMore.setTitle("Read More", for: .normal)
        } else {
            self.lblDescription.numberOfLines = 0
            self.btnReadMore.setTitle("Read Less", for: .normal)
        }
    }
    
    @IBAction func btnPlayAction(_ sender: UIButton) {
        self.viewPlayerContainer.isHidden = false
        self.imgPoster.isHidden = true
        self.imgPosterq.isHidden = true
        self.lblMovie.isHidden = true
        self.lblDuration.isHidden = true
    
        self.viewPlayerContainer.startEpisode(videoUrl: self.movieDetail.video_url, languages: self.movieDetail.movie_language_list, resolutions: self.movieDetail.move_resolution, time: self.playerTime)
    }
    
    @IBAction func btnBackground_prassed(_ sender: UIButton) {
        self.viewPlayerContainer.isHidden = false
        self.imgPoster.isHidden = true
        self.imgPosterq.isHidden = true
        self.imgPoster.isHidden = true
        self.imgPosterq.isHidden = true
        self.lblMovie.isHidden = true
        self.lblDuration.isHidden = true
        self.viewRental.isHidden = true
        self.viewPlayerContainer.startEpisode(videoUrl: self.movieDetail.trailer_url, languages: self.movieDetail.movie_language_list, resolutions: self.movieDetail.move_resolution)
    }
    
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        /*
        let text =  "https://cineprime.page.link/\(self.movieDetail.movie_id)"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)*/
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func btnRentalTagAction(_ sender: UIButton) {
        if self.movieDetail.movie_access == "Rental" && self.movieDetail.rental_plan != "active"{
            self.APIRentalPlan()
        }
    }
    
    @IBAction func btnSubscribeAction(_ sender: UIButton) {
        
        if self.movieDetail.movie_access == "Rental" {
            self.APIRentalPlan()
        } else if self.movieDetail.movie_access == "Premium" {
            let resultVC: SubscripionPlanVC = Utilities.viewController(name: "SubscripionPlanVC", storyboard: "Settings") as! SubscripionPlanVC
           //let resultVC: InAppSubscriptionVC = Utilities.viewController(name: "InAppSubscriptionVC", storyboard: "Settings") as! InAppSubscriptionVC
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    @objc func notificationCallReceivedMovieID(notification: Notification) {
        if let movieID = notification.userInfo?["Movie_id"] as? String {
            self.movie_id = movieID
            self.APIMovieDetail()
            self.APIGetDurationWatch()
          }
    }
    
    func PlayLikeButton() {
        guard let url = Bundle.main.url(forResource: "Click", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func APICheckUserPlan() {

        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .check_user_plan, parameters: param, Header: header, handler: {res in
           
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            if self.movieDetail.download_enable == "true" && strFromJSON(data["success"]) == "1"{
                self.viewDownloadObj.isHidden = false
            }else{
                self.viewDownloadObj.isHidden = true
            }
//            self.current_plan = strFromJSON(data["current_plan"])
            
        }, errorhandler: {error in
            
        })
    }
}

extension MovieDetailVC: PlayerViewDelegate {
    func didtaptoBAck() {
        
    }
    
    func playHeightChanged(height: CGFloat, isFullMode: Bool) {
//        self.cnstPlayerHeight.constant = height
        self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: ScreenWidth, height: self.scrollView.frame.height) , animated: true)
        
        if !isFullMode {
            self.viewPlayerContainer.transform = self.viewPlayerContainer.transform.rotated(by: -(.pi / 2))
            viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
            self.imgBack.isHidden = false
            self.btnBack.isHidden = true
            self.viewPlayerContainer.layoutSubviews();//Dimple
        } else {
            let guide = self.view.safeAreaLayoutGuide
//            let heightObj = guide.layoutFrame.size.width
//            print(guide.layoutFrame.size.width)
//            print(guide.layoutFrame.size.height)
            self.viewPlayerContainer.transform = self.viewPlayerContainer.transform.rotated(by: .pi / 2)
            viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: guide.layoutFrame.size.width, height: guide.layoutFrame.size.height)
//            self.scrollView.isScrollEnabled = false
//            self.cnstPlayViewWidth.constant = self.cnstPlayerHeight.constant
//            self.cnstPlayViewHeight.constant = ScreenWidth
            
            self.imgBack.isHidden = true
            self.btnBack.isHidden = false
//            self.viewPlayerContainer.layoutSubviews();//Dimpl
            
        }
        
    }
    
    func didTapOnPlayer(isHideMode: Bool) {
        self.imgBack.isHidden =  isHideMode
        if isHideMode == true
        {
            self.imgBack.isHidden = false
        }else
        {
            self.imgBack.isHidden = true
        }
    }
}
extension MovieDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clnMovie
        {
            return self.movieDetail.related_movies.count
        }
        else if collectionView == clncelebraties
        {
            return self.movieDetail.Movie_cast.count
        }else
        {
            return 1;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clnMovie
        {
            let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.lblTitle.isHidden = true
            let temp = self.movieDetail.related_movies[indexPath.row]
            cell.lblTitle.text = temp.movie_title
            cell.lblTitle.isHidden = true
            cell.lblDuration.text = ""//temp.movie_duration
            cell.lblRental.text = temp.movie_access
            cell.viewRental.isHidden = true
//                (temp.movie_access == "Free" || temp.movie_access == "")
            cell.imgThumbnail.sd_setImage(with: URL(string: temp.movie_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            return cell
            
        }
        else if collectionView == clncelebraties
        {
            let cell : Celebritescell = collectionView.dequeueReusableCell(withReuseIdentifier: "Celebritescell", for: indexPath) as! Celebritescell
            let temp = self.movieDetail.Movie_cast[indexPath.row]
            cell.lblTitle.text = temp.name
            cell.imgThumbnail.sd_setImage(with: URL(string: temp.image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            cell.imgThumbnail.layer.cornerRadius = cell.imgThumbnail.frame.size.width / 2.0;
            cell.imgThumbnail.layer.borderWidth = 3.0
            cell.imgThumbnail.layer.borderColor = UIColor.white.cgColor;
            cell.imgThumbnail.clipsToBounds = true
            return cell
        }
        else
        {
            let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            
            cell.imgThumbnail.sd_setImage(with: URL(string: self.movieDetail.movie_image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            cell.btnBackground.addTarget(self, action: #selector(btnBackground_prassed), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == clnMovie
        {
            let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
            resultVC.movie_id = self.movieDetail.related_movies[indexPath.row].movie_id
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clnMovie
        {
            let cellWidth = (ScreenWidth - 8) / 3
            return CGSize(width: cellWidth, height: 210)
        }
        else if collectionView == clncelebraties
        {
            return CGSize(width: 130, height: 115)
        }
        else
        {
            return CGSize(width: 170, height: 120)
        }
    }
    
    func setData() {
        
        if self.movieDetail.trailer_url.count == 0
        {
            viewtrailer.isHidden = true
            viewPlayerContainer.isTrailer = false
        }else{
            viewPlayerContainer.isTrailer = true
        }
        if self.movieDetail.Movie_cast.count == 0
        {
            viewmoviecast.isHidden = true
        }
        
        
        self.clnMovie.reloadData()
        self.clncelebraties.reloadData()
        self.clntrailers.reloadData()
        self.imgPoster.isHidden = false
        self.imgPosterq.isHidden = false
        self.imgPoster.sd_setImage(with: URL(string: self.movieDetail.movie_image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        self.lblTitle.text = self.movieDetail.movie_title
        self.lblMovieName.text = self.movieDetail.movie_title
        self.lblDate.text = self.movieDetail.release_date
        
        self.lblDuration.text = self.movieDetail.movie_duration
        
//        let temp = self.movieDetail.genre_list.map({$0.genre_name})
//        
//        if temp.count > 0 {
//            self.lblGenre.text = temp[0]
//        } else {
//            self.lblGenre.text = "-"
//        }
//        
       
        self.lblLanguage.text = self.movieDetail.language_name
        
        let height = getHeight(text: self.movieDetail.description.html2String.description as NSString , width: self.lblDescription.frame.size.width, font: self.lblDescription.font)
        print("_______+++++++++ : \(height)")
        self.lblDescription.text = self.movieDetail.description.html2String
        lblHeightConstraintObj.constant = height
        
        if self.movieDetail.is_available == "1"  {
            self.imgWatchListTick.image = UIImage(named: "tick")
        } else {
            self.imgWatchListTick.image = UIImage(named: "plus")
        }
        
        self.viewRental.isHidden = (self.movieDetail.movie_access == "Free")
        self.viewRental.isHidden = true
        
        
        if self.movieDetail.movie_access == "Premium" && !boolFromStr(self.movieDetail.check_plan) && !isInAppPremium {
            self.lblRentalMessage.text  = "You need a premium membership to watch this video. Click here to start your membership"
            self.btnSubscribeNow.setTitle("Subscribe Now", for: .normal)
            self.viewRental.isHidden = false
        } else if self.movieDetail.movie_access == "Rental" && self.movieDetail.rental_plan != "active" {
            self.lblRentalMessage.text  = "To watch this video, you need to rent it. Click here to rent movie"
            self.btnSubscribeNow.setTitle("Rent Now", for: .normal)
            self.view.layoutIfNeeded()
            self.viewRental.isHidden = false
        } else {
            //            self.viewPlayerContainer.isHidden = false
            //            self.viewPlayerContainer.startEpisode(videoUrl: self.movieDetail.video_url, languages: self.movieDetail.videos, resolutions: self.movieDetail.move_resolution)
        }
        
        //self.btnRentalTag.isHidden = true
        if self.movieDetail.movie_access == "Rental" {
//            self.btnRentalTag.isHidden = false
//
//            if self.movieDetail.rental_plan != "active" {
//                self.btnRentalTag.setTitle("RENTAL", for: .normal)
//            } else {
//                self.btnRentalTag.setTitle("RENTED", for: .normal)
//                self.lblExpiryRent.text = self.movieDetail.rent_expire_on
//            }
        }
    }
}

extension MovieDetailVC {
    
    func APIMovieDetail() {
        
        var param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        var api = APIAction.movies_details1
        if isShow {
            param["show_id"] = self.movie_id
            api = APIAction.show_details
        } else {
            param["movie_id"] = self.movie_id
        }
        AlamofireModel.alamofireMethod(.post, apiAction: api, parameters: param, Header: header, handler: {res in
            
            self.movieDetail.update(res.originalJSON)
            self.APICheckUserPlan()
            self.setData()
            self.viewNoData.isHidden = true
            self.APILikeCOUNT()
            
        }, errorhandler: {error in
            
        })
    }
    
    
    func APISaveToWatchList() {
        
        //getWatchList()
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_videos_id": self.movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .save_to_watchlist, parameters: param, Header: header,is64Bit: false, handler: {res in
            
            self.movieDetail.is_available = "1"
            self.imgWatchListTick.image = UIImage(named: "tick")
            AppInstance.showMessages(message: strFromJSON(res.originalJSON["message"]))
            
            
        }, errorhandler: {error in
            
        })
    }
    
    func APIAddDurationWatch() {
        
        //getWatchList()
//        "duration":viewPlayerContainer.avPlayer.tie
        if viewPlayerContainer.videoPlayerItem == nil{
            return
        }
        
        let milli = viewPlayerContainer.videoPlayerItem!.currentTime().seconds * 1000
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_id": self.movie_id,
                                    "duration":"\(milli)"]
        
        print("APIAddDurationWatch : \(param)")
        
        AlamofireModel.alamofireMethod(.post, apiAction: .c_watchlist_add, parameters: param, Header: header,is64Bit: false, handler: {res in
            
            print(res.originalJSON)
            
//            self.movieDetail.is_available = "1"
//            self.imgWatchListTick.image = UIImage(named: "tick")
//            AppInstance.showMessages(message: strFromJSON(res.originalJSON["message"]))
            
            
        }, errorhandler: {error in
            
        })
    }
    
    func APIGetDurationWatch() {
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_id": self.movie_id]
        
        print("APIGetDurationWatch : \(param)")
        
        AlamofireModel.alamofireMethod(.post, apiAction: .c_watchlist_get, parameters: param, Header: header,is64Bit: false, handler: {res in
                        
            let json = res.originalJSON["VIDEO_STREAMING_APP"]
            print("c_watchlist_get : \(strFromJSON(json[0]["duration"]))")
            
            if strFromJSON(json[0]["duration"]) != "00:00:00"{
                self.playerTime = Double(strFromJSON(json[0]["duration"]))!/1000
            }
            
//            self.movieDetail.is_available = "1"
//            self.imgWatchListTick.image = UIImage(named: "tick")
//            AppInstance.showMessages(message: strFromJSON(res.originalJSON["message"]))
            
            
        }, errorhandler: {error in
            
        })
    }
    
    func APImovielike() {
        
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_id": self.movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .movielike, parameters: param, Header: header, tryAgainOnFail: true, isLoader: false, handler: {res in
            
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            self.lbllike.text = strFromJSON(data["Like"])
            if strFromJSON(data["Like"]) == "0"
            {
                self.lbllike.text = "Like"
            }
            
            self.lblunlike.text = strFromJSON(data["Dislike"])
            if strFromJSON(data["Dislike"]) == "0"
            {
                self.lblunlike.text = "Dislike"
            }
            
        }, errorhandler: {error in
            
        })
    }
    
    func APImoviedislike() {
        
        //getWatchList()
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_id": self.movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .moviedislike, parameters: param, Header: header, tryAgainOnFail: true, isLoader: false, handler: {res in
            
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            self.lbllike.text = strFromJSON(data["Like"])
            if strFromJSON(data["Like"]) == "0"
            {
                self.lbllike.text = "Like"
            }
            
            self.lblunlike.text = strFromJSON(data["Dislike"])
            if strFromJSON(data["Dislike"]) == "0"
            {
                self.lblunlike.text = "Dislike"
            }
            
        }, errorhandler: {error in
            
        })
    }
    
    func APILikeCOUNT() {
        
        //getWatchList()
        
        let param : [String:Any] = ["movie_id": self.movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .movielikecount, parameters: param, Header: header, tryAgainOnFail: true, isLoader: false, handler: {res in
            
            let data = res.originalJSON["VIDEO_STREAMING_APP"][0]
            self.lbllike.text = strFromJSON(data["Like"])
            if strFromJSON(data["Like"]) == "0"
            {
                self.lbllike.text = "Like"
            }
            
            self.lblunlike.text = strFromJSON(data["Dislike"])
            if strFromJSON(data["Dislike"]) == "0"
            {
                self.lblunlike.text = "Dislike"
            }
            
        }, errorhandler: {error in
            
        })
    }
    
    
    func APIRemoveFromWatchList() {
        
        
        let param : [String:Any] = ["user_id": kCurrentUser.user_id,
                                    "movie_videos_id": self.movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .remove_watchlist_video, parameters: param, Header: header,is64Bit: false, handler: {res in
            
            self.movieDetail.is_available = "0"
            self.imgWatchListTick.image = UIImage(named: "plus")
            
            AppInstance.showMessages(message: strFromJSON(res.originalJSON["message"]))
            // self.getWatchList()
            
        }, errorhandler: {error in
            
        })
        
    }
    
    func APIRentalPlan() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id, "show_id":"0","movie_id": self.movie_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .rental_plan, parameters: param, Header: header, handler: {res in
            let rentals = Subscription()
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            rentals.update(data)
            
            if rentals.list.count > 0 {
                
                let resultVC: PurchaseSubscriptionVC = Utilities.viewController(name: "PurchaseSubscriptionVC", storyboard: "Settings") as! PurchaseSubscriptionVC
                resultVC.movie_id = self.movie_id
                resultVC.selectedPlan = rentals.list[0]
                resultVC.isRental = true
                self.navigationController?.pushViewController(resultVC, animated: true)
                
            }
            
            
        }, errorhandler: {error in
            
        })
    }
}

class Person
{
    var progress: String = ""
    var totalMB: String = ""
    var Title: String = ""
    var fullfile: String = ""
    var id: Int = 0
    
    init(progress:String, totalMB:String, Title:String,fullfile:String,id : Int)
    {
        self.progress = progress
        self.totalMB = totalMB
        self.Title = Title
        self.fullfile = fullfile
        self.id = id
        
    }
    
}

extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}


extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}


func getHeight(text:  NSString, width:CGFloat, font: UIFont) -> CGFloat
{
    let rect = text.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: ([NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading]), attributes: [NSAttributedString.Key.font:font], context: nil)
    return rect.size.height
}
