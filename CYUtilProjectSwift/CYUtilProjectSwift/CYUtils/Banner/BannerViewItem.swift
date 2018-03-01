//
//  BannerViewCell.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

public class BannerViewItem: UIView {

    @IBOutlet private(set) var contentView: UIView!
    @IBOutlet private(set) var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }
    
    convenience init(image: UIImage) {
        self.init(frame: .zero)
        
        imageView?.image = image
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

        if imageView == nil {
            imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imageView)

            let imageLeft = NSLayoutConstraint(item: imageView,
                                                 attribute: .left,
                                                 relatedBy: .equal,
                                                 toItem: contentView,
                                                 attribute: .left,
                                                 multiplier: 1,
                                                 constant: 0)
            let imageRight = NSLayoutConstraint(item: imageView,
                                                  attribute: .right,
                                                  relatedBy: .equal,
                                                  toItem: contentView,
                                                  attribute: .right,
                                                  multiplier: 1,
                                                  constant: 0)
            let imageTop = NSLayoutConstraint(item: imageView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: contentView,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0)
            let imageBottom = NSLayoutConstraint(item: imageView,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
            addConstraints([imageLeft,imageRight, imageTop, imageBottom])
        }
    }

}
