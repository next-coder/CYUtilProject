//
//  CYAlertController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 18/01/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

open class CYAlertController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private(set) public lazy var actoins: [CYAlertAction] = [CYAlertAction]()
    private var contentView: UIView!
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
        
        if contentView == nil {
            
            contentView = UIView()
            contentView.backgroundColor = UIColor.white
            self.view.addSubview(contentView)
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func configureContentView() {
        if contentView == nil {
            
            contentView = UIView()
            contentView.backgroundColor = UIColor.white
            self.view.addSubview(contentView)
            
            let contentLeft = NSLayoutConstraint(item: contentView,
                                                 attribute: .left,
                                                 relatedBy: .equal,
                                                 toItem: self.view,
                                                 attribute: .left,
                                                 multiplier: 1,
                                                 constant: 20)
            let contentRight = NSLayoutConstraint(item: contentView,
                                                  attribute: .right,
                                                  relatedBy: .equal,
                                                  toItem: self.view,
                                                  attribute: .right,
                                                  multiplier: 1,
                                                  constant: -20)
            let contentCenterY = NSLayoutConstraint(item: contentView,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0)
            self.view.addConstraints([contentLeft, contentRight, contentCenterY])
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        self.view.addGestureRecognizer(tap)
        
        configureActions()
    }
    
    private func configureActions() {
        for action in self.actoins {
            self.contentView.addSubview(action)
            
        }
    }
    
    // MARK: Actions
    public func add(action: CYAlertAction) {
        self.actoins.append(action)
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
        return 0.2
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
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
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
