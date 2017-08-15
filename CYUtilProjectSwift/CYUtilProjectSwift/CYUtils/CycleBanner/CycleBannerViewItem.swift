//
//  CycleBannerViewCell.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 22/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

public class CycleBannerViewItem: UIView {

    @IBOutlet private(set) var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        configureViews()
    }

    private func configureViews() {

        self.backgroundColor = UIColor.clear
        if contentView == nil {
            contentView = UIView(frame: self.bounds)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)

            let contentLeft = NSLayoutConstraint(item: contentView,
                                                 attribute: .left,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .left,
                                                 multiplier: 1,
                                                 constant: 0)
            let contentRight = NSLayoutConstraint(item: contentView,
                                                  attribute: .right,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .right,
                                                  multiplier: 1,
                                                  constant: 0)
            let contentTop = NSLayoutConstraint(item: contentView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0)
            let contentBottom = NSLayoutConstraint(item: contentView,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
            addConstraints([contentLeft,contentRight, contentTop, contentBottom])
        }
    }

}
