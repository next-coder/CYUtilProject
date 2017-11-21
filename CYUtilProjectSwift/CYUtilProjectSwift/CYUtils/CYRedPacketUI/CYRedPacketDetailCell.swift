//
//  CYRedPacketDetailCell.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 21/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

class CYRedPacketDetailCell: UITableViewCell {

    var headImageButton: UIButton!
    var luckiestButton: UIButton!

    var nicknameLabel: UILabel!
    var timeLabel: UILabel!
    var amountLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        createSubviews()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {

        headImageButton = UIButton(type: .custom)
        headImageButton.layer.cornerRadius = 2
//        headImageButton.addTarget(self,
//                                  action: #selector(headImageTapped),
//                                  for: .touchUpInside)
        headImageButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headImageButton)

        luckiestButton = UIButton(type: .custom)
        luckiestButton.setTitleColor(UIColor(red: 253/255.0, green: 145/255.0, blue: 73/255.0, alpha: 1),
                                     for: .normal)
        luckiestButton.setTitleColor(UIColor(red: 253/255.0, green: 145/255.0, blue: 73/255.0, alpha: 1),
                                     for: .highlighted)
        luckiestButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        luckiestButton.isEnabled = false
        luckiestButton.setTitle(NSLocalizedString("Luckiest Draw", comment: ""), for: .disabled)
        luckiestButton.setImage(UIImage(named: ""), for: .disabled)
        contentView.addSubview(luckiestButton)

        nicknameLabel = UILabel()
        nicknameLabel.textColor = UIColor.black
        nicknameLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(nicknameLabel)

        amountLabel = UILabel()
        amountLabel.textColor = UIColor.black
        amountLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(amountLabel)

        timeLabel = UILabel()
        timeLabel.textColor = UIColor.lightText
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(timeLabel)
    }

    func createConstraints() {

        let headImageLeft = NSLayoutConstraint(item: headImageButton,
                                               attribute: .left,
                                               relatedBy: .equal,
                                               toItem: contentView,
                                               attribute: .left,
                                               multiplier: 1,
                                               constant: 20)
        let headImageTop = NSLayoutConstraint(item: headImageButton,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: contentView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 20)
        let headImageWidth = NSLayoutConstraint(item: headImageButton,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               multiplier: 1,
                                               constant: 35)
        let headImageHeight = NSLayoutConstraint(item: headImageButton,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               multiplier: 1,
                                               constant: 35)
        addConstraints([headImageLeft, headImageTop, headImageWidth, headImageHeight])

        let nicknameLeft = NSLayoutConstraint(item: nicknameLabel,
                                               attribute: .left,
                                               relatedBy: .equal,
                                               toItem: headImageButton,
                                               attribute: .right,
                                               multiplier: 1,
                                               constant: 20)
        let nicknameTop = NSLayoutConstraint(item: nicknameLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: headImageButton,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0)
        addConstraints([nicknameLeft, nicknameTop])

        let timeLeft = NSLayoutConstraint(item: timeLabel,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: headImageButton,
                                              attribute: .right,
                                              multiplier: 1,
                                              constant: 20)
        let timeBottom = NSLayoutConstraint(item: timeLabel,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: headImageButton,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 0)
        addConstraints([timeLeft, timeBottom])

        let amountRight = NSLayoutConstraint(item: amountLabel,
                                          attribute: .right,
                                          relatedBy: .equal,
                                          toItem: contentView,
                                          attribute: .right,
                                          multiplier: 1,
                                          constant: -20)
        let amountTop = NSLayoutConstraint(item: amountLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: headImageButton,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0)
        addConstraints([amountRight, amountTop])

        let luckiestRight = NSLayoutConstraint(item: luckiestButton,
                                             attribute: .right,
                                             relatedBy: .equal,
                                             toItem: contentView,
                                             attribute: .right,
                                             multiplier: 1,
                                             constant: -20)
        let luckiestBottom = NSLayoutConstraint(item: luckiestButton,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: headImageButton,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 0)
        addConstraints([luckiestRight, luckiestBottom])
    }

}
