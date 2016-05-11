//
//  ImageDownloader.swift
//  CYUtilProjectSwift
//
//  Created by HuangQiSheng on 5/5/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

class ImageDownloader {
    
    
    func downloadImage(imageUrl: String) {
        
        let session = NSURLSession()
        let task = session.downloadTaskWithURL(NSURL(string: imageUrl)!)
//        task.start
    }
}
