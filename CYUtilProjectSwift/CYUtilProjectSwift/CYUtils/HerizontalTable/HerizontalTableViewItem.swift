//
//  HerizontalTableViewItem.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 12/06/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

public class HerizontalTableViewItem: UIView {

    @IBOutlet private(set) var reuseIdentifier: String?
    @IBOutlet private(set) var contentView: UIView!

    override convenience init(frame: CGRect) {
        self.init(reuseIdentifier: nil)
    }

    public init(reuseIdentifier: String?) {
        super.init(frame: CGRect.zero)

        self.reuseIdentifier = reuseIdentifier
        if contentView == nil {
            contentView = UIView()
            addSubview(contentView)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.reuseIdentifier = aDecoder.decodeObject(forKey: "reuseIdentifier") as? String
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        if contentView == nil {
            contentView = UIView()
            addSubview(contentView)
        }
    }

}
