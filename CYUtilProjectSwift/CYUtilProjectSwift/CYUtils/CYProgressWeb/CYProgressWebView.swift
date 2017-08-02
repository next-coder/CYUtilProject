//
//  CYProgressWebView.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 03/01/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit
import WebKit

class CYProgressWebView: UIView, UIWebViewDelegate {

    // webView，请不要修改webView的delegate，使用webViewProxyDelegate接收webView回调
    private(set) var webView: UIWebView!
    private(set) var progressView: CYWebViewProgress!

    // webview delegate
    weak var webViewProxyDelegate: UIWebViewDelegate?

    // request count in current page
    // 当所有的请求都结束时，进度条才能是完成状态
    private var requestCount: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        configureViews()
    }

    private func configureViews() {

        webView = UIWebView(frame: .zero)
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)

        progressView = CYWebViewProgress()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
    }

    private func configureConstraints() {

        let progressTop = NSLayoutConstraint(item: progressView,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0)
        let progressLeft = NSLayoutConstraint(item: progressView,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1,
                                              constant: 0)
        let progressRight = NSLayoutConstraint(item: progressView,
                                               attribute: .right,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .right,
                                               multiplier: 1,
                                               constant: 0)
        let progressHeight = NSLayoutConstraint(item: progressView,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 4)
        addConstraints([progressTop, progressLeft, progressRight, progressHeight])

        let webViewTop = NSLayoutConstraint(item: webView,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .top,
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

    // WebView Adapter
    func load(urlString: String) {

        if let url = URL(string: urlString) {

            load(url: url)
        }
    }

    func load(url: URL) {
        load(request: URLRequest(url: url))
    }

    func load(request: URLRequest) {

        if (webView.isLoading) {

            webView.stopLoading()
        }
        webView.loadRequest(request)
    }

    var canGoBack: Bool {
        return webView.canGoBack
    }

    var canGoForward: Bool {
        return webView.canGoForward
    }

    func goBack() {

        webView.goBack()
    }

    func goForward() {
        
        webView.goForward()
    }

    func reload() {
        webView.reload()
    }

    // UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        return (self.webViewProxyDelegate?.webView?(webView, shouldStartLoadWith: request, navigationType: navigationType)) ?? true
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        self.webViewProxyDelegate?.webViewDidStartLoad?(webView)

        if requestCount == 0 {

            // 完蛋，哈哈哈哈哈哈哈哈哈哈
            // 第一个动画完成之后，继续第二阶段动画
            progressView.setProgress(progress: 0.2,
                                     animationDuration: 0.5,
                                     animationOptions: .curveEaseOut,
                                     completion: nil)
        }
        requestCount += 1
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webViewProxyDelegate?.webViewDidFinishLoad?(webView)

        requestCount -= 1
        if requestCount == 0 {

            completeProgress()
        }
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.webViewProxyDelegate?.webView?(webView, didFailLoadWithError: error)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { 

            self.requestCount -= 1
            if self.requestCount == 0 {

                self.completeProgress()
            }
        }
    }

    // progress
    func completeProgress() {

        progressView.setProgress(progress: 1, animationDuration: 0.2, animationOptions: .curveEaseIn) { (finished) in
            self.progressView.dismissProgressBar()
        }
    }
}
