//
//  HomeVC.swift
//  V4 Stream
//
//  Created by kishan on 15/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import SDWebImage
var isInAppPremium: Bool = false
class HomeVC: UIViewController {

    @IBOutlet weak var clnHeader: UICollectionView!
    @IBOutlet weak var clnRecentlyWatch: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHeaderCount: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewRecentlyWatch: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!

    var isMovieIDNotification = false
    var movieID = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // let height = UIApplication.shared.statusBarFrame.height

        self.navigationHeight.constant = 20
        self.viewRecentlyWatch.isHidden = true
        self.lblHeaderCount.text = ""
      self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search..",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.tableView.estimatedRowHeight = 250.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCallReceivedMovieID(notification:)), name: Notification.Name("receivedMovieIDHome"), object: nil)
        
//        AppInstance.verifyInAppReceipt()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func notificationCallReceivedMovieID(notification: Notification) {
        if let movieID = notification.userInfo?["Movie_id"] as? String {
                        
            if self.navigationController?.viewControllers == nil{
                self.movieID = movieID
                NotificationCenter.default.post(name: Notification.Name("selectdHomeTab"), object: nil, userInfo: nil)
            }
            
            DispatchQueue.main.async {
                if self.navigationController?.viewControllers.last is MovieDetailVC{
                    NotificationCenter.default.post(name: Notification.Name("receivedMovieID"), object: nil, userInfo: ["Movie_id":movieID])
                }else{
                    let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
                    resultVC.movie_id = movieID
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
          }
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.CheckVersion()
            
        SharedManager.sharedInstance().addTabBar(self)
        SharedManager.sharedInstance().bringTabbarToFront()
        SharedManager.sharedInstance().footerController?.btnHome.isSelected = false//true
        SharedManager.sharedInstance().footerController?.btnMovie.isSelected = false
//        SharedManager.sharedInstance().footerController?.btnPremium.isSelected = false
        SharedManager.sharedInstance().footerController?.btnSeries.isSelected = false
        SharedManager.sharedInstance().footerController?.btnMore.isSelected = false

        if isMovieIDNotification{
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
                resultVC.movie_id = self.movieID
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
            
        }
        
        
    }
    
    @IBAction func btnSubscribeNowAction(_ sender: UIButton) {
      //  let resultVC: SubscripionPlanVC = Utilities.viewController(name: "SubscripionPlanVC", storyboard: "Settings") as! SubscripionPlanVC
        
        let resultVC: InAppSubscriptionVC = Utilities.viewController(name: "InAppSubscriptionVC", storyboard: "Settings") as! InAppSubscriptionVC
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func btnSideMenuActions(_ sender: UIButton) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton)
    {
        if (sender.tag == 1)
        {
            let menuViewController : MenuVC = Utilities.viewController(name: "MenuVC", storyboard: "Home") as! MenuVC
            self.navigationController?.pushViewController(menuViewController, animated: true)
            
        }else
        {
            self.viewSearch.isHidden = false
            self.txtSearch.becomeFirstResponder()
        }
        
    }
    
    @IBAction func btnCloseSearchAction(_ sender: UIButton) {
        self.txtSearch.resignFirstResponder()
        self.txtSearch.text = ""
        self.viewSearch.isHidden = true

    }
    
    @IBAction func btnPlayPrassed(_ sender: UIButton) {
        let temp = homeData.slider[page.currentPage]
        if temp.slider_type.lowercased() == "movies" {
            let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
            resultVC.movie_id = temp.slider_post_id
            self.navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let resultVC : ShowDetailVC = Utilities.viewController(name: "ShowDetailVC", storyboard: "Home") as! ShowDetailVC
            resultVC.show_id = temp.slider_post_id
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    
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
                
                let resultVC : SearchVC =  Utilities.viewController(name: "SearchVC", storyboard: "Home") as! SearchVC
                resultVC.searchText = self.txtSearch.text!
                self.txtSearch.resignFirstResponder()
                self.navigationController?.pushViewController(resultVC, animated: true)
                self.txtSearch.text = ""
                self.viewSearch.isHidden = true
            }
        }
        
        return true
    }
}

extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.clnHeader {
            let page = Int(scrollView.contentOffset.x / ScreenWidth)
            if page < homeData.slider.count {
                self.lblHeaderCount.text = "\(page + 1)/\(homeData.slider.count)"
            }
        }
    }
}

extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.clnHeader {
            page.numberOfPages = homeData.slider.count
            page.transform = CGAffineTransform(scaleX: 2, y: 2)
            return homeData.slider.count
        } else {
            return homeData.recently_watched.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.clnHeader {
            page.currentPage = indexPath.row
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clnHeader {
            let cell : CollectionViewOneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewOneCell", for: indexPath) as! CollectionViewOneCell
            let temp = homeData.slider[indexPath.row]
            cell.imgItems.sd_setImage(with: URL(string: temp.slider_image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
        
            return cell
            
        } else {
            
            let cell : MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
         //   cell.lblTitle.isHidden = true
            let temp = homeData.recently_watched[indexPath.row]
//            cell.lblTitle.text = ""//temp.movie_title
//            cell.lblDuration.text = ""//temp.movie_duration
//            cell.lblRental.text = ""//temp.movie_access
//            cell.viewRental.isHidden = true//(temp.movie_access == "Free" || temp.movie_access == "")
            cell.imgThumbnail.sd_setImage(with: URL(string: temp.video_thumb_image), placeholderImage: UIImage(named: "ic_profile_top_bg"))
            let randomFloat = Float.random(in: 0..<1)
            cell.progress.progress = randomFloat
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == self.clnRecentlyWatch {
            
            let temp = homeData.recently_watched[indexPath.row]
            
            if temp.video_type.lowercased() == "movies" {
                let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
                resultVC.movie_id = temp.video_id
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                let resultVC : ShowDetailVC = Utilities.viewController(name: "ShowDetailVC", storyboard: "Home") as! ShowDetailVC
                resultVC.show_id = temp.video_id
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        } else if collectionView == self.clnHeader {
            
            let temp = homeData.slider[indexPath.row]
            
            if temp.slider_type.lowercased() == "movies" {
                let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
                resultVC.movie_id = temp.slider_post_id
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                let resultVC : ShowDetailVC = Utilities.viewController(name: "ShowDetailVC", storyboard: "Home") as! ShowDetailVC
                resultVC.show_id = temp.slider_post_id
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.clnHeader {
            return CGSize(width: ScreenWidth, height: 400)//Dimple
        } else {
            return CGSize(width: (ScreenWidth/2) - 20, height: 120)
        }
        
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource, MovieCategoryCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homeData.dashboardData.count;

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MovieCategoryCell = tableView.dequeueReusableCell(withIdentifier: "MovieCategoryCell", for: indexPath) as! MovieCategoryCell
        
    
        
//        if indexPath.row == 1 {
            
            cell.delegate = self
            cell.btnSeeAll.isHidden = false
            cell.btnSeeAll.tag = indexPath.row
            cell.btnSeeAll.addTarget(self, action: #selector(btnSeeAllAction), for: .touchUpInside)
            let temp = homeData.dashboardData[indexPath.row].movie_array
            cell.type = 1
//            cell.shows = temp
            cell.movies = temp
        cell.lblCategoryName.text = homeData.dashboardData[indexPath.row].title_name
            
//        } else {
            
//            var index = indexPath.row
//            if indexPath.row > 1 {
//                index -= 1
//            }
//                cell.delegate = self
//                cell.btnSeeAll.isHidden = false
//                cell.btnSeeAll.tag = indexPath.row
////                cell.btnSeeAll.addTarget(self, action: #selector(btnSeeAllAction), for: .touchUpInside)
////                let temp = homeData.homeSection[index]
//                cell.type = 1
////                cell.movies = temp.list
////                cell.lblCategoryName.text = temp.title
//            }

        cell.clnMovie.reloadData()
        
        return cell
    }
    
    @objc func btnSeeAllAction(_ sender: UIButton) {
        
        let resultVC: ShowVC = Utilities.viewController(name: "ShowVC", storyboard: "Home") as! ShowVC
        resultVC.isFromHome = true
        let apiURL = APIAction.show_all
        let index = sender.tag
        
       
//        var strTitle = ""
//
//
//        switch (index) {
//        case 0:
//            apiURL = APIAction.latest_movies
//            strTitle = "Trending"
//            break
//        case 1:
//            apiURL = APIAction.latest_shows
//            //strTitle = homeData.home_title2
//            break
//        case 2:
//            apiURL = APIAction.popular_shows
//            resultVC.isShow = true
//           // strTitle = homeData.home_title4
//            break
//        case 3:
//            apiURL = APIAction.popular_movies
//           // strTitle = homeData.homeSection[index-2].title //"Drama"
//            break
//        case 4:
//            apiURL = APIAction.bestv4_stream
//           // break
//        case 5:
//            apiURL = APIAction.homepopular_shows
//           // strTitle = homeData.homeSection[index-2].title//"Popular Shows"
//            break
//        case 6:
//            apiURL = APIAction.popular_documentary
//            //strTitle = homeData.homeSection[index-2].title//"Popular in Documentary"
//            break
//        case 7:
//            //resultVC.movies.list = homeData.homeSection[index-2].list
//            //resultVC.isNews = true
//           // strTitle = homeData.homeSection[index-2].title
//            break
//        default:
//            break
//        }
        resultVC.strTitle = homeData.dashboardData[index].title_name
        resultVC.category_id = homeData.dashboardData[index].category_id
        resultVC.apiURL = apiURL
        
        self.navigationController?.pushViewController(resultVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
//        if indexPath.row == 1 {
//            return 180
//        } else {
            return 250
//        }
    }
    
    func didTapOnMovie(movieData: MovieData) {
        let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
        resultVC.movie_id = movieData.movie_id
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
//    func didTapOnWebSeries(showData: ShowData) {
//        let resultVC : ShowDetailVC = Utilities.viewController(name: "ShowDetailVC", storyboard: "Home") as! ShowDetailVC
//        resultVC.show_id = showData.show_id
//        self.navigationController?.pushViewController(resultVC, animated: true)
//    }
}


extension HomeVC {
    
    func APIHome() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id] //144
        
        AlamofireModel.alamofireMethod(.post, apiAction: .home, parameters: param, Header: header,isLoader: (homeData.slider.count == 0), handler: { [self]res in
            
            homeData = HomeData()
            homeData.update(res.json)
            
            self.tableHeight.constant = CGFloat(homeData.dashboardData.count * 250)
            self.tableView.reloadData()
            self.clnHeader.reloadData()
            self.clnRecentlyWatch.reloadData()
            
            self.lblHeaderCount.text = "1/\(homeData.slider.count)"
            self.viewRecentlyWatch.isHidden = (homeData.recently_watched.count == 0)
                   
        }, errorhandler: {error in
            
        })
    }
    
    func aleartmsg(msg : String)
    {
        let refreshAlert = UIAlertController(title: "CINEPRIME", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if let url = URL(string: "https://apps.apple.com/us/app/cineprime/id1561387750") {
                UIApplication.shared.open(url)
            }
        }))
        
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    func CheckVersion() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let param : [String:Any] = ["version": appVersion ?? "0.0"] //144
        Tagss = 1
        AlamofireModel.alamofireMethod(.post, apiAction: APIAction.ios_v_chek, parameters: param, Header: header, handler: {res in
            Tagss = 0
            let jsonText = strFromJSON(res.originalJSON)
            var dictonary:NSDictionary?
            
            if let data = jsonText.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                    
                    if let myDictionary = dictonary
                    {
                        let arreatch = myDictionary["VIDEO_STREAMING_APP"] as? NSArray ?? []
                        let dicttemp = arreatch[0]as? NSDictionary ?? [:]
                        if dicttemp["success"]as? String == "0"
                        {
                            self.aleartmsg(msg: dicttemp["msg"]as? String ?? "")
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            self.APIHome()
            
        }, errorhandler: {error in
            self.APIHome()
        })
    }
    
}

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        
        return shared.statusBarFrame.height
    }
}






extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
