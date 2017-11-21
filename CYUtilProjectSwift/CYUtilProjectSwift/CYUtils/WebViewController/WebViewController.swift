//
//  WebViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 07/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit
import WebKit

open class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

//    @IBOutlet open private(set) var backItem: UIBarButtonItem?
//    @IBOutlet open private(set) var closeItem: UIBarButtonItem?
    @IBOutlet open private(set) var webView: WKWebView?
    @IBOutlet open private(set) var progressView: WebViewProgress?

    // reload web while enter web view controller
    open var isReload: Bool = false

    open var url: URL?

    deinit {
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.edgesForExtendedLayout = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.edgesForExtendedLayout = []
    }

    override open func loadView() {
        super.loadView()

        webView = WKWebView(frame: view.bounds)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.allowsBackForwardNavigationGestures = true
        view.addSubview(webView!)

        progressView = WebViewProgress(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 2.0))
        view.addSubview(progressView!)

//        backItem = UIBarButtonItem(title: NSLocalizedString("返回", comment: ""), style: .plain, target: self, action: #selector(goBack))
//        closeItem = UIBarButtonItem(title: NSLocalizedString("关闭", comment: ""), style: .plain, target: self, action: #selector(closeWeb))
//        navigationItem.leftBarButtonItems = [backItem!, closeItem!]
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        webView?.addObserver(self,
                             forKeyPath: #keyPath(WKWebView.estimatedProgress),
                             options: [.new],
                             context: nil)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isReload {
            if webView?.isLoading ?? false {
                webView?.stopLoading()
            }
            webView?.reload()
            isReload = false
        }
    }

    // MARK: WKNavigationDelegate
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        if progressView?.isHidden ?? false {

            progressView?.setProgress(progress: 0.3,
                                      animationDuration: 0.3,
                                      animationOptions: .curveEaseOut,
                                      completion: nil)
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        progressView?.setProgress(progress: 1.0,
                                  animationDuration: 0.3,
                                  animationOptions: .curveEaseOut,
                                  completion: { (finished) in

                                    self.progressView?.dismissProgressBar()
        })
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        progressView?.setProgress(progress: 1.0,
                                  animationDuration: 0.3,
                                  animationOptions: .curveEaseOut,
                                  completion: { (finished) in

                                    self.progressView?.dismissProgressBar()
        })
    }

    // MARK: kvc
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(WKWebView.estimatedProgress) {

            if let progress = webView?.estimatedProgress,
                let previousProgress = progressView?.progress,
                progress > previousProgress,
                progress < 0.9 {

                progressView?.setProgress(progress: webView?.estimatedProgress ?? 0,
                                          animationDuration: 0.2,
                                          animationOptions: .curveLinear,
                                          completion: nil)
            }
        }
    }

//    // MARK: event
//    public func closeWeb(_ sender: Any?) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    public func goBack(_ sender: Any?) {
//        if webView?.canGoBack ?? false {
//            webView?.goBack()
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
}

// MARK: load content
extension WebViewController {

    open func load(_ request: URLRequest) -> WKNavigation? {
        if webView == nil {
            // load view
            _ = self.view
        }
        return webView?.load(request)
    }

    open func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        if webView == nil {
            // load view
            _ = self.view
        }
        return webView?.loadHTMLString(string, baseURL: baseURL)
    }
}
