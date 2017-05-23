//
//  CycleBannerTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class CycleBannerTestViewController: UIViewController, CycleBannerViewDataSource, CycleBannerViewDelegate {

    var cycleBannerView: CycleBannerView!

    override func loadView() {
        super.loadView()

        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = UIColor.white

        cycleBannerView = CycleBannerView(frame: CGRect(x: 30, y: 100, width: 300, height: 200))
        cycleBannerView.dataSource = self
        cycleBannerView.delegate = self
        cycleBannerView.itemSize = CGSize(width: 150, height: 120)
        cycleBannerView.itemHeaderWidth = 10
        cycleBannerView.itemFooterWidth = 10
        cycleBannerView.itemCenterEnabled = true
        cycleBannerView.cycleScrollEnabled = true
        cycleBannerView.scrollView.backgroundColor = UIColor.gray
        self.view.addSubview(cycleBannerView)

        let view = UIView(frame: CGRect(x: 170, y: 310, width: 20, height: 20))
        view.backgroundColor = UIColor.green
        self.view.addSubview(view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // CycleBannerViewDataSource
    func numberOfItems(in cycleBannerView: CycleBannerView) -> UInt {

        return 3
    }

    func cycleBannerView(cycleBannerView: CycleBannerView, itemAtIndex index: UInt) -> CycleBannerViewItem {

        let item = CycleBannerViewItem(reuseIdentifier: "lllllll")
        if index == 0 {

            item.backgroundColor = UIColor.red
        } else if index == 1 {

            item.backgroundColor = UIColor.blue
        } else if index == 2 {

            item.backgroundColor = UIColor.green
        } else if index == 3 {

            item.backgroundColor = UIColor.brown
        } else if index == 4 {

            item.backgroundColor = UIColor.cyan
        }
        return item
    }

//    func cycleBannerView(cycleBannerView: CycleBannerView, sizeForItemAtIndex index: UInt) -> CGSize {
//
//        let random = abs(sin(Double(index))) + 0.2
//        return CGSize(width: 150 * random , height: 150 * random)
//    }

    func cycleBannerView(cycleBannerView: CycleBannerView,
                         item: CycleBannerViewItem,
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

}
