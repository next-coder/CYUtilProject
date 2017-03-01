//
//  ProgressWebTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 03/01/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class ProgressWebTestViewController: UIViewController {

    var progressWebView: CYProgressWebView?

    override func loadView() {
        super.loadView()

        progressWebView = CYProgressWebView(frame: self.view.bounds)
        self.view = progressWebView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = progressWebView?.load(urlString: "https://www.xiaoniuapp.com")
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

}
