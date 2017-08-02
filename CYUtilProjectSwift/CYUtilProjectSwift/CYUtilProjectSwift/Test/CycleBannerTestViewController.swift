//
//  CycleBannerTestViewController.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 22/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
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

        cycleBannerView = CycleBannerView(frame: self.view.bounds)
        cycleBannerView.delegate = self
        cycleBannerView.itemSize = CGSize(width: 300, height: 180)
        cycleBannerView.itemHeaderWidth = 0
        cycleBannerView.itemFooterWidth = 0
        cycleBannerView.scrollView.backgroundColor = UIColor.gray
        cycleBannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cycleBannerView)

        let bannerTop = NSLayoutConstraint(item: cycleBannerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
        let bannerLeft = NSLayoutConstraint(item: cycleBannerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 30)
        let bannerHeight = NSLayoutConstraint(item: cycleBannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        let bannerRight = NSLayoutConstraint(item: cycleBannerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -30)
        self.view.addConstraints([bannerTop, bannerLeft, bannerHeight, bannerRight])

        button1Tapped()
        cycleBannerView.setCurrentIndex(1, animated: false)

        let view = UIView(frame: CGRect(x: 170, y: 310, width: 20, height: 20))
        view.backgroundColor = UIColor.green
        self.view.addSubview(view)

        let button = UIButton(frame: CGRect(x: 300, y: 500, width: 80, height: 50))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(button)

        let button1 = UIButton(frame: CGRect(x: 300, y: 560, width: 80, height: 50))
        button1.backgroundColor = UIColor.blue
        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        self.view.addSubview(button1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func cycleBannerView(_ cycleBannerView: CycleBannerView, didSelectItemAt index: Int) {

        print("tap item at = %d", index)
    }

    func cycleBannerViewDidLayoutItems(_ cycleBannerView: CycleBannerView) {

        let scrollView = cycleBannerView.scrollView!
        let contentOffset = scrollView.contentOffset
        let contentCenterX = scrollView.frame.width / 2.0 + contentOffset.x
        let totalWidth = scrollView.contentSize.width > 0 ? scrollView.contentSize.width : scrollView.frame.width
        for item in cycleBannerView.items {
            let scale = 1 - abs(contentCenterX - item.center.x) * 1.5 / totalWidth
            item.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentOffset = scrollView.contentOffset
        let contentCenterX = scrollView.frame.width / 2.0 + contentOffset.x
        let totalWidth = scrollView.contentSize.width > 0 ? scrollView.contentSize.width : scrollView.frame.width
        for item in cycleBannerView.items {
            let scale = 1 - abs(contentCenterX - item.center.x) * 1.5 / totalWidth
            item.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    func buttonTapped() {
        var index = cycleBannerView.currentIndex + 2
        if index > cycleBannerView.numberOfItems {

            index = 0
        }
        cycleBannerView.setCurrentIndex(index, animated: true)
    }

    func button1Tapped() {


        let item1 = CycleBannerViewItem(frame: self.view.bounds)
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
}
