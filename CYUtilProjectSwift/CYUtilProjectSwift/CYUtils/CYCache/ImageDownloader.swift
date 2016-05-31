//
//  ImageDownloader.swift
//  CYUtilProjectSwift
//
//  Created by HuangQiSheng on 5/5/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

class ImageDownloader : NSObject, NSURLSessionDownloadDelegate {
    
    let downloadQueue: NSOperationQueue
    var downloadSession: NSURLSession?

    override init() {

        self.downloadQueue = NSOperationQueue()
        self.downloadQueue.maxConcurrentOperationCount = 5

        super.init()

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        config.HTTPShouldSetCookies = false
        self.downloadSession = NSURLSession(configuration: config,
                                            delegate: self,
                                            delegateQueue: self.downloadQueue)
    }

    func downloadImage(imageUrl: String) {
        
        let session = NSURLSession()
        let task = session.downloadTaskWithURL(NSURL(string: imageUrl)!)
//        task.start
    }

    // NSURLSessionDelegate methods
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {


    }

    @objc func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {

    }

    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {


    }
}
