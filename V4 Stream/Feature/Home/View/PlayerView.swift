//
//  PlayerView.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 13/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import DropDown

protocol PlayerViewDelegate {
    func didTapOnPlayer(isHideMode: Bool)
    func didtaptoBAck()
    func playHeightChanged(height: CGFloat, isFullMode: Bool)
}

class PlayerView: UIView {
    
    let nibName = "PlayerView"
   // var contentView: UIView?
    
    @IBOutlet weak var viewMain: UIView!
//    @IBOutlet weak var viewPlayercontainer: UIView!
//    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewSettingsMain: UIView!
    @IBOutlet weak var cnstSettingsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgSettings: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var slidderView: UISlider!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnlock: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var cnstViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var optionViewWidthObj: NSLayoutConstraint!
    @IBOutlet weak var ViewPlayerContainerWidthObj: NSLayoutConstraint!
    @IBOutlet weak var ViewPlayerContainerHeightObj: NSLayoutConstraint!

    
    var delegate: PlayerViewDelegate?
    var observerSet: Bool = false
    var paused: Bool = true
    var timer : Timer? = nil
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    @IBOutlet weak var imgFullScreen: UIImageView!
    @IBOutlet weak var btnFullScreen: UIButton!
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    var languages: [LanguageData] = [LanguageData]()
    var resolutions: [ResolutionData] = [ResolutionData]()
    var videoURL = ""
    var isFullScreen: Bool = false
    var height: CGFloat = 200
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        //contentView = view
        self.slidderView.isUserInteractionEnabled = false
        
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        
        setupMoviePlayer()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.optionViewWidthObj.constant = UIScreen.main.bounds.width
            self.ViewPlayerContainerWidthObj.constant = self.optionViewWidthObj.constant
        }
        
        
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        if self.self.videoPlayerItem != nil {
            let time = (self.videoPlayerItem!.duration.seconds * Double(sender.value))
            self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
            print("Time in seconds", time)
        }

    }

    @IBAction func btnFullScreenAction(_ sender: UIButton)
    {
        self.btnFullScreen.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.btnFullScreen.isUserInteractionEnabled = true
        }
        
        if !isFullScreen {
            self.imgFullScreen.image = UIImage(named: "exit")
            isFullScreen = true
            height = ScreenHeight - Utilities.statusBarHeight()
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let topPadding = window?.safeAreaInsets.top
                let bottomPadding = window?.safeAreaInsets.bottom
                height = ScreenHeight  - bottomPadding! - topPadding!
            }
            
        } else {
            height = 200
            self.imgFullScreen.image = UIImage(named: "fullScreen")
            isFullScreen = false
        }
        
        self.avPlayerLayer?.removeFromSuperlayer()
        
        if isFullScreen {
//             btnlock.isHidden = false
            
            if let topVC = UIApplication.getTopViewController() {
                let guide = topVC.view.safeAreaLayoutGuide
                let heightObj = guide.layoutFrame.size.width
                ViewPlayerContainerWidthObj.constant = guide.layoutFrame.size.height
                ViewPlayerContainerHeightObj.constant = guide.layoutFrame.size.width
                avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: guide.layoutFrame.size.height, height: ScreenWidth)
                optionViewWidthObj.constant = guide.layoutFrame.size.height
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: guide.layoutFrame.size.height, height: guide.layoutFrame.size.width)
                print(guide)
                print(heightObj)
            }
//            self.frame = CGRect(x: 0, y: 0, width: height, height: ScreenWidth)//Dimple
//            self.viewOptions.frame = CGRect(x: 0, y: ScreenWidth-70, width: height, height: 70)
            
        } else {
//            avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
//            optionViewWidthObj.constant = UIScreen.main.bounds.width
//            self.frame = CGRect(x: 0, y: 0, width: height, height: ScreenWidth)//Dimple
//            btnlock.isHidden = true
//            print(self.viewBottom.frame)
            
            let heightObj:CGFloat = 230
            
                ViewPlayerContainerWidthObj.constant = UIScreen.main.bounds.size.width
                ViewPlayerContainerHeightObj.constant = heightObj
                optionViewWidthObj.constant = UIScreen.main.bounds.size.width
                self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heightObj)
                avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200)
             
//            ViewPlayerContainerWidthObj.constant = optionViewWidthObj.constant

        }
        
        self.delegate?.playHeightChanged(height: height, isFullMode: isFullScreen)
        viewOptions.layoutIfNeeded()
        self.layoutIfNeeded()
        self.viewMain.layer.insertSublayer(avPlayerLayer!, at: 0)
        self.viewMain.layoutIfNeeded()
        self.avPlayerLayer?.layoutIfNeeded()
        if let topVC = UIApplication.getTopViewController() {
            topVC.view.bringSubviewToFront(viewOptions)
        }
        
    }
    
    @IBAction func btnLock(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            self.cnstSettingsViewHeight.constant = 20
            viewBottom.isHidden = true
            self.layoutIfNeeded()
        }else
        {
            sender.isSelected = true
            viewBottom.isHidden = false
            self.cnstSettingsViewHeight.constant = 70
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func btnTapOnPlayerAction(_ sender: UIButton) {
       
        self.viewOptions.isHidden = !self.viewOptions.isHidden
        if !self.isFullScreen {
            self.delegate?.didTapOnPlayer(isHideMode: self.viewOptions.isHidden)
        }
    }
    
    @IBAction func btnSettingsAction(_ sender: UIButton) {
        if self.languages.count == 0 {
            self.btnQualityAction(UIButton())
            return
            
        }
        self.cnstSettingsViewHeight.constant = 0
        self.viewSettingsMain.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.cnstSettingsViewHeight.constant = 70
            self.layoutIfNeeded()
        })
    }
        
    @IBAction func btnCloseSettingsAction(_ sender: UIButton) {
        self.closeSettings()
    }
    
      
    @IBAction func btnQualityAction(_ sender: UIButton) {
        closeSettings()
        
        let dropDown = DropDown()
        dropDown.anchorView = self.imgSettings
        dropDown.direction = .top
        dropDown.width = 150
        dropDown.dataSource = self.resolutions.map({$0.movie_resolution})
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.startEpisode(videoUrl: self.resolutions[index].movie_url, languages: self.languages, resolutions: self.resolutions, time: self.videoPlayerItem!.currentTime().seconds)
            
            /*
             self.videoURL = self.resolutions[index].movie_url
             self.paused = false
             let time = self.videoPlayerItem!.currentTime().seconds
             let url = URL(string: self.videoURL)
             self.removeObserver()
             self.videoPlayerItem = AVPlayerItem.init(url:url!)
             self.addObserver()
             self.avPlayer?.play()
             self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero) */
            
        }
        
    }
        
    @IBAction func btnLanguageAction(_ sender: UIButton) {
        closeSettings()
        
        let dropDown = DropDown()
        dropDown.anchorView = self.imgSettings
        dropDown.direction = .top
        dropDown.width = 150
        dropDown.dataSource = self.languages.map({$0.movie_language})
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.startEpisode(videoUrl: self.languages[index].movie_audio_url, languages: self.languages, resolutions: self.resolutions, time: self.videoPlayerItem!.currentTime().seconds)
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
            self.timer?.fire()
            self.imgPlay.image = UIImage(named: "pause")
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if self.videoPlayerItem != nil {
                    if self.videoPlayerItem != nil {
                        
                        if  self.videoPlayerItem!.duration.seconds > 0  {
                            self.slidderView.isUserInteractionEnabled = true
                            self.progressView.progress = Float(self.videoPlayerItem!.currentTime().seconds / self.videoPlayerItem!.duration.seconds)
                            self.slidderView.value = Float(self.videoPlayerItem!.currentTime().seconds / self.videoPlayerItem!.duration.seconds)
                            self.lblCurrentTime.text = self.getFormattegTime(Int(self.videoPlayerItem!.currentTime().seconds))
                            self.lblTotalTime.text = self.getFormattegTime(Int(self.videoPlayerItem!.duration.seconds))
                            
                        } else {
                            self.slidderView.isUserInteractionEnabled = false
                        }
                    }
                    
                }
            }
            
        } else  {
            self.timer?.invalidate()
            self.paused = true
            self.imgPlay.image = UIImage(named: "play")
            self.avPlayer?.pause()
        }
    }
    
    func getFormattegTime(_ time: Int) -> String  {
        
        let h = Int(time/3600)
        let m = (time - (h*3600)) / 60
        let s = (time - (h*3600) - (m*60))
        
        return "\(h):\(m):\(s)"
        
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
                self.layoutIfNeeded()
            }, completion: {_ in
                self.viewSettingsMain.isHidden = true
            })
        }
        
    func setupMoviePlayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        self.viewMain.layer.insertSublayer(avPlayerLayer!, at: 0)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    func startEpisode(videoUrl: String, languages: [LanguageData], resolutions: [ResolutionData], time: Double = 0.0) {
        
        self.stopPlayer()
        self.videoURL = videoUrl
        self.languages = languages
        self.resolutions = resolutions
        if languages.count == 0 && resolutions.count == 0 {
            self.imgSettings.isHidden = true
            self.btnSettings.isUserInteractionEnabled = false
        } else {
            self.imgSettings.isHidden = false
            self.btnSettings.isUserInteractionEnabled = true
        }
        if let url = URL(string: videoURL){
            self.removeObserver()
            self.videoPlayerItem = AVPlayerItem.init(url:url)
            self.addObserver()
            self.btnPlayAction(UIButton())
            self.avPlayer?.appliesMediaSelectionCriteriaAutomatically = true
            self.avPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    func startVideoOffile(videoUrl: String) {
        self.btnSettings.isHidden = true
        self.removeObserver()
        self.videoPlayerItem = AVPlayerItem.init(url: URL(string: videoUrl)!)
        self.addObserver()
        self.btnPlayAction(UIButton())
    }
    
    func stopPlayer() {
        self.timer?.invalidate()
        self.avPlayer?.pause()
        removeObserver()
        self.paused = true
    }
    
    func addObserver() {

        self.removeObserver()
        self.showLoader()
        videoPlayerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        videoPlayerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        videoPlayerItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        self.observerSet = true
    }
    
    func removeObserver() {
        if observerSet {
            self.videoPlayerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            self.videoPlayerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            self.videoPlayerItem?.removeObserver(self, forKeyPath: "playbackBufferFull")
            observerSet = false
        }

    }
    
        @objc func playerItemDidReachEnd(notification: Notification) {
            let p: AVPlayerItem = notification.object as! AVPlayerItem
            p.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0)), toleranceBefore: .zero, toleranceAfter: .zero)
        }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
            if object is AVPlayerItem {
                switch keyPath {
                    case "playbackBufferEmpty":
                        self.showLoader()
                        break
                    case "playbackLikelyToKeepUp":
                        self.hideLoader()
                        break
                    case "playbackBufferFull":
                        self.hideLoader()
                        break
                    default:
                        break
                }
        }
    }
    
        func showLoader() {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        }
        
        func hideLoader() {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
}
