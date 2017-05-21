//
//  CYRedPacketDetailHeaderView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 21/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class CYRedPacketDetailHeaderView: UIView {

    var backgroundView: UIImageView!

    var headImageButton: UIButton!
    var fromButton: UIButton!
    var typeButton: UIButton!

    var blessingLabel: UILabel!
    var amountLabel: UILabel!
    var unitLabel: UILabel!
    var transferLabel: UILabel!
    var detailsTitleLabel: UILabel!

    var bottomLineView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubviews()
        createConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {

        backgroundView = UIImageView(frame: self.bounds)
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.image = UIImage(named: "")
        backgroundView.isUserInteractionEnabled = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        headImageButton = UIButton(type: .custom)
        headImageButton.layer.cornerRadius = 2
        headImageButton.layer.borderColor = UIColor.white.cgColor
        headImageButton.layer.borderWidth = 2
//        headImageButton.addTarget(self,
//                                  action: #selector(headImageTapped),
//                                  for: .touchUpInside)
        headImageButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(headImageButton)

        fromButton = UIButton(type: .custom)
        fromButton.setTitleColor(UIColor.black,
                                     for: .normal)
        fromButton.setTitleColor(UIColor.black,
                                     for: .highlighted)
        fromButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        fromButton.addTarget(self,
//                                 action: #selector(fromTapped),
//                                 for: .touchUpInside)
        fromButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(fromButton)

        typeButton = UIButton(type: .custom)
//        typeButton.addTarget(self,
//                             action: #selector(typeTapped),
//                             for: .touchUpInside)
        typeButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(typeButton)

        blessingLabel = UILabel()
        blessingLabel.backgroundColor = UIColor.clear
        blessingLabel.textColor = UIColor.darkGray
        blessingLabel.font = UIFont.systemFont(ofSize: 13)
        blessingLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(blessingLabel)

        amountLabel = UILabel()
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.textColor = UIColor.black
        amountLabel.font = UIFont.systemFont(ofSize: 18)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(amountLabel)

        unitLabel = UILabel()
        unitLabel.backgroundColor = UIColor.clear
        unitLabel.textColor = UIColor.darkGray
        unitLabel.font = UIFont.systemFont(ofSize: 12)
        unitLabel.text = NSLocalizedString("yuan", comment: "")
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(unitLabel)

        transferLabel = UILabel()
        transferLabel.backgroundColor = UIColor.clear
        transferLabel.textColor = UIColor.lightGray
        transferLabel.font = UIFont.systemFont(ofSize: 12)
        transferLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(transferLabel)

        detailsTitleLabel = UILabel()
        detailsTitleLabel.backgroundColor = UIColor.clear
        detailsTitleLabel.textColor = UIColor.lightGray
        detailsTitleLabel.font = UIFont.systemFont(ofSize: 12)
        detailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(detailsTitleLabel)

        bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor(red: 234/255.0,
                                                 green: 234/255.0,
                                                 blue: 234/255.0,
                                                 alpha: 1)
        backgroundView .addSubview(bottomLineView)
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

        let headTop = NSLayoutConstraint(item: headImageButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: backgroundView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 20)
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
                                           constant: 60)
        let headHeight = NSLayoutConstraint(item: headImageButton,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: 60)
        addConstraints([headTop, headCenterX, headWidth, headHeight])

        let fromTop = NSLayoutConstraint(item: fromButton,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: headImageButton,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 10)
        let fromCenterX = NSLayoutConstraint(item: fromButton,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
        addConstraints([fromTop, fromCenterX])

        let typeLeft = NSLayoutConstraint(item: typeButton,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: fromButton,
                                          attribute: .right,
                                          multiplier: 1,
                                          constant: 3)
        let typeCenterY = NSLayoutConstraint(item: typeButton,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: fromButton,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)
        addConstraints([typeLeft, typeCenterY])

        let blessingCenterX = NSLayoutConstraint(item: blessingLabel,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
        let blessingTop = NSLayoutConstraint(item: blessingLabel,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: fromButton,
                                                 attribute: .bottom,
                                                 multiplier: 1,
                                                 constant: 10)
        addConstraints([blessingCenterX, blessingTop])

        let amountCenterX = NSLayoutConstraint(item: amountLabel,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
        let amountTop = NSLayoutConstraint(item: amountLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: backgroundView,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 10)
        addConstraints([amountCenterX, amountTop])

        let unitLeft = NSLayoutConstraint(item: unitLabel,
                                               attribute: .left,
                                               relatedBy: .equal,
                                               toItem: amountLabel,
                                               attribute: .right,
                                               multiplier: 1,
                                               constant: 3)
        let unitBottom = NSLayoutConstraint(item: unitLabel,
                                           attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: amountLabel,
                                           attribute: .bottom,
                                           multiplier: 1,
                                           constant: 0)
        addConstraints([unitLeft, unitBottom])

        let transferCenterX = NSLayoutConstraint(item: transferLabel,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: backgroundView,
                                               attribute: .centerX,
                                               multiplier: 1,
                                               constant: 0)
        let transferTop = NSLayoutConstraint(item: transferLabel,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: amountLabel,
                                           attribute: .bottom,
                                           multiplier: 1,
                                           constant: 10)
        addConstraints([transferCenterX, transferTop])

        let bottomLineLeft = NSLayoutConstraint(item: bottomLineView, 
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: backgroundView,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let bottomLineRight = NSLayoutConstraint(item: bottomLineView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let bottomLineBottom = NSLayoutConstraint(item: bottomLineView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: backgroundView,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        let bottomLineHeight = NSLayoutConstraint(item: bottomLineView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 0.5)
        addConstraints([bottomLineLeft, bottomLineRight, bottomLineBottom, bottomLineHeight])

        let detailTitleLeft = NSLayoutConstraint(item: detailsTitleLabel,
                                                 attribute: .left,
                                                 relatedBy: .equal,
                                                 toItem: backgroundView,
                                                 attribute: .left,
                                                 multiplier: 1,
                                                 constant: 20)
        let detailTitleBottom = NSLayoutConstraint(item: detailsTitleLabel,
                                                 attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: bottomLineView,
                                                 attribute: .top,
                                                 multiplier: 1,
                                                 constant: -10)
        addConstraints([detailTitleLeft, detailTitleBottom])
    }

//    func headImageTapped(sender: Any) {
//
//        delegate?.redPacketOpenViewTapHeadImage?(redPacketView: self)
//    }
//
//    func fromTapped(sender: Any) {
//
//        delegate?.redPacketOpenViewTapNickname?(redPacketView: self)
//    }
//
//    func typeTapped(sender: Any) {
//
//        delegate?.redPacketOpenViewOpenPacket(redPacketView: self)
//    }

}
