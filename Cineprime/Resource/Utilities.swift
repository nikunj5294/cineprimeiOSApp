//
//  Utilities.swift
//  TakeCare
//
//  Created by kishan on 22/02/19.
//  Copyright © 2019 kishan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Utilities
{
    class func viewController(name : String, storyboard : String) -> UIViewController
    {
        return UIStoryboard.init(name: storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: name)
    }
    
    class func statusBarHeight() -> CGFloat
    {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    class func getAppVersion() -> String {
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    class func playSound()
    {
        
        var player: AVAudioPlayer?
        
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func isBackSpace(_ str : String) -> Bool
    {
        
        
        if let char = str.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        
        return  false
    }
    
    class func isValidContactNumber(_ str : String) -> Bool
    {
        if str.count < 8 || str.count > 14 {
            return false
        }
        return  true
    }
    
    class func isValidEmail(_ str : String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    
    class func getStrDateFromTimeStamp(_ timeStamp : Double, _ format : String) -> String
    {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    class func addPercentageEncodingInURLPath(_ data: String) -> String {
        return data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? data
    }
    
    class func getStartDateOfWeekFor(_ date : Double) -> Double
    {
        let date = Date(timeIntervalSince1970: date)
        let startWeek = date.startOfWeek ?? date
        let str = self.getStrDateFromTimeStamp(startWeek.timeIntervalSince1970,"dd/MM/yyyy")
        print("startWeek : ",str)
        return startWeek.timeIntervalSince1970
    }
    
    class func trim(_ str : String) -> String
    {
        return str.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    class func makeCall(_ str : String)
    {
        if Utilities.trim(str) == ""
        {
            self.showMessages(message: "Contact number not available")
            return
        }
        
        if let url = URL(string: "tel://\(str)"), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            } else
            {
                UIApplication.shared.openURL(url)
            }
        }
        else
        {
            self.showMessages(message: "Can't call")
        }
    }
    
    class func showMessages(message : String)
    {
        AppInstance.showMessages(message: message)
        //print(message)
    }
    
    class func resizeImage(image: UIImage, targetSize: CGSize = CGSize(width: 400, height: 400 )) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    //var color1 = hexStringToUIColor(hex: "#FF2F92")
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension UIView
{
    func fladeAnimation(completionHandler: @escaping (Bool) -> Void)
    {
        self.alpha = 0
        self.backgroundColor = UIColor.gray
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.2
        }, completion : {finished in
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.0
            }, completion : {finished in
                self.backgroundColor = UIColor.white
                self.alpha = 1.0
                completionHandler(true)
            })
        })
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: width)
        self.layer.addSublayer(border)
    }

}



extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
