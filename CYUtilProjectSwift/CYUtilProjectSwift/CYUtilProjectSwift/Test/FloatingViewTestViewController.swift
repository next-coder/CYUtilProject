//
//  FloatingViewTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 02/08/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

class FloatingViewTestViewController: UIViewController {

    var floatingView: FloatingView?
    var test: Any?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []

        self.view.backgroundColor = UIColor.white

        floatingView = FloatingView(frame: CGRect(x: 0, y: 0, width: 40, height: 50),
                                    contentImage: UIImage(named: "logo5858.png")!,
                                    target: self,
                                    selector: #selector(tapFloating))
        floatingView?.margins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        floatingView?.edgesForFloating = [.left, .right]
//        floatingView?.isMovingEnabled = false
        view.addSubview(floatingView!)

        let contentView = UIView()
        contentView.backgroundColor = UIColor.red
        floatingView = FloatingView(frame: CGRect(x: 100, y: 0, width: 40, height: 50), contentView:contentView)
        floatingView?.margins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        floatingView?.edgesForFloating = [.left, .right]
//        floatingView?.isMovingEnabled = true
        view.addSubview(floatingView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tapFloating() {
        print("Floating tapped")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
