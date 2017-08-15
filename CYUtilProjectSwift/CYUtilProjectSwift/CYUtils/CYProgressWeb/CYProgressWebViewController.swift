//
//  CYProgressWebViewController.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 02/03/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

class CYProgressWebViewController: UIViewController, UIWebViewDelegate {

    weak var progressWebView: CYProgressWebView!
    private(set) var backButton: UIButton!
    private(set) var closeItem: UIBarButtonItem!

    var rootUrl: URL? {

        willSet {
            if rootUrl != nil {
                print("You should set root url only once")
            }
        }
    }

    init(rootUrl: URL, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.rootUrl = rootUrl

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.edgesForExtendedLayout = []
    }

    convenience init(rootUrl: URL) {
        self.init(rootUrl: rootUrl, nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func loadView() {
        super.loadView()

        let webView = CYProgressWebView(frame: self.view.bounds)
        webView.webViewProxyDelegate = self
        self.view = webView
        self.progressWebView = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        let barTextAttributesNormal = UIBarButtonItem.appearance().titleTextAttributes(for: .normal)
//        let barTextAttributesHighlighted = UIBarButtonItem.appearance().titleTextAttributes(for: .highlighted)
//        let backColor

        // 返回按钮
        let backButton = UIButton(type: .custom)
//        backButton.setImage(UIImage(named: ""), for: .normal)
//        backButton.setImage(UIImage(named: ""), for: .highlighted)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitle("返回", for: .highlighted)
        backButton.setTitleColor(UIColor.blue, for: .normal)
//        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(self.backToPrevious), for: .touchUpInside)
        backButton.sizeToFit()
        let backItem = UIBarButtonItem(customView: backButton)

        // 关闭按钮
        let closeItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.closeWeb))
//        closeItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 88/255.0, green: 88/255.0, blue: 88/255.0, alpha: 1), NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: .normal)
        self.navigationItem.leftBarButtonItems = [backItem, closeItem]

        // 禁用手势返回
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        if let rootUrl = self.rootUrl {
            progressWebView.load(url: rootUrl)
        }
    }

    func backToPrevious() {
        if progressWebView.canGoBack {
            progressWebView.goBack()
            progressWebView.reload()
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }

    func closeWeb() {
        _ = navigationController?.popViewController(animated: true)
    }

}
