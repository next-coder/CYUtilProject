//
//  CYAlertWindow.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 21/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

extension UIWindow {

    func show_cyalert() {

        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindowLevelStatusBar + 1
        self.isHidden = false
        self.makeKeyAndVisible()
        UIView.animate(withDuration: 0.3) {

            self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
    }

    func dismiss_cyalert() {

        UIView.animate(withDuration: 0.3,
                       animations: {

                        self.backgroundColor = UIColor.clear
        }) { (finished) in

            self.resignKey()
            self.isHidden = true
        }
    }

}
