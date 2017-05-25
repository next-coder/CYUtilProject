//
//  SendRedPacketView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 25/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class SendRedPacketView: UIView {

    var bombWeiShuView: UIView!
    var bombWeiShuTitleLabel: UILabel!
    var bombWeiShuTextField: UITextField!

    var totalAmountView: UIView!
    var totalAmountTitleLabel: UILabel!
    var totalAmountTextField: UITextField!

    var redPacketTypeTipsLabel: UILabel!

    var blessingView: UIView!
    var blessingTextView: UITextView!

    var sendButton: UIButton!

    var bottomTipsLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubviews()
        createConstraints()
        self.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        bombWeiShuView = UIView()
        bombWeiShuView.backgroundColor = UIColor.white
        bombWeiShuView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bombWeiShuView)

        bombWeiShuTitleLabel = UILabel()
        bombWeiShuTitleLabel.font = UIFont.systemFont(ofSize: 16)
        bombWeiShuTitleLabel.textColor = UIColor.darkText
        bombWeiShuTitleLabel.text = "中雷尾数"
        bombWeiShuTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bombWeiShuView.addSubview(bombWeiShuTitleLabel)

        bombWeiShuTextField = UITextField()
        bombWeiShuTextField.font = UIFont.systemFont(ofSize: 16)
        bombWeiShuTextField.placeholder = "填写尾数"
        bombWeiShuTextField.keyboardType = .numberPad
        bombWeiShuTextField.translatesAutoresizingMaskIntoConstraints = false
        bombWeiShuView.addSubview(bombWeiShuTextField)

        totalAmountView = UIView()
        totalAmountView.backgroundColor = UIColor.white
        totalAmountView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalAmountView)

        totalAmountTitleLabel = UILabel()
        totalAmountTitleLabel.font = UIFont.systemFont(ofSize: 16)
        totalAmountTitleLabel.textColor = UIColor.darkText
        totalAmountTitleLabel.text = "总金额"
        totalAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountView.addSubview(totalAmountTitleLabel)

        totalAmountTextField = UITextField()
        totalAmountTextField.font = UIFont.systemFont(ofSize: 16)
        totalAmountTextField.placeholder = "填写金额"
        totalAmountTextField.keyboardType = .decimalPad
        totalAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        totalAmountView.addSubview(totalAmountTextField)

        let unitLabel = UILabel()
        unitLabel.font = UIFont.systemFont(ofSize: 16)
        unitLabel.textColor = UIColor.darkText
        unitLabel.text = "元";
        unitLabel.sizeToFit()
        totalAmountTextField.rightView = unitLabel
        totalAmountTextField.rightViewMode = .always

        redPacketTypeTipsLabel = UILabel()
        redPacketTypeTipsLabel.font = UIFont.systemFont(ofSize: 12)
        redPacketTypeTipsLabel.textColor = UIColor.gray
        redPacketTypeTipsLabel.text = "当前为拼手气红包"
        redPacketTypeTipsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(redPacketTypeTipsLabel)

        blessingView = UIView()
        blessingView.backgroundColor = UIColor.white
        blessingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blessingView)

        blessingTextView = UITextView()
        blessingTextView.backgroundColor = UIColor.white
        blessingTextView.font = UIFont.systemFont(ofSize: 16)
        blessingTextView.textColor = UIColor.darkText
        blessingTextView.text = "恭喜发财，大吉大利！"
        blessingTextView.translatesAutoresizingMaskIntoConstraints = false
        blessingView.addSubview(blessingTextView)

        sendButton = UIButton()
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .highlighted)
        sendButton.setBackgroundImage(UIImage(named: "RedPacketAssets.bundle/button_red_normal")?.resizableImage(withCapInsets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)), for: .normal)
        sendButton.setTitle("塞钱进红包", for: .normal)
        sendButton.layer.cornerRadius = 5
        sendButton.clipsToBounds = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendButton)

        bottomTipsLabel = UILabel()
        bottomTipsLabel.font = UIFont.systemFont(ofSize: 12)
        bottomTipsLabel.textColor = UIColor.lightGray
        bottomTipsLabel.backgroundColor = UIColor.clear
        bottomTipsLabel.text = "未领取的红包，将于24小时后发起退款"
        bottomTipsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomTipsLabel)
    }

    func createConstraints() {
        let bombWeiShuLeft = NSLayoutConstraint(item: bombWeiShuView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let bombWeiShuRight = NSLayoutConstraint(item: bombWeiShuView,
                                                attribute: .right,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .right,
                                                multiplier: 1,
                                                constant: 0)
        let bombWeiShuTop = NSLayoutConstraint(item: bombWeiShuView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 20)
        let bombWeiShuHeight = NSLayoutConstraint(item: bombWeiShuView,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 50)
        addConstraints([bombWeiShuLeft, bombWeiShuRight, bombWeiShuTop, bombWeiShuHeight])

        let bombWeiShuTitleLeft = NSLayoutConstraint(item: bombWeiShuTitleLabel,
                                                   attribute: .left,
                                                   relatedBy: .equal,
                                                   toItem: bombWeiShuView,
                                                   attribute: .left,
                                                   multiplier: 1,
                                                   constant: 20)
        let bombWeiShuTitleCenterY = NSLayoutConstraint(item: bombWeiShuTitleLabel,
                                                  attribute: .centerY,
                                                  relatedBy: .equal,
                                                  toItem: bombWeiShuView,
                                                  attribute: .centerY,
                                                  multiplier: 1,
                                                  constant: 0)
        addConstraints([bombWeiShuTitleLeft, bombWeiShuTitleCenterY])

        let bombWeiShuTextWidth = NSLayoutConstraint(item: bombWeiShuTextField,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 100)
        let bombWeiShuTextRight = NSLayoutConstraint(item: bombWeiShuTextField,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: bombWeiShuView,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: -5)
        let bombWeiShuTextCenterY = NSLayoutConstraint(item: bombWeiShuTextField,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: bombWeiShuView,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 0)
        let bombWeiShuTextHeight = NSLayoutConstraint(item: bombWeiShuTextField,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 50)
        addConstraints([bombWeiShuTextWidth, bombWeiShuTextRight, bombWeiShuTextCenterY, bombWeiShuTextHeight])


        let totalAmountLeft = NSLayoutConstraint(item: totalAmountView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let totalAmountRight = NSLayoutConstraint(item: totalAmountView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let totalAmountTop = NSLayoutConstraint(item: totalAmountView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: bombWeiShuView,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: 20)
        let totalAmountHeight = NSLayoutConstraint(item: totalAmountView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 50)
        addConstraints([totalAmountLeft, totalAmountRight, totalAmountTop, totalAmountHeight])

        let totalAmountTitleLeft = NSLayoutConstraint(item: totalAmountTitleLabel,
                                                     attribute: .left,
                                                     relatedBy: .equal,
                                                     toItem: totalAmountView,
                                                     attribute: .left,
                                                     multiplier: 1,
                                                     constant: 20)
        let totalAmountTitleCenterY = NSLayoutConstraint(item: totalAmountTitleLabel,
                                                        attribute: .centerY,
                                                        relatedBy: .equal,
                                                        toItem: totalAmountView,
                                                        attribute: .centerY,
                                                        multiplier: 1,
                                                        constant: 0)
        addConstraints([totalAmountTitleLeft, totalAmountTitleCenterY])

        let totalAmountTextWidth = NSLayoutConstraint(item: totalAmountTextField,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 100)
        let totalAmountTextRight = NSLayoutConstraint(item: totalAmountTextField,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: totalAmountView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: -5)
        let totalAmountTextCenterY = NSLayoutConstraint(item: totalAmountTextField,
                                                       attribute: .centerY,
                                                       relatedBy: .equal,
                                                       toItem: totalAmountView,
                                                       attribute: .centerY,
                                                       multiplier: 1,
                                                       constant: 0)
        let totalAmountTextHeight = NSLayoutConstraint(item: totalAmountTextField,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 50)
        addConstraints([totalAmountTextWidth, totalAmountTextRight, totalAmountTextCenterY, totalAmountTextHeight])

        let redPacketTypeLeft = NSLayoutConstraint(item: redPacketTypeTipsLabel,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1,
                                              constant: 20)
        let redPacketTypeTop = NSLayoutConstraint(item: redPacketTypeTipsLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: totalAmountView,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 10)
        addConstraints([redPacketTypeLeft, redPacketTypeTop])

        let blessingViewLeft = NSLayoutConstraint(item: blessingView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let blessingViewRight = NSLayoutConstraint(item: blessingView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let blessingViewTop = NSLayoutConstraint(item: blessingView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: totalAmountView,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: 40)
        let blessingViewHeight = NSLayoutConstraint(item: blessingView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 100)
        addConstraints([blessingViewLeft, blessingViewRight, blessingViewTop, blessingViewHeight])

        let blessingLeft = NSLayoutConstraint(item: blessingTextView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: blessingView,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 20)
        let blessingRight = NSLayoutConstraint(item: blessingTextView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: blessingView,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: -20)
        let blessingTop = NSLayoutConstraint(item: blessingTextView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: blessingView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 10)
        let blessingHeight = NSLayoutConstraint(item: blessingTextView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 80)
        addConstraints([blessingLeft, blessingRight, blessingTop, blessingHeight])


        let sendLeft = NSLayoutConstraint(item: sendButton,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 20)
        let sendRight = NSLayoutConstraint(item: sendButton,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: -20)
        let sendTop = NSLayoutConstraint(item: sendButton,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: blessingTextView,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: 40)
        let sendHeight = NSLayoutConstraint(item: sendButton,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 50)
        addConstraints([sendLeft, sendRight, sendTop, sendHeight])

        let bottomTipsCenterX = NSLayoutConstraint(item: bottomTipsLabel,
                                          attribute: .centerX,
                                          relatedBy: .equal,
                                          toItem: self,
                                          attribute: .centerX,
                                          multiplier: 1,
                                          constant: 0)
        let bottomTipsBottom = NSLayoutConstraint(item: bottomTipsLabel,
                                           attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .bottom,
                                           multiplier: 1,
                                           constant: -20)
        addConstraints([bottomTipsCenterX, bottomTipsBottom])

    }

}
