//
//  SharedManager.swift
//  V4 Stream
//
//  Created by Dimple Panchal on 12/02/21.
//

import Foundation
import UIKit

class SharedManager: NSObject, NSURLConnectionDataDelegate {
    
    static let _sharedInstance = SharedManager()
    var footerController: CustomTabbarController?
    
    static func sharedInstance() ->SharedManager {
        return _sharedInstance
    }

    override init()
    {
        super.init()
    }
    
    func addTabBar(_ controller: UIViewController) {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.backgroundColor = UIColor.clear
        
        do {
            footerController = CustomTabbarController(nibName:"Tabbar", bundle: nil)
        }
        footerController?.view.tag = 121
        var bottomPadding : CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = (window?.safeAreaInsets.bottom)!
        }
        
        if controller.viewIfLoaded?.window == nil
        {

            controller.view.addSubview((footerController?.view)!)
            if let aWidth = window?.frame.size.width
            {
                footerController?.view.frame = CGRect(x: 0, y: (window?.frame.size.height)! - (footerController?.view.frame.size.height)! - bottomPadding, width: aWidth, height: (footerController?.view.frame.size.height)!)
            }
            
    //            footerController?.view.frame = CGRect(x: 0, y: controller.view.frame.size.height - (footerController?.view.frame.size.height)!, width: (window?.frame.size.width)!, height: (footerController?.view.frame.size.height)!)
            footerController?.view.isHidden = false
            
            
            footerController?.view.backgroundColor = .red
//            footerController?.view.addTopBorderWithColor(color: UIColor(red:170/255,green:170/255,blue:170/255,alpha:0.5), width: 0.5)
    
            
            
    //            footerController?.view.layer.shadowRadius = 3.0
    //             footerController?.view.layer.shadowOpacity = 1.0
    //             footerController?.view.layer.shadowOffset = CGSize(width: 4, height: 4)
            footerController?.view.layer.masksToBounds = false
            
            footerController?.view.superview?.bringSubviewToFront((footerController?.view)!)
        }
        footerController?.view.isHidden = false
        footerController?.view.superview?.bringSubviewToFront((footerController?.view)!)
        
    }

    func hideTabBar() {
        footerController?.view.isHidden = true
    }

    func showTabBar() {
        footerController?.view.isHidden = false
    }

    func bringTabbarToFront() {
        footerController?.view.superview?.bringSubviewToFront((footerController?.view)!)
    }
    
}
