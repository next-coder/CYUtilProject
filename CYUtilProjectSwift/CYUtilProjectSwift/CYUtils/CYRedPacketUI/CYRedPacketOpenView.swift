//
//  CYRedPacketOpenView.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 21/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

@objc protocol CYRedPacketOpenViewDelegate {

    func redPacketOpenViewShouldDismiss(redPacketView: CYRedPacketOpenView)
    func redPacketOpenViewOpenPacket(redPacketView: CYRedPacketOpenView)

    @objc optional func redPacketOpenViewShowDetail(redPacketView: CYRedPacketOpenView)
    @objc optional func redPacketOpenViewTapHeadImage(redPacketView: CYRedPacketOpenView)
    @objc optional func redPacketOpenViewTapNickname(redPacketView: CYRedPacketOpenView)
}

enum CYRedPacketOpenViewState {
    case normal, runOut
}

class CYRedPacketOpenView: UIView {

    weak var delegate: CYRedPacketOpenViewDelegate?

    var backgroundView: UIImageView!
    var openBackgroundView: UIView!
//    var openBackgroundCycleView: UIView!
//    var openCenterRectView: UIView!

    var closeButton: UIButton!
    var headImageButton: UIButton!
    var nicknameButton: UIButton!
    var openButton: UIButton!
    var detailButton: UIButton!

    var receiveTipsLabel: UILabel!
    var blessingLabel: UILabel!

    var state: CYRedPacketOpenViewState = .normal {

        didSet {
            switch state {
            case .runOut:
                receiveTipsLabel.isHidden = true

                openButton.isHidden = true

                detailButton.setImage(nil, for: .normal)
                detailButton.setTitle(NSLocalizedString("View details>", comment: ""), for: .normal)
            default:
                receiveTipsLabel.isHidden = false
                receiveTipsLabel.text = NSLocalizedString("Send you a red packet", comment: "")

                openButton.isHidden = false

                detailButton.setImage(UIImage(named: ""), for: .normal)
                detailButton.setTitle(nil, for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubviews()
        createConstraints()
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let superview = self.superview {
            self.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
            self.center = CGPoint(x: superview.frame.width / 2.0, y: superview.frame.height / 2.0)
        }
    }

    func createSubviews() {

        backgroundView = UIImageView(frame: self.bounds)
        backgroundView.backgroundColor = UIColor(red: 224/255.0, green: 88/255.0, blue: 70/255.0, alpha: 1)
        backgroundView.image = UIImage(named: "")
        backgroundView.layer.cornerRadius = 3
        backgroundView.isUserInteractionEnabled = true
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.clipsToBounds = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        openBackgroundView = UIView()
        openBackgroundView.backgroundColor = UIColor(red: 223/255.0, green: 188/255.0, blue: 136/255.0, alpha: 1)
        openBackgroundView.layer.cornerRadius = 50
        openBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(openBackgroundView)

//        openBackgroundCycleView = UIView()
//        openBackgroundCycleView.backgroundColor = UIColor.clear
//        openBackgroundCycleView.layer.cornerRadius = 45
//        openBackgroundCycleView.layer.borderColor = UIColor.lightText.cgColor
//        openBackgroundCycleView.layer.borderWidth = 1.0
//        openBackgroundCycleView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.addSubview(openBackgroundCycleView)
//
//        openCenterRectView = UIView()
//        openCenterRectView.backgroundColor = UIColor.black
//        openCenterRectView.layer.borderColor = UIColor.lightText.cgColor
//        openCenterRectView.layer.borderWidth = 5.0
//        openCenterRectView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.addSubview(openCenterRectView)

        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "RedPacketAssets.bundle/redpacket_close"), for: .normal)
        closeButton.addTarget(self,
                              action: #selector(closeTapped),
                              for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(closeButton)

        headImageButton = UIButton(type: .custom)
        headImageButton.layer.cornerRadius = 2
        headImageButton.layer.borderColor = UIColor.white.cgColor
        headImageButton.layer.borderWidth = 2
        headImageButton.addTarget(self,
                                  action: #selector(headImageTapped),
                                  for: .touchUpInside)
        headImageButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(headImageButton)

        nicknameButton = UIButton(type: .custom)
        nicknameButton.setTitleColor(UIColor(red: 1, green: 227/255.0, blue: 186/255.0, alpha: 1),
                                     for: .normal)
        nicknameButton.setTitleColor(UIColor(red: 1, green: 227/255.0, blue: 186/255.0, alpha: 1),
                                     for: .highlighted)
        nicknameButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nicknameButton.addTarget(self,
                                 action: #selector(nicknameTapped),
                                 for: .touchUpInside)
        nicknameButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(nicknameButton)

        receiveTipsLabel = UILabel()
        receiveTipsLabel.backgroundColor = UIColor.clear
        receiveTipsLabel.textColor = UIColor(red: 1, green: 227/255.0, blue: 186/255.0, alpha: 1)
        receiveTipsLabel.font = UIFont.systemFont(ofSize: 12)
        receiveTipsLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(receiveTipsLabel)

        blessingLabel = UILabel()
        blessingLabel.backgroundColor = UIColor.clear
        blessingLabel.textColor = UIColor(red: 1, green: 227/255.0, blue: 186/255.0, alpha: 1)
        blessingLabel.font = UIFont.systemFont(ofSize: 16)
        blessingLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(blessingLabel)

        openButton = UIButton(type: .custom)
        openButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        openButton.setBackgroundImage(UIImage(named: ""), for: .highlighted)
        openButton.setTitleColor(UIColor.black, for: .normal)
        openButton.setTitleColor(UIColor.black, for: .highlighted)
        openButton.setTitle(NSLocalizedString("Open", comment: ""),
                            for: .normal)
        openButton.addTarget(self,
                             action: #selector(openTapped),
                             for: .touchUpInside)
//        openButton.backgroundColor = UIColor(red: 223/255.0, green: 188/255.0, blue: 136/255.0, alpha: 1)
        openButton.layer.cornerRadius = 50
//        openButton.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
//        openButton.layer.shadowColor = UIColor.black.cgColor
        openButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(openButton)

        detailButton = UIButton(type: .custom)
        detailButton.setTitleColor(UIColor(red: 1, green: 227/255.0, blue: 186/255.0, alpha: 1),
                                   for: .normal)
        detailButton.setTitleColor(UIColor(red: 1, green: 227/255.0, blue: 186/255.0, alpha: 1),
                                   for: .highlighted)
        detailButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        detailButton.addTarget(self,
                               action: #selector(detailTapped),
                               for: .touchUpInside)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(detailButton)
    }

    func createConstraints() {

        let backgroundLeft = NSLayoutConstraint(item: backgroundView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let backgroundRight = NSLayoutConstraint(item: backgroundView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let backgroundTop = NSLayoutConstraint(item: backgroundView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)
        let backgroundBottom = NSLayoutConstraint(item: backgroundView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        addConstraints([backgroundLeft, backgroundRight, backgroundTop, backgroundBottom])

        let openBackgroundCenterX = NSLayoutConstraint(item: openBackgroundView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: backgroundView,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let openBackgroundCenterY = NSLayoutConstraint(item: openBackgroundView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: backgroundView,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 60)
        let openBackgroundWidth = NSLayoutConstraint(item: openBackgroundView,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 1,
                                           constant: 100)
        let openBackgroundHeight = NSLayoutConstraint(item: openBackgroundView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 100)
        addConstraints([openBackgroundCenterX, openBackgroundCenterY, openBackgroundWidth, openBackgroundHeight])

//        let openBackgroundCycleCenterX = NSLayoutConstraint(item: openBackgroundCycleView,
//                                                       attribute: .centerX,
//                                                       relatedBy: .equal,
//                                                       toItem: backgroundView,
//                                                       attribute: .centerX,
//                                                       multiplier: 1,
//                                                       constant: 0)
//        let openBackgroundCycleCenterY = NSLayoutConstraint(item: openBackgroundCycleView,
//                                                       attribute: .centerY,
//                                                       relatedBy: .equal,
//                                                       toItem: backgroundView,
//                                                       attribute: .centerY,
//                                                       multiplier: 1,
//                                                       constant: 60)
//        let openBackgroundCycleWidth = NSLayoutConstraint(item: openBackgroundCycleView,
//                                                     attribute: .width,
//                                                     relatedBy: .equal,
//                                                     toItem: nil,
//                                                     attribute: .notAnAttribute,
//                                                     multiplier: 1,
//                                                     constant: 90)
//        let openBackgroundCycleHeight = NSLayoutConstraint(item: openBackgroundCycleView,
//                                                      attribute: .height,
//                                                      relatedBy: .equal,
//                                                      toItem: nil,
//                                                      attribute: .notAnAttribute,
//                                                      multiplier: 1,
//                                                      constant: 90)
//        addConstraints([openBackgroundCycleCenterX, openBackgroundCycleCenterY, openBackgroundCycleWidth, openBackgroundCycleHeight])
//
//        let openCenterRectCenterX = NSLayoutConstraint(item: openCenterRectView,
//                                                            attribute: .centerX,
//                                                            relatedBy: .equal,
//                                                            toItem: backgroundView,
//                                                            attribute: .centerX,
//                                                            multiplier: 1,
//                                                            constant: 0)
//        let openCenterRectCenterY = NSLayoutConstraint(item: openCenterRectView,
//                                                            attribute: .centerY,
//                                                            relatedBy: .equal,
//                                                            toItem: backgroundView,
//                                                            attribute: .centerY,
//                                                            multiplier: 1,
//                                                            constant: 60)
//        let openCenterRectWidth = NSLayoutConstraint(item: openCenterRectView,
//                                                          attribute: .width,
//                                                          relatedBy: .equal,
//                                                          toItem: nil,
//                                                          attribute: .notAnAttribute,
//                                                          multiplier: 1,
//                                                          constant: 30)
//        let openCenterRectHeight = NSLayoutConstraint(item: openCenterRectView,
//                                                           attribute: .height,
//                                                           relatedBy: .equal,
//                                                           toItem: nil,
//                                                           attribute: .notAnAttribute,
//                                                           multiplier: 1,
//                                                           constant: 30)
//        addConstraints([openCenterRectCenterX, openCenterRectCenterY, openCenterRectWidth, openCenterRectHeight])

        let closeLeft = NSLayoutConstraint(item: closeButton,
                                           attribute: .left,
                                           relatedBy: .equal,
                                           toItem: backgroundView,
                                           attribute: .left,
                                           multiplier: 1,
                                           constant: 0)
        let closeTop = NSLayoutConstraint(item: closeButton,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: backgroundView,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 0)
        let closeWidth = NSLayoutConstraint(item: closeButton,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 45)
        let closeHeight = NSLayoutConstraint(item: closeButton,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 45)
        addConstraints([closeLeft, closeTop, closeWidth, closeHeight])

        let headTop = NSLayoutConstraint(item: headImageButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: backgroundView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 30)
        let headCenterX = NSLayoutConstraint(item: headImageButton,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: backgroundView,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let headWidth = NSLayoutConstraint(item: headImageButton,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 1,
                                           constant: 50)
        let headHeight = NSLayoutConstraint(item: headImageButton,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 50)
        addConstraints([headTop, headCenterX, headWidth, headHeight])

        let nicknameTop = NSLayoutConstraint(item: nicknameButton,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: headImageButton,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 7)
        let nicknameCenterX = NSLayoutConstraint(item: nicknameButton,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
        addConstraints([nicknameTop, nicknameCenterX])

        let receiveTipsTop = NSLayoutConstraint(item: receiveTipsLabel,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: nicknameButton,
                                                attribute: .bottom,
                                                multiplier: 1,
                                                constant: 7)
        let receiveTipsCenterX = NSLayoutConstraint(item: receiveTipsLabel,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: backgroundView,
                                                    attribute: .centerX,
                                                    multiplier: 1,
                                                    constant: 0)
        addConstraints([receiveTipsTop, receiveTipsCenterX])

        let blessingCenterX = NSLayoutConstraint(item: blessingLabel,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
        let blessingCenterY = NSLayoutConstraint(item: blessingLabel,
                                                 attribute: .centerY,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .centerY,
                                                 multiplier: 1,
                                                 constant: -15)
        addConstraints([blessingCenterX, blessingCenterY])

        let openCenterX = NSLayoutConstraint(item: openButton,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: backgroundView,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let openCenterY = NSLayoutConstraint(item: openButton,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: backgroundView,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 60)
        let openWidth = NSLayoutConstraint(item: openButton,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 1,
                                           constant: 100)
        let openHeight = NSLayoutConstraint(item: openButton,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 100)
        addConstraints([openCenterX, openCenterY, openWidth, openHeight])

        let detailCenterX = NSLayoutConstraint(item: detailButton,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: backgroundView,
                                               attribute: .centerX,
                                               multiplier: 1,
                                               constant: 0)
        let detailBottom = NSLayoutConstraint(item: detailButton,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: backgroundView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: -15)
        addConstraints([detailCenterX, detailBottom])
    }

    @objc func closeTapped(sender: Any) {

        delegate?.redPacketOpenViewShouldDismiss(redPacketView: self)
    }

    @objc func headImageTapped(sender: Any) {

        delegate?.redPacketOpenViewTapHeadImage?(redPacketView: self)
    }

    @objc func nicknameTapped(sender: Any) {
        
        delegate?.redPacketOpenViewTapNickname?(redPacketView: self)
    }
    
    @objc func openTapped(sender: Any) {

        if let delegate = self.delegate {

            delegate.redPacketOpenViewOpenPacket(redPacketView: self)
            self.openButton.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat], animations: {

                self.openBackgroundView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            }, completion: nil)
        }
    }

    func endOpen() {
        self.openBackgroundView.layer.removeAllAnimations()
        self.openBackgroundView.layer.transform = CATransform3DIdentity
        self.openButton.isHidden = false
    }
    
    @objc func detailTapped(sender: Any) {
        
        delegate?.redPacketOpenViewShowDetail?(redPacketView: self)
    }
}
