//
//  CycleBannerView.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 22/05/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

@objc public protocol CycleBannerViewDelegate: UIScrollViewDelegate {

    @objc optional func cycleBannerView(_ cycleBannerView: CycleBannerView,
                                        didSelectItemAt index: Int)
    @objc optional func cycleBannerViewDidLayoutItems(_ cycleBannerView: CycleBannerView)
}

open class CycleBannerView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var delegate: CycleBannerViewDelegate?

    // never change the scrollView's delegate property
    private(set) var scrollView: UIScrollView!

    private(set) var pageControl: UIPageControl!
    var isHidePageControl: Bool = false {
        didSet {
            pageControl.isHidden = isHidePageControl
            if isHidePageControl {

                scrollView.frame = self.bounds
            } else {

                scrollView.frame = CGRect(x: 0,
                                          y: 0,
                                          width: self.frame.width,
                                          height: self.frame.height - 20)
            }
        }
    }

    // 所有已显示的item
    public var items: [CycleBannerViewItem] = [] {

        didSet {
            if items != oldValue {

                if currentIndex >= numberOfItems {
                    currentIndex = numberOfItems - 1
                }

                pageControl.numberOfPages = numberOfItems
                pageControl.currentPage = currentIndex

                _refreshItems_()
                setNeedsLayout()
            }
        }
    }

    // 默认item大小，开发者可以通过设置这个，来统一指定所有的item大小
    // 如果不设置，则值为scrollView.frame.size
    public var itemSize: CGSize = CGSize.zero

    // 统一的header或Footer 宽度
    public var itemHeaderWidth: CGFloat = 0
    public var itemFooterWidth: CGFloat = 0

    public var numberOfItems: Int {

        return items.count
    }

    // select index
    private(set) var currentIndex: Int = 0

    public func setCurrentIndex(_ index: Int, animated: Bool) {
        currentIndex = index
        pageControl.currentPage = currentIndex

        if self.window != nil {
            _scrollToCurrentIndexItem_(animated)
        }
    }

    // scroll items
    private func _scrollToCurrentIndexItem_(_ animated: Bool) {

        // 当前index 的item
        if let item = item(at: currentIndex) {

            let offsetX = item.center.x - scrollView.frame.width / 2.0
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        configureViews()
    }

    private func configureViews() {

        scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: self.frame.width,
                                                height: self.frame.height - 20))
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.delegate = self
        addSubview(scrollView)

        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: self.frame.height - 20,
                                                  width: self.frame.width,
                                                  height: 20))
        pageControl.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        pageControl.backgroundColor = UIColor.clear
        addSubview(pageControl)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if itemSize.equalTo(.zero) {
            itemSize = scrollView.frame.size
        }

        _reloadScrollViewContentSize_()
        _layoutItems_()

        DispatchQueue.main.async {

            self.delegate?.cycleBannerViewDidLayoutItems?(self)
            self._scrollToCurrentIndexItem_(false)
        }
    }

    private func _reloadScrollViewContentSize_() {

        if numberOfItems == 0 {
            scrollView.contentSize = .zero
        } else {
            let floatCount = CGFloat(numberOfItems)
            var contentWidth = (itemHeaderWidth + itemFooterWidth + itemSize.width) * floatCount;
            // 由于item需要居中显示，有可能item.width < scrollView.width，此时
            // 第一个item居中时，由于item宽度比scrollView宽度小，无法占满第一屏，左边可能有一段空白
            // 同理，最后面一个item居中显示时，右边可能多出一段空白
            // 左边多出来的空白
            contentWidth += (scrollView.frame.width / 2.0 - itemSize.width / 2.0 - itemHeaderWidth);
            // 右边多出来的空白
            contentWidth += (scrollView.frame.width / 2.0 - itemSize.width / 2.0 - itemFooterWidth);
            scrollView.contentSize = CGSize(width: contentWidth,
                                            height: scrollView.frame.height)
        }
    }

    private func _layoutItems_() {
        // 第一个item居于scrollView的中心位置
        var centerX: CGFloat = scrollView.frame.width / 2.0
        let centerY = scrollView.frame.height / 2.0
        for item in items {

            item.transform = .identity

            // 布局并添加item到scrollView中
            item.frame.size = itemSize
            item.center = CGPoint(x: centerX,
                                  y: centerY)

            // 计算下一个item的centerX
            centerX += itemFooterWidth
            centerX += itemHeaderWidth
            centerX += itemSize.width
        }
    }

    private func _refreshItems_() {

        // 移除之前的所有item
        for subview in scrollView.subviews {
            if subview is CycleBannerViewItem {
                subview.removeFromSuperview()
            }
        }

        for item in items {
            item.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            item.transform = .identity
            scrollView.addSubview(item)

            let tap = UITapGestureRecognizer(target: self, action: #selector(_itemTapped_(sender:)))
            item.addGestureRecognizer(tap)
        }
    }

    // get index or item
    public func index(of item: CycleBannerViewItem) -> Int? {

        return items.index(of: item)
    }

    public func item(at index: Int) -> CycleBannerViewItem? {

        if index < 0
            || index >= numberOfItems {

            return nil
        } else {

            return items[index]
        }
    }

    public func indexOfItem(at point: CGPoint) -> Int? {

        if point.x < 0
            || point.x > scrollView.contentSize.width
            || point.y < 0
            || point.y > scrollView.frame.height {

            return nil
        }

        // 第一个item的x
        let itemStartX = scrollView.frame.width / 2.0 - itemSize.width / 2.0 - itemHeaderWidth
        let itemScopeWidth = (itemHeaderWidth + itemSize.width + itemFooterWidth)
        let index = Int((point.x - itemStartX) / itemScopeWidth)
        if index > 0
            || index < numberOfItems {

            return index
        }
        return nil
    }

    // UIScrollViewDelegate
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)

        var currentIndex = 0
        if let itemIndex = indexOfItem(at: CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width / 2.0, y: 0)) {

            currentIndex = itemIndex
        } else if (scrollView.contentOffset.x < scrollView.frame.width) {

            currentIndex = 0
        } else {

            currentIndex = numberOfItems - 1
        }
        if (velocity.x > 0.5) {

            currentIndex += 1
        } else if (velocity.x < -0.5) {

            currentIndex -= 1
        }
        if currentIndex < 0 {
            currentIndex = 0
        } else if currentIndex >= numberOfItems {
            currentIndex = numberOfItems - 1
        }

        if let item = item(at: currentIndex) {

            self.currentIndex = currentIndex
            pageControl.currentPage = currentIndex
            targetContentOffset.pointee = CGPoint(x: item.center.x - scrollView.frame.width / 2.0,
                                                  y: 0)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        delegate?.scrollViewDidScroll?(scrollView)
    }

    // event
    @objc private func _itemTapped_(sender: UITapGestureRecognizer?) {

        if let item = sender?.view as? CycleBannerViewItem,
            let index = index(of: item) {

            delegate?.cycleBannerView?(self, didSelectItemAt: index)
        }
    }
}

extension CycleBannerView {

    // method forwarding
    override open func responds(to aSelector: Selector!) -> Bool {

        if let delegate = self.delegate {
            return (super.responds(to: aSelector) || delegate.responds(to: aSelector))
        }
        return super.responds(to: aSelector)
    }

    override open func forwardingTarget(for aSelector: Selector!) -> Any? {

        if let target = super.forwardingTarget(for: aSelector) {

            return target
        } else if delegate?.responds(to: aSelector) ?? false {

            return delegate
        } else {
            return nil
        }
    }
}
