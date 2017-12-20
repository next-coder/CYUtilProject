//
//  WebViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 07/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit
import WebKit

open class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate {

    // never changes the webView's uiDelegate and navigationDelegate, use WebViewController.delegate instead
    @IBOutlet open private(set) var webView: WKWebView?
    @IBOutlet open private(set) var progressView: WebViewProgress?

    // 侧滑返回
    @IBOutlet open private(set) var popGesutreRecognizer: UIGestureRecognizer?
    fileprivate var isInteractivePop: Bool = false
    fileprivate var popInteractiveAnimator: UIPercentDrivenInteractiveTransition?

    @IBOutlet public var delegate: (WKNavigationDelegate & WKUIDelegate)?

    // 返回按钮，默认为nil，则返回按钮为系统提供按钮
    var backBarButtonItem: UIBarButtonItem? {
        didSet {
            if self.isViewLoaded {
                self.resetLeftBarButtonItems()
            }
        }
    }
    // 关闭按钮，如果此属性为空，则关闭按钮样式是标题为蓝色字体‘关闭’的按钮
    var closeBarButtonItem: UIBarButtonItem? {
        didSet {
            if self.isViewLoaded {
                self.resetLeftBarButtonItems()
            }
        }
    }
    // 导航栏右侧Items
    private(set) var rightBarButtonItems: [UIBarButtonItem]?
    private(set) var rightBarButtonActions: [(UIBarButtonItem)->Void]?

    // WebViewControllerStyle，定制controller样式
    open private(set) var style: WebViewControllerStyle?

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

    public init(style: WebViewControllerStyle) {
        self.style = style

        super.init(nibName: nil, bundle: nil)
        self.edgesForExtendedLayout = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.edgesForExtendedLayout = []
    }

    override open func loadView() {
        super.loadView()

        if webView == nil {
            webView = WKWebView(frame: view.bounds)
            webView?.uiDelegate = self
            webView?.navigationDelegate = self
            webView?.allowsBackForwardNavigationGestures = true
            view.addSubview(webView!)
        }
        if progressView == nil {
            progressView = WebViewProgress(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 2.0))
            view.addSubview(progressView!)
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.resetLeftBarButtonItems()
        if let progressBarColor = self.style?.progressBarColor {
            progressView?.progressColor = progressBarColor
        }
        if let progressBarWidth = self.style?.progressBarWidth {
            progressView?.barHeight = progressBarWidth
        }

        webView?.addObserver(self,
                             forKeyPath: #keyPath(WKWebView.estimatedProgress),
                             options: [.new],
                             context: nil)

        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(popToBack))
        gesture.delegate = self
        gesture.edges = .left
        webView?.addGestureRecognizer(gesture)
        popGesutreRecognizer = gesture

        webView?.scrollView.panGestureRecognizer.require(toFail: popGesutreRecognizer!)
    }

    @objc private func popToBack(_ gesture: UIScreenEdgePanGestureRecognizer) {

        if gesture.state == .began {
            self.isInteractivePop = true
            self.navigationController?.popViewController(animated: true)
        } else if gesture.state == .changed {
            let location = gesture.translation(in: self.view)
            self.popInteractiveAnimator?.update(location.x / UIScreen.main.bounds.width)
        } else if gesture.state == .ended
                    || gesture.state == .cancelled {
            self.isInteractivePop = false
            let location = gesture.translation(in: self.view)
            let velocity = gesture.velocity(in: self.view).x
            if (location.x / UIScreen.main.bounds.width) >= 0.5
                || velocity >= UIScreen.main.bounds.width {
                self.popInteractiveAnimator?.finish()
            } else {
                self.popInteractiveAnimator?.cancel()
            }
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
        self.navigationController?.delegate = self
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.delegate = nil
    }

    // MARK: Navigation
    private func resetLeftBarButtonItems() {

        // 返回按钮一定有
        var leftBarButtonItems = [ showingBackBarButtonItem() ]
        if let closeItem = showingCloseBarButtonItem() {
            // 增加关闭按钮
            leftBarButtonItems.append(closeItem)
        }
        self.navigationItem.leftBarButtonItems = leftBarButtonItems
    }

    private func showingBackBarButtonItem() -> UIBarButtonItem {
        if let backItem = self.backBarButtonItem {
            // 关联返回按钮行为，回到页面上一级
            backItem.target = self
            backItem.action = #selector(goBack)
            return backItem
        } else {
            return UIBarButtonItem(title: NSLocalizedString("<返回", comment: ""),
                                   style: .plain,
                                   target: self,
                                   action: #selector(goBack))
        }
    }

    private func showingCloseBarButtonItem() -> UIBarButtonItem? {
        let closeItemMode = (style?.closeBarButtonItemMode ?? .`default`)
        if closeItemMode == .none {
            // 不显示关闭按钮
            return nil
        } else if closeItemMode == .`default`
            && !(webView?.canGoBack ?? false) {
            // default模式下，Web不能返回的时候，也不再显示closeItem
            return nil
        } else if let closeItem = self.closeBarButtonItem {
            // 定制的item
            closeItem.target = self
            closeItem.action = #selector(closeWeb)
            return closeItem
        } else {
            return UIBarButtonItem(title: NSLocalizedString("关闭", comment: ""),
                                   style: .plain,
                                   target: self,
                                   action: #selector(closeWeb))
        }
    }

    @objc private func closeWeb(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func goBack(_ sender: Any?) {
        if webView?.canGoBack ?? false {
            webView?.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    // 添加导航栏右侧按钮
    // 请注意，此处会retain item和action，开发者不能在action中在retain WebViewController，否则会造成循环引用
    // 添加的item会在WebViewController的整个生命周期一直存在
    open func addNavigationRightItem(_ item: UIBarButtonItem, action: @escaping (UIBarButtonItem) -> Void) {
        if rightBarButtonItems == nil {
            rightBarButtonItems = [ item ]
        } else {
            rightBarButtonItems?.append(item)
        }
        if rightBarButtonActions == nil {
            rightBarButtonActions = [ action ]
        } else {
            rightBarButtonActions?.append(action)
        }
        item.target = self
        item.action = #selector(navigationRightItemAction(_:))
        self.navigationItem.rightBarButtonItems = rightBarButtonItems!
    }

    // 导航栏右侧按钮执行
    @objc private func navigationRightItemAction(_ sender: Any?) {
        if let item = sender as? UIBarButtonItem,
            let itemIndex = rightBarButtonItems?.index(of: item),
            let action = rightBarButtonActions?[itemIndex] {
            action(item)
        }
    }

    open func removeNavigationRightItem(_ item: UIBarButtonItem) {
        if let itemIndex = rightBarButtonItems?.index(of: item) {
            _ = rightBarButtonItems?.remove(at: itemIndex)
            _ = rightBarButtonActions?.remove(at: itemIndex)
        }
    }

    // MARK: WKNavigationDelegate
    // 如果开发者重写了一下方法，必须call super
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        progressView?.setProgress(progress: 0.3,
                                  animationDuration: 0.3,
                                  animationOptions: .curveEaseOut,
                                  completion: nil)
        delegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        progressView?.setProgress(progress: 1.0,
                                  animationDuration: 0.3,
                                  animationOptions: .curveEaseOut,
                                  completion: { (finished) in

                                    self.progressView?.dismissProgressBar()
        })
        delegate?.webView?(webView, didFail: navigation, withError: error)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        progressView?.setProgress(progress: 1.0,
                                  animationDuration: 0.3,
                                  animationOptions: .curveEaseOut,
                                  completion: { (finished) in

                                    self.progressView?.dismissProgressBar()
        })
        delegate?.webView?(webView, didFinish: navigation)
        self.resetLeftBarButtonItems()
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

// MARK: message forwarding
extension WebViewController {
    override open func responds(to aSelector: Selector!) -> Bool {

        if let delegate = self.delegate {
            return (super.responds(to: aSelector) || delegate.responds(to: aSelector))
        } else {
            return super.responds(to: aSelector)
        }
    }

    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let target = super.forwardingTarget(for: aSelector) {
            return target
        } else if delegate?.responds(to: aSelector) ?? false {
            return delegate
        } else {
            return nil
        }
    }
}

// MARK: transition animation
extension WebViewController: UINavigationControllerDelegate {
    // MARK: UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .pop
            && self.isInteractivePop
            && fromVC == self {
            let animator = WebViewControllerAnimator()
            animator.operation = operation
            return animator
        }
        return nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        let animator = UIPercentDrivenInteractiveTransition()
        self.popInteractiveAnimator = animator
        return animator
    }
}

// MARK: 侧滑返回动画
public class WebViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var operation: UINavigationControllerOperation = .pop
    private var transitionContext: UIViewControllerContextTransitioning?

    // MARK: UIViewControllerAnimatedTransitioning
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation != .pop {
            return
        }
        guard let fromViewController = transitionContext.viewController(forKey: .from),
                let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else {
            return
        }
        var toInitialFrame = transitionContext.initialFrame(for: toViewController)
        let toFinalFrame = transitionContext.finalFrame(for: toViewController)
        toInitialFrame.size.height = toFinalFrame.height
        toInitialFrame.size.width = toFinalFrame.width / 2.0
        toInitialFrame.origin.x = -toFinalFrame.width / 2.0

        let fromInitialFrame = transitionContext.initialFrame(for: fromViewController)
        var fromFinalFrame = transitionContext.finalFrame(for: fromViewController)
        fromFinalFrame.size = fromInitialFrame.size
        fromFinalFrame.origin.y = fromInitialFrame.origin.y
        fromFinalFrame.origin.x = fromFinalFrame.width

        toView.frame = toInitialFrame
        transitionContext.containerView.addSubview(toView)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            fromView.frame = fromFinalFrame
            toView.frame = toFinalFrame
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                toView.removeFromSuperview()
            }
        }
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
}

