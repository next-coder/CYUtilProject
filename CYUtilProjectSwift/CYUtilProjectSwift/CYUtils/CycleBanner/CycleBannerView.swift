//
//  CycleBannerView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc protocol CycleBannerViewDataSource {

    func numberOfItems(in cycleBannerView: CycleBannerView) -> UInt
    func cycleBannerView(cycleBannerView: CycleBannerView, itemAtIndex index: UInt) -> CycleBannerViewItem
}

@objc protocol CycleBannerViewDelegate: UIScrollViewDelegate {

    @objc optional func cycleBannerView(cycleBannerView: CycleBannerView, sizeForItemAtIndex index: UInt) -> CGSize
    @objc optional func cycleBannerView(cycleBannerView: CycleBannerView, widthForHeaderAtIndex index: UInt) -> CGFloat
    @objc optional func cycleBannerView(cycleBannerView: CycleBannerView, widthForFooterAtIndex index: UInt) -> CGFloat
    @objc optional func cycleBannerView(cycleBannerView: CycleBannerView,
                                        item: CycleBannerViewItem,
                                        willScrollToCenter distance: CGFloat,
                                        total totalDistance: CGFloat)
}

class CycleBannerView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var dataSource: CycleBannerViewDataSource?
    @IBOutlet weak var delegate: CycleBannerViewDelegate?

    // never change the scrollView's delegate property
    private(set) var scrollView: UIScrollView!

    // 默认item大小，开发者可以通过设置这个，来统一指定所有的item大小
    // 如果不设置，则值为scrollView.frame.size
    var itemSize: CGSize = CGSize.zero

    // 统一的header或Footer 宽度
    var itemHeaderWidth: CGFloat = 0
    var itemFooterWidth: CGFloat = 0

//    // 滑动翻页开关，根据每个item翻页
//    var itemPageEnabled: Bool = false
    // 最中间的item，是否屏幕居中显示
    var itemCenterEnabled: Bool = false
    // 循环滚动开关
    var cycleScrollEnabled: Bool = false

    private(set) var numberOfItems: UInt = 0
    // cached items, 还没有实现重用
//    private var _cachedItems_: [String: [CycleBannerViewItem]]!
    // 所有已显示的item
    private(set) var visibleItems: [CycleBannerViewItem]!

    private var _visibleItemStartIndex_: UInt = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        configureViews()
    }

    private func configureViews() {

//        _cachedItems_ = [String: [CycleBannerViewItem]]()
        visibleItems = [CycleBannerViewItem]()

        scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        // 如果默认ItemSize为scrollView.frame.size
        itemSize = scrollView.frame.size
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        reloadData()
    }

    func reloadData() {

        guard let dataSource = self.dataSource else {

            return
        }
        numberOfItems = dataSource.numberOfItems(in: self)
        _reloadScrollViewContentSize_()
        _reloadVisibleItems_()
        _alignCenterItem_(animated: false)
    }

    // items
    func index(forItem item: CycleBannerViewItem) -> Int? {

        if let index = visibleItems.index(of: item) {

            return index + Int(_visibleItemStartIndex_)
        } else {

            return nil
        }
    }

//    private func _index_(forItemAtPoint point: CGPoint) -> Int {
//
//        guard let dataSource = self.dataSource else {
//
//            return NSNotFound
//        }
//        
//    }

    // 重新设置scroll content size
    private func _reloadScrollViewContentSize_() {

        var contentSize = CGSize(width: 0, height: self.scrollView.frame.height)
        for i in 0..<numberOfItems {

            // item宽度
            contentSize.width += _itemSize_(atIndex: i).width
            // item header宽度
            contentSize.width += _itemHeaderWidth_(atIndex: i)
            // item footer 宽度
            contentSize.width += _itemFooterWidth_(atIndex: i)
        }
        scrollView.contentSize = contentSize

        if cycleScrollEnabled {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: scrollView.frame.width)
        }
    }

    // 重新刷新所有视图
    private func _reloadVisibleItems_() {

        // 删除之前的所有视图
        let subviews = scrollView.subviews
        if subviews.count > 0 {
            for view in subviews {

                view.removeFromSuperview()
            }
        }
        if visibleItems.count > 0 {

            visibleItems.removeAll()
        }

        guard let dataSource = self.dataSource else {

            return
        }

        var nextX: CGFloat = 0.0
        for i in 0..<numberOfItems {

            let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: i)
            item.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(item)
            visibleItems.append(item)

            // calculate frame
            nextX += _itemHeaderWidth_(atIndex: i)
            let itemSize = _itemSize_(atIndex: i)
            let itemY = (scrollView.frame.height - itemSize.height) / 2.0
            item.frame = CGRect(x: CGFloat(nextX), y: itemY, width: itemSize.width, height: itemSize.height)

            nextX = item.frame.maxX
            nextX += _itemFooterWidth_(atIndex: i)

//            // 如果item超过显示边界，则停止刷新
//            if item.frame.minX >= scrollView.frame.maxX {
//
//                break
//            }
        }

        if cycleScrollEnabled {

            for i in 0..<numberOfItems {

                let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: i)
                item.translatesAutoresizingMaskIntoConstraints = false
//                item.backgroundColor = UIColor.brown
                scrollView.addSubview(item)
                visibleItems.append(item)

                // calculate frame
                nextX += _itemHeaderWidth_(atIndex: i)
                let itemSize = _itemSize_(atIndex: i)
                let itemY = (scrollView.frame.height - itemSize.height) / 2.0
                item.frame = CGRect(x: CGFloat(nextX), y: itemY, width: itemSize.width, height: itemSize.height)

                nextX = item.frame.maxX
                nextX += _itemFooterWidth_(atIndex: i)
                if nextX > (scrollView.contentSize.width + scrollView.contentInset.right) {
                    break
                }
            }
        }

        _visibleItemStartIndex_ = 0
    }

    private func _itemSize_(atIndex index: UInt) -> CGSize {

        // 如果delegate实现了cycleBannerView(_:sizeForItemAtIndex:)，则调用此方法获取size
        // 否则，使用self.itemSize
        if let realSize = delegate?.cycleBannerView?(cycleBannerView: self, sizeForItemAtIndex: index) {

            return realSize
        } else {

            return itemSize
        }
    }

    private func _itemHeaderWidth_(atIndex index: UInt) -> CGFloat {

        if let headerWidth = delegate?.cycleBannerView?(cycleBannerView: self, widthForHeaderAtIndex: index) {

            return headerWidth
        } else {

            return itemHeaderWidth
        }
    }

    private func _itemFooterWidth_(atIndex index: UInt) -> CGFloat {

        if let footerWidth = delegate?.cycleBannerView?(cycleBannerView: self, widthForFooterAtIndex: index) {

            return footerWidth
        } else {

            return itemFooterWidth
        }
    }

    // UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if visibleItems.count <= 1 {

            return
        }

        let scrollViewOffset = scrollView.contentOffset
        // 不做懒加载，上来item全部加载
//        if scrollViewOffset.x < visibleItems[0].frame.maxX
//            && scrollViewOffset.x > 0 {
//
//            // 加载前面的
//            _addItemAtVisibleStart_()
//        } else if (scrollViewOffset.x + scrollView.frame.width) > visibleItems.last!.frame.minX {
//
//            _addItemAtVisibleEnd_()
//        }

        let scrollCenterX = scrollViewOffset.x + scrollView.frame.width / 2.0
        for item in visibleItems {

            if item.frame.maxX > scrollViewOffset.x
                && item.frame.minX < (scrollViewOffset.x + scrollView.frame.width) {

                delegate?.cycleBannerView?(cycleBannerView: self,
                                           item: item,
                                           willScrollToCenter: abs(scrollCenterX - item.center.x),
                                           total: (scrollView.frame.width + item.frame.width) / 2.0)
            }
        }

        if cycleScrollEnabled {
            if scrollViewOffset.x < 0 {

                // 滑到最左边
                scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width + scrollViewOffset.x, y: 0)
            } else if scrollViewOffset.x > scrollView.contentSize.width {
                // 滑到最右边
                scrollView.contentOffset = CGPoint(x: scrollViewOffset.x - scrollView.contentSize.width, y: 0)
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            _alignCenterItem_(animated: true)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _alignCenterItem_(animated: true)
    }

    private func _alignCenterItem_(animated: Bool) {

        if !itemCenterEnabled {

            return
        }

        let scrollViewOffset = scrollView.contentOffset
        let scrollViewCenterPoint = CGPoint(x: scrollViewOffset.x + scrollView.frame.width / 2.0, y: scrollView.frame.height / 2.0)
        for (index, item)  in visibleItems.enumerated() {

            let itemHeaderWidth = _itemHeaderWidth_(atIndex: (UInt(index) + _visibleItemStartIndex_))
            let itemFooterWidth = _itemFooterWidth_(atIndex: (UInt(index) + _visibleItemStartIndex_))
            // 在此item的范围内，则此item滑到屏幕中央
            if scrollViewCenterPoint.x < (item.center.x + item.bounds.width / 2.0 + itemFooterWidth)
                && scrollViewCenterPoint.x >= (item.center.x - item.bounds.width / 2.0 - itemHeaderWidth) {

                let scrollNewOffset = CGPoint(x: scrollViewOffset.x + (item.center.x - scrollViewCenterPoint.x), y: 0)
                scrollView.setContentOffset(scrollNewOffset, animated: animated)
                break
            }
        }
    }

    private func _addItemAtVisibleStart_() {

//        if _visibleItemStartIndex_ > 0 {
            guard let dataSource = self.dataSource else {

                return
            }

        var index: UInt = 0
        if _visibleItemStartIndex_ > 0 {
            index = _visibleItemStartIndex_ - 1
        } else {
            // 不支持循环滚动
            if !cycleScrollEnabled {
                return
            }
            index = numberOfItems - 1
        }
            let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: index)
            item.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(item)

            let nextItemHeaderWidth = _itemHeaderWidth_(atIndex: _visibleItemStartIndex_)
            let itemFooterWidth = _itemFooterWidth_(atIndex: index)
            let nextItemFrame = visibleItems[Int(_visibleItemStartIndex_)].frame

            let itemSize = _itemSize_(atIndex: index)
            let itemX = nextItemFrame.minX - nextItemHeaderWidth - itemFooterWidth - itemSize.width
            let itemY = (scrollView.frame.height - itemSize.height) / 2.0
            item.frame = CGRect(x: itemX,
                                y: itemY,
                                width: itemSize.width,
                                height: itemSize.height)

            visibleItems.insert(item, at: 0)
            _visibleItemStartIndex_ = index
//        }
    }

    private func _addItemAtVisibleEnd_() {

        var index = _visibleItemStartIndex_ + UInt(visibleItems.count)
        if index >= numberOfItems {
            // 不支持循环滚动
            if !cycleScrollEnabled {
                return
            }
            index -= numberOfItems
        }

        var previousIndex: UInt = 0
        if index == 0 {
            previousIndex = numberOfItems - 1
        } else {
            previousIndex = index - 1
        }

//        if index < numberOfItems {
            guard let dataSource = self.dataSource else {

                return
            }

            let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: index)
            item.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(item)

            let previousItemFooterWidth = _itemFooterWidth_(atIndex: previousIndex)
            let previousItemFrame = visibleItems[Int(previousIndex)].frame
            let itemHeaderWidth = _itemHeaderWidth_(atIndex: index)

            let itemSize = _itemSize_(atIndex: index)
            let itemX = previousItemFrame.maxX + previousItemFooterWidth + itemHeaderWidth
            let itemY = (scrollView.frame.height - itemSize.height) / 2.0
            item.frame = CGRect(x: itemX,
                                y: itemY,
                                width: itemSize.width,
                                height: itemSize.height)

            visibleItems.append(item)
//        }
    }

    private func _removeUnVisibleItemIfNeeded_() {

        // TODO 删除不在显示的item
    }

//    private func _refreshItem_(atIndex index: UInt) {
//        guard let dataSource = self.dataSource else {
//            return
//        }
//        if index >= numberOfItems {
//
//            return
//        }
//        if index >= _visibleItemStartIndex_
//            && index < UInt(visibleItems.count) {
//
//            let itemIndexInVisible: Int = Int(index - _visibleItemStartIndex_)
//            visibleItems[Int(itemIndexInVisible)].removeFromSuperview()
//
//            let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: index)
//            scrollView.addSubview(item)
//
//
//
//            visibleItems[itemIndexInVisible]
//        } else if index == (_visibleItemStartIndex_ - 1) {
//
//            // 屏幕第一个之前的item
//            let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: index)
//
//        } else if index == (_visibleItemStartIndex_ + UInt(visibleItems.count)) {
//
//            // 屏幕的最后一个之后的item
//            let item = dataSource.cycleBannerView(cycleBannerView: self, itemAtIndex: index)
//
//        } else {
//
//            // 不在屏幕内的item, 不刷新
//        }
//    }
//
//    private func _removeItem_(atIndex index: UInt) {
//
//        if index >= _visibleItemStartIndex_
//            && index < UInt(visibleItems.count) {
//
//
//        }
//    }
}
