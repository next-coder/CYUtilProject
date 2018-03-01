//
//  QRCodeTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 19/12/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class QRCodeTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        let qrcode = QRCodeGenerator
                        .generate(string: "http://www.qguanzi.com")?
                        .scaled(to: CGSize(width: 250, height: 250))
                        .uiImage
                        .adding(by: UIImage(named: "logo5858")!)
        
        let imageView = UIImageView(frame: CGRect(x: 30, y: 150, width: 250, height: 250))
        imageView.image = qrcode
        self.view.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "red")?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)), for: .default)
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
