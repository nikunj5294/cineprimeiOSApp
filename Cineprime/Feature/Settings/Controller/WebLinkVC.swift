//
//  WebLinkVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 22/09/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit
import WebKit

class WebLinkVC: UIViewController , WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lbltitle: UILabel!
    var link = ""
    var Data = String()
    var titleStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.indicator.startAnimating()
        if (link == "")
        {
            lbltitle.text = titleStr
            let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
            webView.loadHTMLString(headerString + Data, baseURL: nil)
        }
       else
        {
            if let url = URL(string: self.link)
            {
                //AppInstance.showLoader()
                let urlRequest = URLRequest(url: url)
                self.webView.load(urlRequest)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
        self.indicator?.stopAnimating()
        self.indicator?.isHidden = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }

}
