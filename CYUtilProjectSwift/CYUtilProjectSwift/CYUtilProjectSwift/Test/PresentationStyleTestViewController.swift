//
//  PresentationStyleTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 18/01/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class PresentationStyleTestViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UIViewControllerTransitioningDelegate
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }

}

class AlertPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
