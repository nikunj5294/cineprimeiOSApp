//
//  HelpViewController.swift
//  V4 Stream
//
//  Created by MAC on 20/05/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callUsClicked(_ sender: Any) {
        if #available(iOS 10.0, *) {
              UIImpactFeedbackGenerator(style: .light).impactOccurred()
           }
        CallNumber()
    }
    
    @IBAction func EmailUsClicked(_ sender: Any) {
        if #available(iOS 10.0, *) {
              UIImpactFeedbackGenerator(style: .light).impactOccurred()
           } 
        showMailComposer()
    }
    
    func CallNumber() {

     if let url = URL(string: "tel://+919372825730"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
    
    func showMailComposer(){
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@cineprime.app"])
        composer.setSubject("Request Help")
        composer.setMessageBody("", isHTML: false)
        present(composer, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HelpViewController : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

            switch result {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                print("Mail sent failure: \(error?.localizedDescription ?? "")")
            default:
                break
            }
            controller.dismiss(animated: true, completion: nil)
        }
    
}

