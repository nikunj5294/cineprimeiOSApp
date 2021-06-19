//
//  PlayVideoVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 08/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown

class PlayVideoVC: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewSettingsMain: UIView!
    @IBOutlet weak var cnstSettingsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgSettings: UIImageView!
    
    
    var paused: Bool = false
    var timer : Timer? = nil
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    var movieDetail = MovieDetail()
    var videoURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoURL = self.movieDetail.video_url
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupMoviePlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.avPlayer?.pause()
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSettingsAction(_ sender: UIButton) {
        
        self.cnstSettingsViewHeight.constant = 0
        self.viewSettingsMain.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.cnstSettingsViewHeight.constant = 70
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnCloseSettingsAction(_ sender: UIButton) {
        self.closeSettings()
    }
    
    @IBAction func btnQualityAction(_ sender: UIButton) {
        closeSettings()
        
        let dropDown = DropDown()
        dropDown.anchorView = self.imgSettings
        dropDown.width = 150
        dropDown.dataSource = self.movieDetail.move_resolution.map({$0.movie_resolution})
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.videoURL = self.movieDetail.move_resolution[index].movie_url
            self.paused = false
            self.videoURL = self.movieDetail.videos[index].url
            let time = self.videoPlayerItem!.currentTime().seconds
            let url = URL(string: self.videoURL)
            self.videoPlayerItem = AVPlayerItem.init(url:url!)
            self.avPlayer?.play()
            self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
            
        }

    }
    
    @IBAction func btnLanguageAction(_ sender: UIButton) {
        closeSettings()
        
        let dropDown = DropDown()
        dropDown.anchorView = self.imgSettings
        dropDown.width = 150
        dropDown.dataSource = self.movieDetail.videos.map({$0.language})
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            self.paused = false
            self.videoURL = self.movieDetail.videos[index].url
            let time = self.videoPlayerItem!.currentTime().seconds
            let url = URL(string: self.videoURL)
            self.videoPlayerItem = AVPlayerItem.init(url:url!)
            self.avPlayer?.play()
            self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
        }
        
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if self.paused {
            return
        }
        
        let time = self.videoPlayerItem!.currentTime().seconds + 10.0
        
        self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    @IBAction func btnPlayAction(_ sender: UIButton) {
        if self.paused {
                    self.paused = false
                    self.avPlayer?.play()
                    self.timer?.fire()//play //pause
                    self.imgPlay.image = UIImage(named: "pause")
  
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if self.videoPlayerItem != nil {
//                            self.lblTimer.text = Int(self.videoPlayerItem!.currentTime().seconds).description + " seconds"
                        }
                    }
                    
                } else  {
                    self.timer?.invalidate()
                    self.paused = true
                    self.imgPlay.image = UIImage(named: "play")
                    self.avPlayer?.pause()
                }
        

    }
    
    @IBAction func btnPreviuosAction(_ sender: UIButton) {
        if self.paused {
            return
        }
        
        let time = self.videoPlayerItem!.currentTime().seconds - 10.0
        
        self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func closeSettings() {
        UIView.animate(withDuration: 0.5, animations: {
            self.cnstSettingsViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.viewSettingsMain.isHidden = true
        })
    }
    
    func setupMoviePlayer(){
            self.paused = false
            self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            avPlayer?.volume = 3
            avPlayer?.actionAtItemEnd = .none
            avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: viewMain.frame.width, height: viewMain.frame.height)
            self.viewMain.layer.insertSublayer(avPlayerLayer!, at: 0)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: avPlayer?.currentItem)
            
            let url = URL(string: videoURL)
            self.videoPlayerItem = AVPlayerItem.init(url:url!)
            self.avPlayer?.play()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
    }
}

