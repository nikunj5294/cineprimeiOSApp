//
//  ShowVC.swift
//  V4 Stream
//
//  Created by kishan on 15/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class ShowVC: UIViewController {

    @IBOutlet weak var clnCategory: UICollectionView!
    @IBOutlet weak var clnMain: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewTab: UIView!
    @IBOutlet weak var cnstViewLeading: NSLayoutConstraint!
    @IBOutlet weak var lblNoData: UILabel!
    var category_id = String()
    var cellWidth: CGFloat = (ScreenWidth - 8) / 3
    var cellHeight: CGFloat = 210
    var language_name = ""
    var isLanguageTab = true
    var isShow: Bool = false
    var isMenuPremium: Bool = false
    var isFirstTimeNoData = true
    var isNews: Bool = false
    
    var apiURL : APIAction = APIAction.popular_movies
    var strTitle = ""
    var isFromHome: Bool = false
    var movies = MoviesList()
    var shows = ShowsList()

    var selectedLangauguageCategoryData = LangauguageCategoryData()
    var selectedGenreCategotyData = GenreCategoryData()
    
    var langaugeCategory = LangaugeCategory()
    var genreCategoty = GenreCategory()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.lblTitle.text = strTitle
        
//        if isNews {
//            self.viewTab.isHidden = true
//            self.viewCategory.isHidden = true
//        } else if isFromHome {
            self.viewTab.isHidden = true
            self.viewCategory.isHidden = true
            self.APIMovies()
//        } else {
//
//            if isMenuPremium {
//                self.viewTab.isHidden = true
//                self.APIMovies()
//            } else {
//                self.APILangugaeCategoryList()
//                self.APIGenreCategoryList()
//            }
//
//        }
        
        // Do any additional setup after loading the view.
    }
  
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        self.viewSearch.isHidden = false
        self.txtSearch.becomeFirstResponder()
    }
    
    @IBAction func btnLanguageTabAction(_ sender: UIButton) {
        if !self.isLanguageTab {
            self.isLanguageTab = true
            if isShow {
                self.apiURL = APIAction.shows_by_language
            } else {
                 self.apiURL = APIAction.movies_by_language
            }
            self.clnCategory.reloadData()
            self.APIMovies()
            UIView.animate(withDuration: 0.5, animations: {
                self.cnstViewLeading.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func btnGenreTabAction(_ sender: UIButton) {
        if self.isLanguageTab {
            self.isLanguageTab = false
            if isShow {
                self.apiURL = APIAction.shows_by_genre
            } else {
                 self.apiURL = APIAction.movies_by_genre
            }
            self.clnCategory.reloadData()
            self.APIMovies()
            UIView.animate(withDuration: 0.5, animations: {
                self.cnstViewLeading.constant = ScreenWidth/2
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func btnCloseSearchAction(_ sender: UIButton) {
        self.txtSearch.resignFirstResponder()
        self.txtSearch.text = ""
        self.viewSearch.isHidden = true
    }
    
}

extension ShowVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.txtSearch {
            self.txtSearch.text = ""
            self.viewSearch.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtSearch {
            self.txtSearch.text = Utilities.trim(self.txtSearch.text!)
            if self.txtSearch.text == "" {
                return false
            } else {
                self.txtSearch.resignFirstResponder()
                let resultVC : SearchVC =  Utilities.viewController(name: "SearchVC", storyboard: "Home") as! SearchVC
                resultVC.searchText = self.txtSearch.text!
                self.navigationController?.pushViewController(resultVC, animated: true)
                self.txtSearch.text = ""
                self.viewSearch.isHidden = true
            }
        }
        
        return true
    }
}

extension ShowVC : UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        if collectionView == clnCategory
        {
            if self.isMenuPremium {
                count = 2
            }
            else if isLanguageTab {
                count = self.langaugeCategory.list.count
            } else {
                count =  self.genreCategoty.list.count
            }
        }
        else
        {
            if self.isShow {
//                 count =  self.shows.list.count
            } else {
                 count = self.movies.list.count
            }
           
        }
        
        if !isFirstTimeNoData {
            lblNoData.isHidden = (count > 0)
        }
        return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == clnCategory
        {
             let cell : LangaugeCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LangaugeCategoryCell", for: indexPath) as! LangaugeCategoryCell
            
            if self.isMenuPremium {
                cell.viewMain.backgroundColor = appColors.lightGray
                if indexPath.row == 0 {
                    cell.lblTitle.text = "Movies"
                    
                    if !self.isShow {
                        cell.viewMain.backgroundColor = appColors.pink
                    }
                    
                } else {
                    cell.lblTitle.text = "Web Series"
                    if self.isShow {
                        cell.viewMain.backgroundColor = appColors.pink
                    }
                }
            }
            else if isLanguageTab {
                
                let temp = self.langaugeCategory.list[indexPath.row]
                
                cell.lblTitle.text = temp.language_name
                
                if temp.language_id == self.selectedLangauguageCategoryData.language_id {
                    cell.viewMain.backgroundColor = appColors.pink
                } else {
                    cell.viewMain.backgroundColor = appColors.lightGray
                }
                
            } else {
                let temp = self.genreCategoty.list[indexPath.row]
                
                cell.lblTitle.text = temp.genre_name
                
                if temp.genre_id == self.selectedGenreCategotyData.genre_id {
                    cell.viewMain.backgroundColor = appColors.pink
                } else {
                    cell.viewMain.backgroundColor = appColors.lightGray
                }
            }

            
            return cell
        }
        else
        {
            let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.lblTitle.isHidden = true
            if self.isShow {
//                let temp = self.shows.list[indexPath.row]
                
//                cell.lblTitle.text = temp.show_title
                cell.lblDuration.text = ""
                cell.lblRental.text = ""
                cell.viewRental.isHidden = true
//                cell.imgThumbnail.sd_setImage(with: URL(string: temp.show_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
                
            } else {
                 let temp = self.movies.list[indexPath.row]
                 cell.lblTitle.text = temp.movie_title
                 cell.lblDuration.text = ""//temp.movie_duration
                 cell.lblRental.text = temp.movie_access
                 cell.viewRental.isHidden = true
//                    (temp.movie_access == "Free" || temp.movie_access == "")
                 cell.imgThumbnail.sd_setImage(with: URL(string: temp.movie_poster), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            }
            

            
            return cell
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == clnCategory
        {
            if self.isMenuPremium {
                if indexPath.row == 0 && self.isShow {
                    self.isShow = false
                    apiURL = .movies_by_category
                    self.clnMain.reloadData()
                } else if indexPath.row != 0 && !self.isShow {
                    self.isShow = true
                    apiURL = .shows_by_category
                    self.clnMain.reloadData()
                }
            }
            else if isLanguageTab {
                self.selectedLangauguageCategoryData = self.langaugeCategory.list[indexPath.row]
            } else {
                self.selectedGenreCategotyData = self.genreCategoty.list[indexPath.row]
            }

            self.clnCategory.reloadData()
            self.APIMovies()
            
        }
        else
        {
            if self.isShow {
                let resultVC : ShowDetailVC = Utilities.viewController(name: "ShowDetailVC", storyboard: "Home") as! ShowDetailVC
//                resultVC.show_id = self.shows.list[indexPath.row].show_id
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
                resultVC.movie_id = self.movies.list[indexPath.row].movie_id
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == clnCategory
        {
            return CGSize(width: 120, height: 90)
        } else {
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
  
}

extension ShowVC {
    
    
    
    func APIGenreCategoryList() {
        
        AlamofireModel.alamofireMethod(.post, apiAction: .genres, parameters: [:], Header: header, handler: {res in
            
            self.genreCategoty = GenreCategory()
            self.genreCategoty.update(res.originalJSON["VIDEO_STREAMING_APP"])
            
            if self.genreCategoty.list.count > 0 {
                self.selectedGenreCategotyData =  self.genreCategoty.list[0]
            }
            
            
        }, errorhandler: {error in
            
        })
    }
    
    func APILangugaeCategoryList() {
        
        AlamofireModel.alamofireMethod(.post, apiAction: .languages, parameters: [:], Header: header, handler: {res in
            self.langaugeCategory = LangaugeCategory()
            self.langaugeCategory.update(res.originalJSON["VIDEO_STREAMING_APP"])
            
            let tempArray = self.langaugeCategory.list.filter({$0.language_name == self.language_name})
            if tempArray.count > 0{
                self.selectedLangauguageCategoryData = tempArray[0]
            } else if self.langaugeCategory.list.count > 0 {
                self.selectedLangauguageCategoryData =  self.langaugeCategory.list[0]
            }
            self.APIMovies()
            self.clnCategory.reloadData()
            
        }, errorhandler: {error in
            
        })
    }
    

    
    
    
    
    func APIMovies() {
        
        var param : [String:Any] = [:]
        
//        if self.apiURL == APIAction.movies_by_language || self.apiURL == APIAction.shows_by_language  {
//            param["lang_id"] = self.selectedLangauguageCategoryData.language_id
//            param["isLanguage"] = true
//        } else if self.apiURL == APIAction.movies_by_genre || self.apiURL == APIAction.shows_by_genre  {
//            param["genre_id"] = self.selectedGenreCategotyData.genre_id
//        } else if self.apiURL == APIAction.movies_by_category  || self.apiURL == APIAction.shows_by_category {
//            param["category_id"] = 7
//
//            if self.isShow {
                param["category_id"] = category_id
//            } else {
//                param["subcategory_id"] = 29
//            }
//        }
        AlamofireModel.alamofireMethod(.post, apiAction: .show_all, parameters: param, Header: header,isLoader: (homeData.slider.count == 0), handler: { [self]res in
            
            var data = res.originalJSON["VIDEO_STREAMING_APP"]
            
            if self.isShow {
                self.shows = ShowsList()
//                self.shows.update(data)
            } else {
                if self.apiURL == APIAction.get_watchlist {
                    data = data[0]["data"]
                }
                self.movies = MoviesList()
                self.movies.update(data)
            }

            if self.isShow { //|| self.isMenuPremium
                self.cellWidth = (ScreenWidth - 8) / 2
                self.cellHeight = 150
            } else {
                self.cellWidth = (ScreenWidth - 8) / 3
                self.cellHeight = 210
            }
            self.isFirstTimeNoData = false
            self.clnMain.reloadData()
        }, errorhandler: {error in
            
        })
    }
}
