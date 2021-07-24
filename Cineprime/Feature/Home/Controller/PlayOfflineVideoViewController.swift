//
//  PlayOfflineVideoViewController.swift
//  V4 Stream
//
//  Created by MAC on 27/05/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SVProgressHUD

class PlayOfflineVideoViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgPosterq: UIImageView!
    @IBOutlet weak var lblMovie: UILabel!
    @IBOutlet weak var viewPlayerContainer: PlayerView!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var cnstPlayerHeight: NSLayoutConstraint!
//    @IBOutlet weak var cnstPlayViewWidth: NSLayoutConstraint!
//    @IBOutlet weak var cnstPlayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblMovieName: UILabel!
    
    var isShow: Bool = false
    var movie_id = ""
    var movieDetail = MovieDetail()
    var db:DBHelper = DBHelper()
    var playerTime:Double = 0
    
    var configuration: URLSessionConfiguration?
    var downloadSession: AVAssetDownloadURLSession!
    var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    
    var downloadedData = [String:Any]()
    var downloadedURL = ""
    var player : AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPlayerContainer.delegate = self
        
        downloadedURL = downloadedData[MovieFileName_Key] as! String
//        lblMovie.text = downloadedData[TitleName_Key] as? String
        lblMovieName.text = downloadedData[TitleName_Key] as? String
        let imageData = downloadedData[imageData_Key] as! Data
        self.imgPoster.image = UIImage(data: imageData)
        lblDuration.text = downloadedData[MovieDuration_Key] as? String
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewPlayerContainer.stopPlayer()
    }
    

    @IBAction func btnPlayAction(_ sender: UIButton) {
        self.viewPlayerContainer.isHidden = false
        self.imgPoster.isHidden = true
        self.imgPosterq.isHidden = true
        self.lblMovie.isHidden = true
        self.lblDuration.isHidden = true
        self.viewPlayerContainer.startVideoOffile(videoUrl: "file://\(downloadedURL)")

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        SVProgressHUD.dismiss()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayOfflineVideoViewController: PlayerViewDelegate {
    func didtaptoBAck() {
        
    }
    
    func playHeightChanged(height: CGFloat, isFullMode: Bool) {
        
        if !isFullMode {
            lblMovieName.isHidden = false
            self.viewPlayerContainer.transform = self.viewPlayerContainer.transform.rotated(by: -(.pi / 2))
            viewPlayerContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
            self.imgBack.isHidden = false
            self.btnBack.isHidden = true
            self.viewPlayerContainer.layoutSubviews();//Dimple
        } else {
            lblMovieName.isHidden = true
            let guide = self.view.safeAreaLayoutGuide
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

extension URL    {
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}
