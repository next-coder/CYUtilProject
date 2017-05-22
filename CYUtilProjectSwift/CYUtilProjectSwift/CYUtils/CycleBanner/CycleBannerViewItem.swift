//
//  CycleBannerViewCell.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class CycleBannerViewItem: UIView {

    @IBOutlet private(set) var reuseIdentifier: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(reuseIdentifier: String?) {
        self.reuseIdentifier = reuseIdentifier

        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        self.reuseIdentifier = aDecoder.decodeObject(forKey: "reuseIdentifier") as? String

        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
