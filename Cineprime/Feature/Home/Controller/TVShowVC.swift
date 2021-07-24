//
//  TVShowVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 01/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class TVShowVC: UIViewController {

    @IBOutlet weak var clnCategory: UICollectionView!
    @IBOutlet weak var clnMain: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var tvList = TVList()
    var category = CategoryList()
    var selectedCategory = CategoryListData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.APITVCategoryList()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension TVShowVC : UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == clnCategory
        {
            return self.category.list.count
        }
        else
        {
            return self.tvList.list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == clnCategory
        {
             let cell : LangaugeCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LangaugeCategoryCell", for: indexPath) as! LangaugeCategoryCell
            
            let temp = self.category.list[indexPath.row]
            cell.lblTitle.text = temp.category_name
            cell.viewMain.backgroundColor = appColors.lightGray
            if temp.category_id == self.selectedCategory.category_id {
                 cell.viewMain.backgroundColor = appColors.pink
            }
            
            return cell
        }
        else
        {
            let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.lblTitle.isHidden = true
            let temp = self.tvList.list[indexPath.row]
            cell.lblTitle.text = temp.tv_title
            cell.lblDuration.text = ""
            cell.lblRental.text = temp.tv_access
            cell.viewRental.isHidden = true
//                (temp.tv_access.lowercased() == "free" || temp.tv_access == "")
            cell.imgThumbnail.sd_setImage(with: URL(string: temp.tv_logo), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            
            return cell
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == clnCategory
        {
            self.selectedCategory = self.category.list[indexPath.row]
            self.clnCategory.reloadData()
            self.APITVCList()
        }
        else
        {
            let resultVC: TVDetailVC = Utilities.viewController(name: "TVDetailVC", storyboard: "Home") as! TVDetailVC
            resultVC.tv_id = self.tvList.list[indexPath.row].tv_id
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == clnCategory
        {
            return CGSize(width: 120, height: 90)
        } else {
            return CGSize(width: (ScreenWidth - 8) / 2, height: 150)
        }
        
    }
  
}


extension TVShowVC {
    
    func APITVCategoryList() {
        
        AlamofireModel.alamofireMethod(.post, apiAction: .livetv_category, parameters: [:], Header: header, handler: {res in
            
            self.category = CategoryList()
            self.category.update(res.originalJSON["VIDEO_STREAMING_APP"])
            self.clnCategory.reloadData()
            
            if self.category.list.count > 0 {
                self.selectedCategory = self.category.list[0]
                self.APITVCList()
            }
            
        }, errorhandler: {error in
            
            
        })
    }

    func APITVCList() {
           
        let param: [String:Any] = ["category_id": self.selectedCategory.category_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .livetv_by_category, parameters: param, Header: header, handler: {res in

                self.tvList = TVList()
                self.tvList.update(res.originalJSON["VIDEO_STREAMING_APP"])
                self.clnMain.reloadData()
                self.lblNoData.isHidden = !(self.tvList.list.count == 0)
            
        }, errorhandler: {error in
               
        })
        
    }
    

    
}

