//
//  OfflinevideoViewController.swift
//  V4 Stream
//
//  Created by jaydip kapadiya on 04/04/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class OfflinevideoViewController:  UIViewController {
    var db:DBHelper = DBHelper()
    var data : [Person] = []
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var viewerror: UIView!
    
    var downloadedData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SharedManager.sharedInstance().addTabBar(self)
        SharedManager.sharedInstance().bringTabbarToFront()
        SharedManager.sharedInstance().footerController?.btnHome.isSelected = false//true
        SharedManager.sharedInstance().footerController?.btnMovie.isSelected = false
        //      SharedManager.sharedInstance().footerController?.btnPremium.isSelected = false
        SharedManager.sharedInstance().footerController?.btnSeries.isSelected = false
        SharedManager.sharedInstance().footerController?.btnMore.isSelected = false
//        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.object(forKey: OfflineDownload_KEY) as? [[String:Any]]{
            if data.count > 0{
                downloadedData = data
            }
        }
        collection.reloadData()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CallDownload), userInfo: nil, repeats: true)
    }
    
    @objc func CallDownload(){
        if let data = UserDefaults.standard.object(forKey: OfflineDownload_KEY) as? [[String:Any]]{
            if data.count > 0{
                downloadedData = data
            }
        }
        collection.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func reloadData()
    {
        data = db.read()
        if data.count > 0
        {
            self.viewerror.isHidden = true
            //self.collection.setEmptyMessage("")
          //  self.viewerror.isHidden = true
        }
        else
        {
            self.viewerror.isHidden = false
           // self.collection.setEmptyMessage(" No Downloads Available")
        }
        DispatchQueue.global(qos: .background).async {
            print("This is run on a background queue")
           // self.collection.reloadData()
        }
    }
}

extension OfflinevideoViewController:UICollectionViewDelegate,UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedData.count
//        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        /*
         [TitleName_Key:self.movieDetail.movie_title,
                         FileURL_Key:self.movieDetail.download_url,
                         imageData_Key: self.imgPoster.image?.jpegData(compressionQuality: 1.0) ?? Data(),
                         progressData_Key: 0.0,
                         isDownloadComplete_Key:false,
                         MovieID_Key:self.movieDetail.movie_id,
                         MovieFileName_Key:"\(self.movieDetail.movie_id)+"+fileURLToDownload!.lastPathComponent] as [String : Any]
         */
        
        let DWData = downloadedData[indexPath.row]
        
        let imageData = DWData[imageData_Key] as? Data
        cell.imgThumbnail.image = UIImage(data: imageData!)
        
        cell.lblTitle.text = DWData[TitleName_Key] as? String
        cell.progress.progress = (DWData[progressData_Key] as? Float)!
        
        if let isDownload = DWData[isDownloadComplete_Key] as? Bool{
            if isDownload{
                cell.btnDelete.isHidden = false
                cell.btnPlay.isHidden = false
                cell.lblRental.text = "Download Completed"
                if let downloadPath = DWData[MovieFileName_Key] as? String{
                    if downloadPath.count > 0{
                        let url = URL(string: downloadPath)
                        cell.lbllanguage.text = covertToFileString(with: url?.fileSize ?? 0)
                    }
                }
            }else{
                cell.btnDelete.isHidden = true
                cell.btnPlay.isHidden = true
                cell.lblRental.text = "Downloading..."
                cell.lbllanguage.text = "Progress : \(String(format:"%.02f", (DWData[progressData_Key] as? Float)!))%"
            }
        }
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked),
                                     for: .touchUpInside)

//        cell.imgThumbnail.sd_setImage(with: URL(string: temp["movie_poster"]as? String ?? ""), placeholderImage: UIImage(named: "ic_profile_top_bg"))
//        cell.lblDuration.text = temp["duration"]as? String ?? ""
//        cell.lblTitle.text = temp["movie_title"]as? String ?? " "
//        cell.lbllanguage.text = "English"
//        cell.lblRental.text = "Comedy"
        
//       // cell.lblTitle.isHidden = true
//        cell.btnPlay.layer.cornerRadius = 20.0
        cell.btnPlay.clipsToBounds = true
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(btnPlay_Clicked),
                                 for: .touchUpInside)
        return cell
    }
    
    @objc func btnDelete_Clicked(sender:UIButton)
    {
        let alert = UIAlertController(title: "CINEPRIME", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let download = self.downloadedData[sender.tag]
            let downloadURL = download[MovieFileName_Key] as? String
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: "\(downloadURL ?? "")")
                print("Local path removed successfully")
            } catch let error as NSError {
                print("------Error",error.debugDescription)
            }
            self.downloadedData.remove(at: sender.tag)
            UserDefaults.standard.setValue(self.downloadedData, forKey: OfflineDownload_KEY)
            self.collection.reloadData()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
        
       // let temp = arrtemp[sender.tag] as? NSDictionary ?? [:]
       // self.APIRemoveFromWatchList(movie_id: temp["movie_videos_id"]as? String ?? (temp["movie_videos_id"]as? Int)?.description ?? "")
        
    }
    
    @objc func btnPlay_Clicked(sender:UIButton)
    {
        
        let resultVC : PlayOfflineVideoViewController = Utilities.viewController(name: "PlayOfflineVideoViewController", storyboard: "Home") as! PlayOfflineVideoViewController
        resultVC.downloadedData = self.downloadedData[sender.tag]
        self.navigationController?.pushViewController(resultVC, animated: true)
        
//        let temp = arrtemp[sender.tag] as? NSDictionary ?? [:]
//        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
//        resultVC.movie_id = temp["movie_videos_id"]as? String ?? (temp["movie_videos_id"]as? Int)?.description ?? ""
//        self.navigationController?.pushViewController(resultVC, animated: true)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let temp = arrtemp[indexPath.row] as? NSDictionary ?? [:]
//        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
//        resultVC.movie_id = temp["movie_videos_id"]as? String ?? ""
//        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (ScreenWidth - 20), height: 140)
        
    }
}


func covertToFileString(with size: UInt64) -> String {
    var convertedValue: Double = Double(size)
    var multiplyFactor = 0
    let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
    while convertedValue > 1024 {
        convertedValue /= 1024
        multiplyFactor += 1
    }
    return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
}
