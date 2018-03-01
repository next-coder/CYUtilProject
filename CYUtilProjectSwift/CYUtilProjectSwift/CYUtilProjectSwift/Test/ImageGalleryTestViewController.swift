//
//  ImageGalleryTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 28/02/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class ImageGalleryTestViewController: UIViewController {

    var imageGallery: ImageGalleryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []

        imageGallery = ImageGalleryView(images: [UIImage(named: "home_header_realname_auth")!,
                                                 UIImage(named: "home_header_recharge")!,
                                                 UIImage(named: "home_header_register")!],
                                        frame: self.view.bounds)
        imageGallery?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageGallery?.maximumZoomScale = 2.0
        self.view.addSubview(imageGallery!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
