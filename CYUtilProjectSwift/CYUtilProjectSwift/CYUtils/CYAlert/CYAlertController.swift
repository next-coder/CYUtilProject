//
//  CYAlertController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 18/01/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

public enum CYAlertControllerContentType: Int {
    // 默认模式，采用title和message的模式
    case `default` = 0
    // 定制消息模式，titleView和messageView由开发者定制
    case customMessage
    // 完全定制模式，contentView由开发者定制，此模式下，add(action:)不起作用
    case custom
}

open class CYAlertController: UIViewController, UIViewControllerTransitioningDelegate {
    
    open private(set) var contentType: CYAlertControllerContentType = .`default`
    
    open private(set) lazy var actions: [CYAlertAction] = []
    private lazy var actionSeparatorViews: [UIView] = []
    @IBOutlet open private(set) var contentView: UIView?
    @IBOutlet open private(set) var titleView: UIView?
    @IBOutlet open private(set) var messageView: UIView?
    
    open private(set) var message: String?
    open private(set) var cancelActionTitle: String?
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.contentType = .custom
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    public init(title: String?, message: String?, cancelActionTitle: String? = NSLocalizedString("取消", comment: "")) {
        self.message = message
        self.cancelActionTitle = cancelActionTitle
        self.contentType = .`default`
        
        super.init(nibName: nil, bundle: nil)

        self.title = title
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    public init(contentView: UIView) {
        self.contentView = contentView
        self.contentType = .custom
        
        super.init(nibName: nil, bundle: nil)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    public init(titleView: UIView?, messageView: UIView?, cancelActionTitle: String? = NSLocalizedString("取消", comment: "")) {
        self.titleView = titleView
        self.messageView = messageView
        self.cancelActionTitle = cancelActionTitle
        self.contentType = .customMessage
        
        super.init(nibName: nil, bundle: nil)

        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    override open func loadView() {
        super.loadView()
        
        configureContentView()
    }
    
    private func configureContentView() {
        if let contentView = self.contentView {
            
            self.view.addSubview(contentView)
        } else {
            
            contentView = UIView()
            contentView?.backgroundColor = UIColor.white
            contentView?.layer.cornerRadius = 10
            contentView?.clipsToBounds = true
            self.view.addSubview(contentView!)
        }
        
        if let titleView = self.titleView {
            
            contentView?.addSubview(titleView)
        } else if !(self.title?.isEmpty ?? true) {
            
            let titleLabel = UILabel()
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = UIColor.black
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.textAlignment = .center
            titleLabel.text = self.title
            contentView?.addSubview(titleLabel)
            titleView = titleLabel
        }
        
        if let messageView = self.messageView {
            
            contentView?.addSubview(messageView)
        } else if !(self.message?.isEmpty ?? true) {
            
            let messageTextView = UITextView()
            messageTextView.font = UIFont.systemFont(ofSize: 15)
            messageTextView.textColor = UIColor.darkGray
            messageTextView.backgroundColor = UIColor.clear
            messageTextView.isEditable = false
            messageTextView.textAlignment = .center
            messageTextView.text = self.message
            contentView?.addSubview(messageTextView)
            self.messageView = messageTextView
        }
        
        if let cancelActionTitle = self.cancelActionTitle,
            !cancelActionTitle.isEmpty {
            
            let cancelAction = CYAlertAction(title: cancelActionTitle, handler: { [weak self] (action) in
                self?.dismiss(animated: true, completion: nil)
            })
            contentView?.addSubview(cancelAction)
            self.actions.insert(cancelAction, at: 0)
            
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            contentView?.addSubview(separatorView)
            self.actionSeparatorViews.insert(separatorView, at: 0)
        }
        
        // 把所有action添加到contentView中
        self.actions.forEach { (action) in
            if action.superview == nil {
                contentView?.addSubview(action)
            }
        }
        self.actionSeparatorViews.forEach { (separatorView) in
            if separatorView.superview == nil {
                contentView?.addSubview(separatorView)
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
//        self.view.addGestureRecognizer(tap)
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutContents()
    }
    
    // MARK: layout
    open func layoutContents() {
        if self.contentType == .custom {
            // custom模式下，布局由开发者控制
            return
        }
        
        guard let contentView = self.contentView else {
            return
        }
        
        let screenFactor = UIScreen.main.bounds.width / 375
        let verticalGap: CGFloat = 10
        let herizontalGap: CGFloat = 30
        let actionHeight: CGFloat = 45
        let contentWidth = self.view.bounds.width - herizontalGap * 2 * screenFactor
        let contentMaxHeight = CGFloat.minimum(self.view.bounds.height - verticalGap * 2 * screenFactor, 400)
        var contentHeight: CGFloat = 0.0
        
        if let titleView = self.titleView {
            contentHeight += verticalGap
            if self.contentType == .`default` {
                // 默认模式下
                titleView.frame.size.width = contentWidth - 30 * 2 * screenFactor
                titleView.sizeToFit()
                titleView.center = CGPoint(x: contentWidth / 2,
                                           y: verticalGap + titleView.frame.height / 2)
                
                contentHeight += titleView.frame.height
            } else if self.contentType == .customMessage {
                titleView.center = CGPoint(x: contentWidth / 2,
                                           y: verticalGap + titleView.frame.height / 2)
                contentHeight += titleView.frame.height
            }
        }
        
        if self.actions.count > 2 {
            // 两个以上按钮
            contentHeight += verticalGap
            self.actions.enumerated().forEach({ (index, action) in
                action.frame = CGRect(x: 0,
                                      y: contentView.frame.height - CGFloat(index + 1) * actionHeight,
                                      width: contentWidth,
                                      height: actionHeight)
                action.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                
                contentHeight += actionHeight
            })
            self.actionSeparatorViews.enumerated().forEach({ (index, separatorView) in
                separatorView.frame = CGRect(x: 0,
                                             y: contentView.frame.height - CGFloat(index + 1) * actionHeight,
                                             width: contentWidth,
                                             height: 0.5)
                separatorView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            })
        } else if self.actions.count > 0 {
            // 两个以下按钮
            contentHeight += verticalGap
            let actionWidth = contentWidth / CGFloat(self.actions.count)
            self.actions.enumerated().forEach({ (index, action) in
                action.frame = CGRect(x: actionWidth * CGFloat(index),
                                      y: contentView.frame.height - actionHeight,
                                      width: actionWidth,
                                      height: actionHeight)
                action.autoresizingMask = [.flexibleTopMargin]
            })
            self.actionSeparatorViews.enumerated().forEach({ (index, separatorView) in
                if index == 0 {
                    // 第一个放在最上面
                    separatorView.frame = CGRect(x: 0,
                                                 y: contentView.frame.height - actionHeight,
                                                 width: contentWidth,
                                                 height: 0.5)
                    separatorView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                } else {
                    separatorView.frame = CGRect(x: actionWidth * CGFloat(index),
                                                 y: contentView.frame.height - actionHeight,
                                                 width: 0.5,
                                                 height: actionHeight)
                    separatorView.autoresizingMask = [.flexibleTopMargin]
                }
            })
            contentHeight += actionHeight
        }
        
        if let messageView = self.messageView {
            contentHeight += verticalGap
            if self.contentType == .`default` {
//                let messageHeight = CGFloat.minimum((messageView as! UITextView).contentSize.height,
//                                                    contentMaxHeight - contentHeight)
                // message view设置frame之后，contentSize才是正确值
                messageView.frame = CGRect(x: herizontalGap,
                                           y: (titleView?.frame.maxY ?? 0) + verticalGap,
                                           width: contentWidth - herizontalGap * 2 * screenFactor,
                                           height: contentMaxHeight - contentHeight)
                
                let messageContentSizeHeight = (messageView as! UITextView).contentSize.height
                if messageView.frame.height > messageContentSizeHeight {
                    // messageView高度高过contentSize时，则重新设置
                    messageView.frame.size.height = messageContentSizeHeight
                }
                contentHeight += messageView.frame.height
            }  else if self.contentType == .customMessage {
                messageView.center = CGPoint(x: contentWidth / 2,
                                             y: (titleView?.frame.maxY ?? 0) + verticalGap + messageView.frame.height / 2)
                contentHeight += messageView.frame.height
            }
        }
        
        contentView.frame.size = CGSize(width: contentWidth, height: contentHeight)
        contentView.center = CGPoint(x: self.view.bounds.width / 2.0,
                                     y: self.view.bounds.height / 2.0)
    }
    
    // MARK: Actions
    public func add(action: CYAlertAction) {
        if self.contentType == .custom {
            return
        }
        
        self.contentView?.addSubview(action)
        self.actions.append(action)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        self.contentView?.addSubview(separatorView)
        self.actionSeparatorViews.append(separatorView)
    }
    
    // MARK: Event
    @objc func backgroundTapped(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CYAlertAnimator(operation: .present)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CYAlertAnimator(operation: .dismiss)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }

    
}

public class CYAlertAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public enum CYAlertAnimationOperation: Int {
        public typealias RawValue = Int
        
        case present = 0
        case dismiss
    }
    
    
    private(set) var operation: CYAlertAnimationOperation
    
    public init(operation: CYAlertAnimationOperation) {
        self.operation = operation
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .present {
            self.presentTransition(using: transitionContext)
        } else {
            self.dismissTransition(using: transitionContext)
        }
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }
        let toFrame = transitionContext.finalFrame(for: toViewController)
        toView.frame = toFrame
        toView.backgroundColor = UIColor.clear
        transitionContext.containerView.addSubview(toView)
        
        let alertController = toViewController as? CYAlertController
        alertController?.contentView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut], animations: {
            
            toView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            alertController?.contentView?.transform = .identity
        }) { (finished) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                toView.removeFromSuperview()
            }
        }
    }
    
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
                return
        }
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromView.backgroundColor = UIColor.clear
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
