//
//  AnimatedImageTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 24/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class AnimatedImageTestViewController: UIViewController {

    private var animatedImageView: CYAnimatedImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "CYAnimatedImageView"

        animatedImageView = CYAnimatedImageView(frame: CGRect(x: 20, y: 200, width: 200, height: 200))
        self.view.addSubview(animatedImageView!)

        animatedImageView?.setImage(UIImage(named: "logo5858.png")!, animated: true)
    }
}
