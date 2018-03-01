//
//  SingleImageGalleryTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 28/02/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class SingleImageGalleryTestViewController: UIViewController {
    
    var singleImageGallery: SingleImageGalleryView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.white

        singleImageGallery = SingleImageGalleryView(image: UIImage(named: "logo5858")!,
                                                    frame: CGRect(x: 0, y: 10, width: 400, height: 700))
        singleImageGallery?.maximumZoomScale = 5.0
        singleImageGallery?.minimumZoomScale = 0.2
        self.view.addSubview(singleImageGallery!)
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
