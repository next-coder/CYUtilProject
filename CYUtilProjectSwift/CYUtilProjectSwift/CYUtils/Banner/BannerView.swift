//
//  BannerView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 22/05/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc public protocol BannerViewDelegate: UIScrollViewDelegate {
    
    @objc optional func bannerView(_ bannerView: BannerView,
                                        didSelectItemAt index: Int)
    @objc optional func bannerViewDidLayoutItems(_ bannerView: BannerView)
}

open class BannerView: UIView, UIScrollViewDelegate {
    
    @IBOutlet weak var delegate: BannerViewDelegate?
    
    // never change the scrollView's delegate property
    private(set) var scrollView: UIScrollView!
    
    private(set) var pageControl: UIPageControl!
    
    // 所有已显示的item
    public var items: [BannerViewItem] = [] {
        
        didSet {
            if items != oldValue {
                
                if currentIndex >= numberOfItems {
                    currentIndex = numberOfItems - 1
                }
                
                pageControl.numberOfPages = numberOfItems
                pageControl.currentPage = currentIndex
                
                _refreshItems_()
                setNeedsLayout()
                
                if autoplayDuration > 0 {
                    startAutoplay()
                }
            }
        }
    }
    
    // items count
    public var numberOfItems: Int {
        
        return items.count
    }
    
    // 默认item大小，开发者可以通过设置这个，来统一指定所有的item大小
    // 如果不设置，则值为scrollView.frame.size
    public var itemSize: CGSize = CGSize.zero
    
    // 统一的header或Footer 宽度
    public var itemHeaderWidth: CGFloat = 0
    public var itemFooterWidth: CGFloat = 0
    
    // 自动滚动，小于0表示不自动滚动，否则每次按时间滚动一页，默认为0
    public var autoplayDuration: Double = 0
    
    // 是否循环滚动, 默认false
    public var cycleScrolling: Bool = false
    
    // select index
    fileprivate(set) var currentIndex: Int = 0
    
    public func setCurrentIndex(_ index: Int, animated: Bool) {
        if index < 0
            || index >= numberOfItems
            || index == currentIndex {
            return
        }
        
        currentIndex = index
        pageControl.currentPage = currentIndex
        _scrollToCurrentIndexItem_(animated)
    }
    
    // scroll items
    private func _scrollToCurrentIndexItem_(_ animated: Bool) {
        
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
                                                height: self.frame.height))
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
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if itemSize.equalTo(.zero) {
            itemSize = scrollView.frame.size
        }
        if itemSize.width == scrollView.frame.width {
            scrollView.isPagingEnabled = true
        }
        
        _reloadScrollViewContentSize_()
        _layoutItems_()
        
        DispatchQueue.main.async {
            
            self.delegate?.bannerViewDidLayoutItems?(self)
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
            if subview is BannerViewItem {
                subview.removeFromSuperview()
            }
        }
        
        if numberOfItems == 0 {
            return
        }
        
        for item in items {
            item.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            scrollView.addSubview(item)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(_itemTapped_(sender:)))
            item.addGestureRecognizer(tap)
        }
    }
    
    // get index or item
    public func index(of item: BannerViewItem) -> Int? {
        
        return items.index(of: item)
    }
    
    public func item(at index: Int) -> BannerViewItem? {
        
        if index < 0
            || index >= numberOfItems {
            
            return nil
        } else {
            
            return items[index]
        }
    }
    
    public func indexOfItem(at point: CGPoint) -> Int? {
        
        for (index, item) in items.enumerated() {
            if point.x < item.frame.maxX + itemFooterWidth
                && point.x > item.frame.minX - itemHeaderWidth {
                return index
            }
        }
        return nil
    }
    
    // UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoplay()
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var currentIndex = self.currentIndex
        if let itemIndex = indexOfItem(at: CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width / 2.0, y: 0)) {
            
            currentIndex = itemIndex
        }
        if currentIndex == self.currentIndex {
            
            if velocity.x > 0.5 {
                
                currentIndex += 1
            } else if velocity.x < -0.5 {
                
                currentIndex -= 1
            }
        }
        
        if let item = item(at: currentIndex) {
            
            self.currentIndex = currentIndex
            pageControl.currentPage = currentIndex
            targetContentOffset.pointee = CGPoint(x: item.center.x - scrollView.frame.width / 2.0,
                                                  y: 0)
        }
        
        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startAutoplay()
        }
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startAutoplay()
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        refreshCycleScrollingIfNeeded()
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    //    // MARK: UIGestureRecognizerDelegate
    //    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return true
    //    }
    
    // event
    @objc private func _itemTapped_(sender: UITapGestureRecognizer?) {
        
        if let item = sender?.view as? BannerViewItem,
            let index = index(of: item) {
            
            delegate?.bannerView?(self, didSelectItemAt: index)
        }
    }
}

// MARK: autoplay
extension BannerView {
    // 开始
    fileprivate func startAutoplay() {
        // 开始之前，先停止之前的操作
        stopAutoplay()
        // 时间小于0，不自动滚动
        if autoplayDuration <= 0
            || numberOfItems == 0 {
            return
        }
        perform(#selector(autoplayBanner),
                with: nil,
                afterDelay: autoplayDuration)
    }
    
    fileprivate func stopAutoplay() {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(autoplayBanner),
                                               object: nil)
    }
    
    public func pauseAutoplay() {
        stopAutoplay()
    }
    
    public func resumeAutoplay() {
        startAutoplay()
    }
    
    @objc fileprivate func autoplayBanner() {
        var nextItemIndex = currentIndex + 1
        if cycleScrolling
            && nextItemIndex >= numberOfItems {
            nextItemIndex = 0
        }
        setCurrentIndex(nextItemIndex, animated: true)
        startAutoplay()
    }
}

// MARK: Cycle scroll 循环滚动
extension BannerView {
    fileprivate func refreshCycleScrollingIfNeeded() {
        if cycleScrolling
            && numberOfItems >= 2{
            
            scrollView.contentInset = UIEdgeInsets(top: 0,
                                                   left: itemHeaderWidth + itemFooterWidth + itemSize.width,
                                                   bottom: 0,
                                                   right: itemHeaderWidth + itemFooterWidth + itemSize.width)
            
            let contentMinX = (scrollView.frame.width - itemSize.width) / 2.0 - itemHeaderWidth
            let contentMaxX = scrollView.contentSize.width - (scrollView.frame.width - itemSize.width) / 2.0 + itemFooterWidth
            if scrollView.contentOffset.x <= contentMinX {
                // 滑到了最左边，把最右边的item挪到最左边
                items[0].center.x = scrollView.frame.width / 2.0
                items[numberOfItems - 1].center.x = contentMinX - itemFooterWidth - itemSize.width / 2.0
            } else if scrollView.contentOffset.x >= contentMaxX - scrollView.frame.width {
                // 滑到最右边，把最左边的item挪到最右边
                items[numberOfItems - 1].center.x = scrollView.contentSize.width - scrollView.frame.width / 2.0
                items[0].center.x = contentMaxX + itemHeaderWidth + itemSize.width / 2.0
            } else {
                items[0].center.x = scrollView.frame.width / 2.0
                items[numberOfItems - 1].center.x = scrollView.contentSize.width - scrollView.frame.width / 2.0
            }
            
            if scrollView.contentOffset.x <= -itemSize.width - itemHeaderWidth - itemFooterWidth {
                // 循环滚动的时候，滑到最左边item，此时最左边item.index=numberOfItems-1，则跳回到numberOfItems-1本来的位置
                scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.width, y: 0), animated: false)
                currentIndex = numberOfItems - 1
                pageControl.currentPage = currentIndex
            } else if scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.width + itemSize.width + itemFooterWidth + itemHeaderWidth {
                // 循环滚动的时候，滑到最右边item，此时最右边Item.index=0，则调回开头
                scrollView.setContentOffset(.zero, animated: false)
                currentIndex = 0
                pageControl.currentPage = currentIndex
            }
        }
    }
}

extension BannerView {
    
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


