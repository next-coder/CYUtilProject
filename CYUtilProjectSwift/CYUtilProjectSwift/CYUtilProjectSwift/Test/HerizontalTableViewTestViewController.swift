//
//  HerizontalTableViewTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 20/06/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class HerizontalTableViewTestViewController: UIViewController, HerizontalTableViewDataSource, HerizontalTableViewDelegate {

    var herizontalTableView: HerizontalTableView!

    override func loadView() {
        super.loadView()

        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = UIColor.white

        // CGRect(x: 30, y: 100, width: 300, height: 200)
        herizontalTableView = HerizontalTableView(frame: .zero)
        herizontalTableView.dataSource = self
        herizontalTableView.delegate = self
        herizontalTableView.itemSize = CGSize(width: 150, height: 120)
        herizontalTableView.itemHeaderWidth = 10
        herizontalTableView.itemFooterWidth = 10
        //        herizontalTableView.itemCenterEnabled = true
        //        herizontalTableView.cycleScrollEnabled = true
        herizontalTableView.scrollView.backgroundColor = UIColor.gray
        herizontalTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(herizontalTableView)

        let bannerTop = NSLayoutConstraint(item: herizontalTableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
        let bannerLeft = NSLayoutConstraint(item: herizontalTableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 30)
        let bannerHeight = NSLayoutConstraint(item: herizontalTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        let bannerRight = NSLayoutConstraint(item: herizontalTableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -30)
        self.view.addConstraints([bannerTop, bannerLeft, bannerHeight, bannerRight])

        let view = UIView(frame: CGRect(x: 170, y: 310, width: 20, height: 20))
        view.backgroundColor = UIColor.green
        self.view.addSubview(view)
    }

    // MARK: HerizontalTableViewDataSource
    func numberOfItems(in herizontalTableView: HerizontalTableView) -> Int {

        return 20
    }

    func herizontalTableView(_ herizontalTableView: HerizontalTableView, itemAt index: Int) -> HerizontalTableViewItem {

        var item = herizontalTableView.dequeueReusableItem("lllllll")
        if item == nil {
            item = HerizontalTableViewItem(reuseIdentifier: "lllllll")
        }
        if index == 0 {

            item?.backgroundColor = UIColor.red
        } else if index == 1 {

            item?.backgroundColor = UIColor.blue
        } else if index == 2 {

            item?.backgroundColor = UIColor.green
        } else if index == 3 {

            item?.backgroundColor = UIColor.brown
        } else if index == 4 {

            item?.backgroundColor = UIColor.cyan
        } else if index % 2 == 0 {

            item?.backgroundColor = UIColor.black
        } else {
            item?.backgroundColor = UIColor.orange
        }
        if let label = item?.viewWithTag(10) as? UILabel {

            label.text = "\(index)"
            label.sizeToFit()
        } else {
            let label = UILabel()
            label.tag = 10
            label.backgroundColor = UIColor.white
            label.text = "\(index)"
            label.sizeToFit()
            item?.addSubview(label)
        }
        return item!
    }

    func herizontalTableView(herizontalTableView: HerizontalTableView,
                         item: HerizontalTableViewItem,
                         willScrollToCenter distance: CGFloat,
                         total totalDistance: CGFloat) {
        if totalDistance <= 0
        {
            return
        }
        let progress = distance / totalDistance
        let scale = (1 - progress) * 0.2 + 0.8
        item.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    func herizontalTableView(_ herizontalTableView: HerizontalTableView, didSelectItemAt index: Int) {
        
        print("tap item at = %d", index)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
    }

}
