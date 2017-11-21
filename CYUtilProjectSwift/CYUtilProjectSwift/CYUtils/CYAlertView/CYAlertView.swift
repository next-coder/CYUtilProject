//
//  CYAlertView.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 6/20/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit
import CoreGraphics

class CYAlertView: UIView {

    var showWindow: UIWindow?

    var contentView: UIView

    var titleLabel: UILabel?
    var messageLabel: UILabel?

    fileprivate var title: String?
    fileprivate var message: String?

    fileprivate var customViews: [UIView]?
    fileprivate var alertActions: [CYAlertViewAction]?

    // action background, for line between actions
    fileprivate var actionBackgroundView: UIView?

    fileprivate var contentCenterYConstraint: NSLayoutConstraint?

    // init methods
    convenience init(title: String?, message: String?, cancelItemTitle: String?) {

        self.init(title: title, message: message, customViews: nil, alertActions: nil)
    }

    init(title: String?, message: String?, customViews: [UIView]?, alertActions: [CYAlertViewAction]?) {

        self.title = title
        self.message = message
        self.customViews = customViews
        self.alertActions = alertActions

        self.contentView = UIView()

        super.init(frame: CGRect.zero)

        // add content
        self.addSubview(contentView)

        self.createAlertViewSubviews()
        self.layoutAlertViewSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {

        self.contentView = UIView()
        super.init(coder: aDecoder)
        self.addSubview(self.contentView)
    }

    // subviews
    func createAlertViewSubviews() {

        let actionBackground = UIView()
        actionBackground.backgroundColor = UIColor(red: 225/255.0,
                                                   green: 225/255.0,
                                                   blue: 225/255.0,
                                                   alpha: 1)
        self.contentView.addSubview(actionBackground)
        self.actionBackgroundView = actionBackground

        if let title = self.title {

            let titleLabel = UILabel(frame: CGRect.zero)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            titleLabel.textColor = UIColor.black
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            self.contentView.addSubview(titleLabel)
            self.titleLabel = titleLabel
        }

        if let message = self.message {

            let messageLabel = UILabel(frame: CGRect.zero)
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabel.textColor = UIColor.darkGray
            messageLabel.numberOfLines = 0
            messageLabel.text = message
            self.contentView.addSubview(messageLabel)
            self.messageLabel = messageLabel
        }
    }

    func layoutAlertViewSubviews() {

        self.layoutContentView()

        var nextView: UIView? = nil
        if let titleLabel = self.titleLabel {

            self.layoutTitleLabel()
            nextView = titleLabel
        }
        if let messageLabel = self.messageLabel {

            self.layoutMessageLabel()
            nextView = messageLabel
        }

        if let customViews = self.customViews, customViews.count > 0 {

            self.layoutCustomViews(nextView)
            nextView = customViews.last
        }

        if let alertActions = self.alertActions, alertActions.count > 0 {

            self.layoutActions(nextView)
            nextView = alertActions.last
        }

        self.layoutActionBackground()
    }

    // layout content view
    func layoutContentView() {

        let contentLeft = NSLayoutConstraint(item: self.contentView,
                                             attribute: .left,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .left,
                                             multiplier: 1,
                                             constant: 20)

        let contentRight = NSLayoutConstraint(item: self.contentView,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .right,
                                              multiplier: 1,
                                              constant: -20)

        let contentCenterY = NSLayoutConstraint(item: self.contentView,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .centerY,
                                                multiplier: 1,
                                                constant: 0)

        var contentBottom: NSLayoutConstraint
        if let lastSubview = self.lastSubview() {

            if lastSubview.isKind(of: CYAlertViewAction.self) {

                contentBottom = NSLayoutConstraint(item: self.contentView,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: lastSubview,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
            } else {

                contentBottom = NSLayoutConstraint(item: self.contentView,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: lastSubview,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: -20)
            }
        } else {

            contentBottom = NSLayoutConstraint(item: self.contentView,
                                               attribute: .bottom,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 10)
        }

        self.addConstraints([ contentLeft, contentRight, contentCenterY, contentBottom ])

        self.contentCenterYConstraint = contentCenterY
    }

    func lastSubview() -> UIView? {

        if let alertActions = self.alertActions, alertActions.count > 0 {

            return alertActions.last
        } else if let customViews = self.customViews, customViews.count > 0 {

            return customViews.last
        } else if let messageLabel = self.messageLabel {

            return messageLabel
        } else if let titleLabel = self.titleLabel {

            return titleLabel
        } else {

            return nil
        }
    }

    // must check titleLabel is not nil before you can call this method
    func layoutTitleLabel() {

        let titleCenterX = NSLayoutConstraint(item: self.titleLabel!,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self.contentView,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0)
        let titleTop = NSLayoutConstraint(item: self.titleLabel!,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: self.contentView,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 20)
        let titleWidth = NSLayoutConstraint(item: self.titleLabel!,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: self.contentView,
                                            attribute: .width,
                                            multiplier: 1,
                                            constant: -40)
        self.contentView.addConstraints([ titleCenterX, titleTop, titleWidth ])
    }

    // must check messageLabel is not nil
    func layoutMessageLabel() {

        var messageTop: NSLayoutConstraint
        if let titleLabel = self.titleLabel {

            messageTop = NSLayoutConstraint(item: self.messageLabel!,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: titleLabel,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 10)
        } else {

            messageTop = NSLayoutConstraint(item: self.messageLabel!,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self.contentView,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: 20)
        }

        let messageCenterX = NSLayoutConstraint(item: self.messageLabel!,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: self.contentView,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0)

        let messageWidth = NSLayoutConstraint(item: self.messageLabel!,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: self.contentView,
                                              attribute: .width,
                                              multiplier: 1,
                                              constant: -40)
        self.contentView.addConstraints([ messageTop, messageCenterX, messageWidth ])
    }

    // layout custom views
    func layoutCustomViews(_ previousView: UIView?) {

        let customViews = self.customViews!
        var internalPreviousView = previousView
        for customView in customViews {

            customView.translatesAutoresizingMaskIntoConstraints = false
            let centerX = NSLayoutConstraint(item: customView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.contentView,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
            centerX.priority = UILayoutPriority.defaultLow

            let height = NSLayoutConstraint(item: customView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: customView.frame.size.height)
            height.priority = UILayoutPriority.defaultLow

            let width = NSLayoutConstraint(item: customView,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 1,
                                           constant: customView.frame.size.width)
            width.priority = UILayoutPriority.defaultLow

            var top: NSLayoutConstraint
            if let previous = internalPreviousView {

                top = NSLayoutConstraint(item: customView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: previous,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 10)
            } else {

                top = NSLayoutConstraint(item: customView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.contentView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 20)
            }
            self.contentView.addConstraints([ centerX, width, height, top ])

            internalPreviousView = customView
        }
    }

    // layout actions
    func layoutActions(_ previousView: UIView?) {

        if self.alertActions!.count > 2 {

            self.layoutVerticalActions(previousView)
        } else {

            self.layoutHerizontalActions(previousView)
        }
    }

    // layout herizontal actions
    func layoutHerizontalActions(_ previousView: UIView?) {

        let actions = self.alertActions!
        let actionsCount = actions.count

        if actionsCount == 0 {

            return
        }

        var leftAction: UIView = self
        for (index, action) in actions.enumerated() {

            let height = NSLayoutConstraint(item: action,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 45)

            var top: NSLayoutConstraint
            if let previous = previousView {

                top = NSLayoutConstraint(item: action,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: previous,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 10)
            } else {

                top = NSLayoutConstraint(item: action,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 20)
            }

            var left: NSLayoutConstraint
            if (index == 0) {

                left = NSLayoutConstraint(item: action,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: self.contentView,
                                          attribute: .left,
                                          multiplier: 1,
                                          constant: 0)
            } else {

                left = NSLayoutConstraint(item: action,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: leftAction,
                                          attribute: .right,
                                          multiplier: 1,
                                          constant: 1)
            }

            var right: NSLayoutConstraint
            if index == (actionsCount - 1) {

                right = NSLayoutConstraint(item: action,
                                           attribute: .right,
                                           relatedBy: .equal,
                                           toItem: self.contentView,
                                           attribute: .right,
                                           multiplier: 1,
                                           constant: 0)
            } else {

                right = NSLayoutConstraint(item: action,
                                           attribute: .right,
                                           relatedBy: .equal,
                                           toItem: self.contentView,
                                           attribute: .right,
                                           multiplier: 1.0 / CGFloat(actionsCount),
                                           constant: -1)
            }

            self.contentView.addConstraints([ height, top, left, right])
            leftAction = action
        }
    }

    // layout vertical actions
    func layoutVerticalActions(_ previousView: UIView?) {

        let actions = self.alertActions!
        var internalPreviousView = previousView
        for action in actions {

            let left = NSLayoutConstraint(item: action,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: self.contentView,
                                          attribute: .left,
                                          multiplier: 1,
                                          constant: 0)

            let right = NSLayoutConstraint(item: action,
                                           attribute: .right,
                                           relatedBy: .equal,
                                           toItem: self.contentView,
                                           attribute: .right,
                                           multiplier: 1,
                                           constant: 0)

            let height = NSLayoutConstraint(item: action,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 45)

            var top: NSLayoutConstraint
            if let previous = internalPreviousView {

                top = NSLayoutConstraint(item: action,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: previous,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 1)
            } else {

                top = NSLayoutConstraint(item: action,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.contentView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 1)
            }

            self.contentView.addConstraints([ left, right, height, top])
            internalPreviousView = action
        }
    }

    // layout action background
    func layoutActionBackground() {

        if let actions = self.alertActions, actions.count > 0 {

            let actionBackground = self.actionBackgroundView!
            let left = NSLayoutConstraint(item: actionBackground,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: self.contentView,
                                          attribute: .left,
                                          multiplier: 1,
                                          constant: 0)

            let right = NSLayoutConstraint(item: actionBackground,
                                           attribute: .right,
                                           relatedBy: .equal,
                                           toItem: self.contentView,
                                           attribute: .right,
                                           multiplier: 1,
                                           constant: 0)

            let top = NSLayoutConstraint(item: actionBackground,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: actions[0],
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: -1)

            let bottom = NSLayoutConstraint(item: actionBackground,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self.contentView,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 0)
            self.contentView.addConstraints([ left, right, top, bottom ])
        }
    }

    // show alert
    func showWithYInset(_ yInset: CGFloat, animated: Bool) {

        if self.showWindow == nil {

            self.showWindow = UIWindow(frame: UIScreen.main.bounds)
            self.showWindow?.backgroundColor = UIColor.clear
        }
        self.showWindow!.addSubview(self)
        self.frame = self.showWindow!.bounds
        self.contentCenterYConstraint?.constant = yInset

        self.showWindow!.makeKeyAndVisible()

        if animated {

            self.backgroundColor = UIColor.clear
            UIView.animate(withDuration: 0.3, animations: {

                self.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
            })

            let contentTransformAnimation = CAKeyframeAnimation(keyPath: "transform")
            contentTransformAnimation.values = [ NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                                 NSValue(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1)),
                                                 NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)) ]
            contentTransformAnimation.keyTimes = [ 0, 0.5, 1 ]
            contentTransformAnimation.duration = 0.3
            contentTransformAnimation.isRemovedOnCompletion = true
            contentTransformAnimation.fillMode = kCAFillModeForwards
            self.layer.add(contentTransformAnimation, forKey: "showAlert")
        } else {

            self.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }

    func showAnimated(_ animated: Bool) {

        self.showWithYInset(0, animated: animated)
    }

    func show() {

        self.showAnimated(true)
    }

    // dismiss
    func dismissAnimated(_ animated: Bool) {

        if animated {

            UIView.animate(withDuration: 0.2, animations: {

                self.showWindow?.alpha = 0
            }, completion: { (complete) in

                    self.showWindow?.resignKey()
                    self.removeFromSuperview()
            })
        } else {

            self.showWindow?.resignKey()
            self.removeFromSuperview()
        }
    }

    func dismiss() {

        self.dismissAnimated(true)
    }
}
