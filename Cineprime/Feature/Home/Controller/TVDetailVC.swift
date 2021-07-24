//
//  TVDetailVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 01/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class TVDetailVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collection: UICollectionView!

    var tv_id = ""
    var tvDetail = TVDetail()
    var arrtemp = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SharedManager.sharedInstance().addTabBar(self)
        SharedManager.sharedInstance().bringTabbarToFront()
        SharedManager.sharedInstance().footerController?.btnHome.isSelected = false//true
        SharedManager.sharedInstance().footerController?.btnMovie.isSelected = false
//      SharedManager.sharedInstance().footerController?.btnPremium.isSelected = false
        SharedManager.sharedInstance().footerController?.btnSeries.isSelected = false
        SharedManager.sharedInstance().footerController?.btnMore.isSelected = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.APIUpcommingMoview()
    }
    
    
    func APIUpcommingMoview() {
        
        let param: [String:Any] = ["data": "Upcoming"]
        Tagss = 1
        AlamofireModel.alamofireMethod(.post, apiAction: .movies_by_upcoming, parameters: param, Header: header, handler: { [self]res in
            Tagss = 0
            let jsonText = strFromJSON(res.originalJSON)
            var dictonary:NSDictionary?
            
            if let data = jsonText.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                    
                    if let myDictionary = dictonary
                    {
                        arrtemp = myDictionary["VIDEO_STREAMING_APP"] as! NSArray
                        if self.arrtemp.count > 0
                        {
                            self.collection.setEmptyMessage("")
                                
                        }
                        else
                        {
                            self.collection.setEmptyMessage("No Upcoming Movies")
                        }
                        collection.delegate = self
                        collection.dataSource  = self
                        collection.reloadData()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
           
        }, errorhandler: {error in
               
        })
    }
    
}

extension TVDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrtemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let temp = arrtemp[indexPath.row] as? NSDictionary ?? [:]
        cell.imgThumbnail.sd_setImage(with: URL(string: temp["movie_poster"]as? String ?? ""), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        cell.btnBackground.tag = indexPath.row
        cell.btnBackground.addTarget(self, action: #selector(buttonClicked),
                                     for: .touchUpInside)
        
        //cell.lblTitle.isHidden = true
        return cell
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        let temp = arrtemp[sender.tag] as? NSDictionary ?? [:]
        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
        resultVC.movie_id = temp["movie_id"]as? String ?? (temp["movie_id"]as? Int ?? 0).description
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let temp = arrtemp[indexPath.row] as? NSDictionary ?? [:]
//        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
//        resultVC.movie_id = temp["movie_id"]as? String ?? ""
//        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (ScreenWidth - 20) / 3, height: 150)
        
    }
}


