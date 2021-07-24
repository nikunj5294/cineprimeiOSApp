//
//  DMClass.swift
//  DownloadManager
//
//  Created by MAC on 24/05/21.
//

import UIKit

class DMClass: NSObject {

    static let sharedInstance = DMClass()
    
    func DownloadMovie(url:URL, destinationUrl:URL) {
        
        DownloadManager.shared.addDownload(url: url, destinationURL: destinationUrl,
                                           onProgress: { progress in
                                               // progress is a Float
                                               print("Downloading : \(progress)")
                                           }, onCompletion: { error, fileURL in
//                                               guard error == nil else {
//                                                   // handle error
//                                               }
                                            if error == nil{
                                                print(fileURL?.absoluteString ?? "")
                                            }else{
                                                print(error?.localizedDescription ?? "")
                                            }
                                            // fileURL is the local file URL on the device
        })
        
        
    }
    
    
}
