//
//  CYProgressWebView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 03/01/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit
import WebKit

class CYProgressWebView: UIView {

    private(set) var webView: WKWebView!
    private(set) var progressBar: CYLineProgressBar!

    private(set) var progress: Double = 0 {

        didSet {
            progressBar.setProgress(progress: progress, animated: true)
        }
    }

    deinit {
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubviews()
        createConstraints()

        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: [.new],
                            context: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    private func createSubviews() {

        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)

        progressBar = CYLineProgressBar(barWidth: 2, frame: .zero)
        progressBar.color = UIColor.red
        progressBar.completionColor = UIColor.blue
        progressBar.backgroundColor = UIColor.green
        progressBar.lineCap = kCALineCapButt
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)
    }

    private func createConstraints() {

        let progressTop = NSLayoutConstraint(item: progressBar,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0)
        let progressLeft = NSLayoutConstraint(item: progressBar,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1,
                                              constant: 0)
        let progressRight = NSLayoutConstraint(item: progressBar,
                                               attribute: .right,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .right,
                                               multiplier: 1,
                                               constant: 0)
        let progressHeight = NSLayoutConstraint(item: progressBar,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 2)
        addConstraints([progressTop, progressLeft, progressRight, progressHeight])

        let webViewTop = NSLayoutConstraint(item: webView,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: progressBar,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 0)
        let webViewLeft = NSLayoutConstraint(item: webView,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1,
                                              constant: 0)
        let webViewRight = NSLayoutConstraint(item: webView,
                                               attribute: .right,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .right,
                                               multiplier: 1,
                                               constant: 0)
        let webViewBottom = NSLayoutConstraint(item: webView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .bottom,
                                                multiplier: 1,
                                                constant: 0)
        addConstraints([webViewTop, webViewLeft, webViewRight, webViewBottom])
    }

    // load content
    func load(urlString: String) -> WKNavigation? {

        if let url = URL(string: urlString) {

            return load(url: url)
        }
        return nil
    }

    func load(url: URL) -> WKNavigation? {
        return load(request: URLRequest(url: url))
    }

    func load(request: URLRequest) -> WKNavigation? {
        return webView.load(request)
    }

    // key-value observing
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(WKWebView.estimatedProgress) {

            let progress = (change?[.newKey] as? Double) ?? 0
            self.progress = progress
        }
    }
}
