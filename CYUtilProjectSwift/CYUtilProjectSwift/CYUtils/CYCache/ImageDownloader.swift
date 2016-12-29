//
//  ImageDownloader.swift
//  CYUtilProjectSwift
//
//  Created by HuangQiSheng on 5/5/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

class ImageDownloader : NSObject, URLSessionDownloadDelegate {
    
    let downloadQueue: OperationQueue
    var downloadSession: Foundation.URLSession?

    override init() {

        self.downloadQueue = OperationQueue()
        self.downloadQueue.maxConcurrentOperationCount = 5

        super.init()

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpShouldSetCookies = false
        self.downloadSession = Foundation.URLSession(configuration: config,
                                            delegate: self,
                                            delegateQueue: self.downloadQueue)
    }

    func downloadImage(_ imageUrl: String) {
        
        let session = Foundation.URLSession()
        _ = session.downloadTask(with: URL(string: imageUrl)!)
//        task.start
    }

    // NSURLSessionDelegate methods
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {


    }

    @objc func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {


    }
}
