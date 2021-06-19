//
//  AppDelegate.swift
//  V4 Stream
//
//  Created by kishan on 14/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import SideMenuSwift
import StoreKit
import Firebase
import FirebaseDynamicLinks
import GoogleSignIn
import FBSDKCoreKit
var AppInstance : AppDelegate!
var Tagss = Int();
var arrdownload = NSMutableArray()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppInstance = self
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.statusBarStyle = .lightContent
        SKPaymentQueue.default().add(self)
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
        
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-2", ofType: "plist")
        let options = FirebaseOptions.init(contentsOfFile: filePath!)!
        FirebaseApp.configure(options: options)
        InApp.default.initMethod()
        GIDSignIn.sharedInstance().clientID = "627517509507-t4chftr7fkr4k37ftpnfaokaqip81m79.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        //PUSH NOTIFICATION
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            var authOptions = UNAuthorizationOptions()
            
            if #available(iOS 12.0, *) {
                authOptions = [.alert, .badge, .sound, .provisional, .providesAppNotificationSettings]
            } else {
                authOptions = [.alert, .badge, .sound]
            }
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self


        
        
        return true
    }
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if let incomingURL = userActivity.webpageURL {
              let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { (dynamiclink, error) in
                if let dynamiclink = dynamiclink, let linkObj =  dynamiclink.url {
                    if kCurrentUser.user_id != "" {
                        if linkObj.debugDescription.components(separatedBy: "Id=").count > 1{
                            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                                
                                if let navObj = topController as? UINavigationController{
//                                    let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
//                                    resultVC.movie_id = linkObj.debugDescription.components(separatedBy: "Id=")[1]
//                                    navObj.pushViewController(resultVC, animated: true)
                                }else {
                                    if topController.children.count > 0{
                                        topController.children.forEach { (viewController) in
                                            if let nav = viewController as? UINavigationController{
                                                let resultVC : MovieDetailVC = Utilities.viewController(name: "MovieDetailVC", storyboard: "Home") as! MovieDetailVC
                                                resultVC.movie_id = linkObj.debugDescription.components(separatedBy: "Id=")[1]
                                                nav.pushViewController(resultVC, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                  
                }
              })

              return linkHandled
            }
        return false
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func showMessages(message : String)
    {
        let alert = UIAlertController(title: "CINEPRIME", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            
        })
        
        alert.addAction(action)
        
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    var loader: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let indi = NVActivityIndicatorView(frame: CGRect(x: (ScreenWidth / 2) - 15, y: (ScreenHeight / 2) - 15, width: 30, height: 30), type: .ballPulseSync , color: appColors.orange, padding: 0)
    
    func showLoader()
    {
        if let vc = self.topVC()
        {
            bgView.backgroundColor = appColors.blue.withAlphaComponent(0.1)
            //vc.view.addSubview(bgView)
            vc.view.addSubview(indi)
            indi.startAnimating()
            self.window!.isUserInteractionEnabled = false
            
        }
    }
    
    func hideLoader()
    {
        self.window!.isUserInteractionEnabled = true
        //bgView.removeFromSuperview()
        indi.stopAnimating()
        indi.removeFromSuperview()
        
    }
    
    func topVC() -> UIViewController?
    {
        
        if var topController = self.window!.rootViewController {
            
            while let presentedViewController = topController.presentedViewController
            {
                topController = presentedViewController
            }
            
            return topController
            // topController should now be your topmost view controller
        }
        
        return nil
        
    }
    func goToHomeVC(isAnimated : Bool = true)
    {
        
        let homeVC : HomeVC = Utilities.viewController(name: "HomeVC", storyboard: "Home") as! HomeVC
        let nav = UINavigationController(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        
        //2
        let menuViewController : MenuVC = Utilities.viewController(name: "MenuVC", storyboard: "Home") as! MenuVC
        
        SideMenuController.preferences.basic.menuWidth = menuWidth
        //SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        //SideMenuController.preferences.basic.position = .below
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = false
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
        
        if isAnimated
        {
            UIView.transition(with: self.window!, duration: 0.2, options: .transitionFlipFromLeft, animations: { () -> Void in
                self.window?.rootViewController = SideMenuController(contentViewController: nav,menuViewController: menuViewController)
                
                self.window?.makeKeyAndVisible()
            }, completion: { (finished: Bool) -> Void in
                
            })
        }
        else
        {
            self.window?.rootViewController = SideMenuController(contentViewController: nav,menuViewController: menuViewController)
            self.window?.makeKeyAndVisible()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "captured") {
            let isCaptured = UIScreen.main.isCaptured
            if isCaptured {
                showAlertForScreenCapture()
            }
        }
    }
    
    func showAlertForScreenCapture() {
        
        let alert = UIAlertController(title: "Alert", message: "Screen Recording is not allowed, Please stop recording to be continue with app", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {_ in
            if UIScreen.main.isCaptured {
                self.showAlertForScreenCapture()
            }
        })
        
        alert.addAction(action)
        
        self.topVC()?.present(alert, animated: true, completion: nil)
    }
}


//MARK:- When User click
extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
//        if !UserData.CurrentUserData.id.isEmpty && !UserData.CurrentUserData.email.isEmpty {
            let data = userInfo as NSDictionary
//            let notificationObj = NotificationModel(dictionary: data)
//            switch notificationObj.bookingStatus {
//            case .canceledByAdmin, .completed, .paymentCompleted, .sitterAssigned:
//                NotificationCenter.default.post(name: .ReceivedBookingStatus, object: notificationObj)
//            case .unknown:
//                break
//            }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let data = notification.request.content.userInfo as NSDictionary
        print(data)
//        let notificationObj = NotificationModel(dictionary: data)
//        switch notificationObj.bookingStatus {
//        case .canceledByAdmin, .completed, .paymentCompleted, .sitterAssigned:
//            NotificationCenter.default.post(.init(name: .RefreshBookingData))
//        case .unknown:
//            break
//        }
        completionHandler([.alert,.badge,.sound])
    }
    
}


// MARK:- APNS + FCM Configuration
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("apple device token--",deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

extension AppDelegate : MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("fcm-Token-----",fcmToken ?? "")
//        var fcmAccessToken = fcmToken ?? ""
    }
    
}
