//
//  ImageBannerTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 01/03/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class ImageBannerTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let banner = ImageBannerView(images: [UIImage(named: "home_header_realname_auth")!,
                                              UIImage(named: "home_header_recharge")!,
                                              UIImage(named: "home_header_register")!],
                                     cycleScrolling: true,
                                     frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 300))
        self.view.addSubview(banner)
        banner.startAutoplay(5)
    }

}
