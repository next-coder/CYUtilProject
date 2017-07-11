//
//  CycleBannerTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

public protocol TextProtocol {

    func testSomething()
}

class CycleBannerTestViewController: UIViewController, CycleBannerViewDelegate, TextProtocol {


    func testSomething() {

    }


    var cycleBannerView: CycleBannerView!

    override func loadView() {
        super.loadView()

        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = UIColor.white

        cycleBannerView = CycleBannerView(frame: .zero)
        cycleBannerView.delegate = self
        cycleBannerView.itemSize = CGSize(width: 300, height: 180)
        cycleBannerView.itemHeaderWidth = 10
        cycleBannerView.itemFooterWidth = 10
        cycleBannerView.scrollView.backgroundColor = UIColor.gray
        cycleBannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cycleBannerView)

        let bannerTop = NSLayoutConstraint(item: cycleBannerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
        let bannerLeft = NSLayoutConstraint(item: cycleBannerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 30)
        let bannerHeight = NSLayoutConstraint(item: cycleBannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        let bannerRight = NSLayoutConstraint(item: cycleBannerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -30)
        self.view.addConstraints([bannerTop, bannerLeft, bannerHeight, bannerRight])

        let view = UIView(frame: CGRect(x: 170, y: 310, width: 20, height: 20))
        view.backgroundColor = UIColor.green
        self.view.addSubview(view)

        let item1 = CycleBannerViewItem()
        item1.contentView.backgroundColor = UIColor.green
        let item2 = CycleBannerViewItem()
        item2.contentView.backgroundColor = UIColor.blue
        let item3 = CycleBannerViewItem()
        item3.contentView.backgroundColor = UIColor.black
        let item4 = CycleBannerViewItem()
        item4.contentView.backgroundColor = UIColor.white
        let item5 = CycleBannerViewItem()
        item5.contentView.backgroundColor = UIColor.blue
        let item6 = CycleBannerViewItem()
        item6.contentView.backgroundColor = UIColor.blue
        let item7 = CycleBannerViewItem()
        item7.contentView.backgroundColor = UIColor.blue
        let item8 = CycleBannerViewItem()
        item8.contentView.backgroundColor = UIColor.green
        let item9 = CycleBannerViewItem()
        item9.contentView.backgroundColor = UIColor.green
        let item10 = CycleBannerViewItem()
        item10.contentView.backgroundColor = UIColor.green
        let item11 = CycleBannerViewItem()
        item11.contentView.backgroundColor = UIColor.blue
        let item12 = CycleBannerViewItem()
        item12.contentView.backgroundColor = UIColor.green
        let item13 = CycleBannerViewItem()
        item13.contentView.backgroundColor = UIColor.green
        let item14 = CycleBannerViewItem()
        item14.contentView.backgroundColor = UIColor.blue
        let item15 = CycleBannerViewItem()
        item15.contentView.backgroundColor = UIColor.green
        let item16 = CycleBannerViewItem()
        item16.contentView.backgroundColor = UIColor.blue
        let item17 = CycleBannerViewItem()
        item17.contentView.backgroundColor = UIColor.green
        let item18 = CycleBannerViewItem()
        item18.contentView.backgroundColor = UIColor.blue
        let item19 = CycleBannerViewItem()
        item19.contentView.backgroundColor = UIColor.green
        let item20 = CycleBannerViewItem()
        item20.contentView.backgroundColor = UIColor.green

        cycleBannerView.items = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19, item20]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func cycleBannerView(_ cycleBannerView: CycleBannerView, didSelectItemAt index: Int) {

        print("tap item at = %d", index)
    }

}
