//
//  HerizontalTableView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 12/06/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc public protocol HerizontalTableViewDataSource: NSObjectProtocol {

    func numberOfItems(in herizontalTableView: HerizontalTableView) -> Int
    func herizontalTableView(_ herizontalTableView: HerizontalTableView, itemAt index: Int) -> HerizontalTableViewItem
}

@objc public protocol HerizontalTableViewDelegate: NSObjectProtocol, UIScrollViewDelegate {

    @objc optional func herizontalTableView(_ herizontalTableView: HerizontalTableView,
                                        didSelectItemAt index: Int)
    @objc optional func herizontalTableView(_ herizontalTableView: HerizontalTableView,
                                        sizeForItemAt index: Int) -> CGSize
    @objc optional func herizontalTableView(_ herizontalTableView: HerizontalTableView,
                                        widthForHeaderAt index: Int) -> CGFloat
    @objc optional func herizontalTableView(_ herizontalTableView: HerizontalTableView,
                                        widthForFooterAt index: Int) -> CGFloat
}

public class HerizontalTableView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var dataSource: HerizontalTableViewDataSource?
    @IBOutlet weak var delegate: HerizontalTableViewDelegate?

    // never change the scrollView's delegate property
    private(set) var scrollView: UIScrollView!

    // 默认item大小，开发者可以通过设置这个，来统一指定所有的item大小
    // 如果不设置，则值为scrollView.frame.size
    public var itemSize: CGSize = CGSize.zero

    // 统一的header或Footer 宽度
    public var itemHeaderWidth: CGFloat = 0
    public var itemFooterWidth: CGFloat = 0

    private(set) open var numberOfItems: Int = 0
    // cached items, 还没有实现重用
    private var _cachedItems_: [String: [HerizontalTableViewItem]]!
    // 所有已显示的item
    private(set) open var visibleItems: [HerizontalTableViewItem]!

    // 已显示visibleItems[0]的真正index，在所有item中的Index
    private var _visibleItemStartIndex_: Int = 0

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

        _cachedItems_ = [String: [HerizontalTableViewItem]]()
        visibleItems = [HerizontalTableViewItem]()

        scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        //        // 如果默认ItemSize为scrollView.frame.size
        //        itemSize = scrollView.frame.size
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame = self.bounds
        if itemSize.equalTo(.zero) {
            itemSize = scrollView.frame.size
        }
        reloadData()
    }

    public func reloadData() {

        guard let dataSource = self.dataSource else {

            return
        }
        numberOfItems = dataSource.numberOfItems(in: self)
        _reloadScrollViewContentSize_()
        _reloadVisibleItems_()
    }

    // item index
    public func index(of item: HerizontalTableViewItem) -> Int? {

        if let index = visibleItems.index(of: item) {

            let realIndex = index + _visibleItemStartIndex_
            if realIndex >= numberOfItems {

                return realIndex - numberOfItems
            } else {

                return realIndex
            }
        } else {

            return nil
        }
    }

    public func indexOfItem(at point: CGPoint) -> Int? {

        var x: CGFloat = 0.0
        for i in 0..<numberOfItems {

            let itemHeaderWidth = _itemHeaderWidth_(i)
            let itemFooterWidth = _itemFooterWidth_(i)
            let itemSize = _itemSize_(i)
            let itemRect = CGRect(x: x,
                                  y: 0,
                                  width: itemSize.width + itemFooterWidth + itemHeaderWidth,
                                  height: scrollView.frame.height)
            if itemRect.contains(point) {

                return i
            }

            x = itemRect.maxX
        }
        return nil
    }

    public func dequeueReusableItem(_ reuseIdentifier: String) -> HerizontalTableViewItem? {

        if var itemList = _cachedItems_[reuseIdentifier],
            itemList.count > 0 {
            let item = itemList.removeFirst()
            _cachedItems_[reuseIdentifier] = itemList
            return item
        }
        return nil
    }

    private func _setItemsReuse_(_ items: [HerizontalTableViewItem]) {

        for item in items {

            _setItemReuse_(item)
        }
    }

    private func _setItemReuse_(_ item: HerizontalTableViewItem) {

        if let reuseIdentifier = item.reuseIdentifier {

            var reuseList = _cachedItems_[reuseIdentifier]
            if reuseList == nil {
                reuseList = [HerizontalTableViewItem]()
            }
            reuseList?.append(item)
            _cachedItems_[reuseIdentifier] = reuseList
        }
    }

    // 重新设置scroll content size
    private func _reloadScrollViewContentSize_() {

        var contentSize = CGSize(width: 0, height: self.scrollView.frame.height)
        for i in 0..<numberOfItems {

            // item宽度
            contentSize.width += _itemSize_(i).width
            // item header宽度
            contentSize.width += _itemHeaderWidth_(i)
            // item footer 宽度
            contentSize.width += _itemFooterWidth_(i)
        }
        scrollView.contentSize = contentSize
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

            _setItemsReuse_(visibleItems)
            visibleItems.removeAll()
        }

        guard let dataSource = self.dataSource else {

            return
        }

        guard let currentItemIndex = indexOfItem(at: scrollView.contentOffset) else {

            return
        }
        var previousItem: HerizontalTableViewItem? = nil
        for i in currentItemIndex..<numberOfItems {

            // get item
            let item = dataSource.herizontalTableView(self, itemAt: i)
            item.translatesAutoresizingMaskIntoConstraints = false
            // add item to scroll
            scrollView.addSubview(item)
            visibleItems.append(item)

            // add tap for item
            let tap = UITapGestureRecognizer(target: self, action: #selector(_itemTapped_(sender:)))
            item.addGestureRecognizer(tap)

            if let previous = previousItem {

                _layout_(item, previousItem: previous)
            } else {

                _layout_(item)
            }

            previousItem = item

            // 如果item超过显示边界，则停止刷新
            if !_itemVisible_(item) {

                break
            }
        }
    }

    private func _layout_(_ item: HerizontalTableViewItem) {
        assert(item.superview != nil && item.superview == scrollView, "Item must be in the cycle banner")
        guard let index = index(of: item) else {

            print("Item is not visible")
            return
        }

        var itemX: CGFloat = 0.0
        for i in 0..<index {

            itemX += _itemHeaderWidth_(i)
            itemX += _itemSize_(i).width
            itemX += _itemFooterWidth_(i)
        }

        itemX += _itemHeaderWidth_(index)
        let itemY = (scrollView.frame.height - itemSize.height) / 2.0
        item.frame.origin = CGPoint(x: itemX, y: itemY)
        item.frame.size = _itemSize_(index)
    }

    // layout item with its previous item
    private func _layout_(_ item: HerizontalTableViewItem, previousItem: HerizontalTableViewItem) {

        assert(previousItem.superview != nil && previousItem.superview == scrollView, "Previous item must be in the cycle banner")
        assert(item.superview != nil && item.superview == scrollView, "Item must be in the cycle banner")
        guard let itemIndex = index(of: item) else {

            print("Item is not visible")
            return
        }
        guard let previousIndex = index(of: previousItem) else {
            print("Previous is not visible")
            return
        }

        // update item size
        item.frame.size = _itemSize_(itemIndex)

        // item x is the min x of next item (to), minus next item header, minus item footer, minus item width / 2.0
        let itemX = previousItem.frame.maxX + _itemFooterWidth_(previousIndex) + _itemHeaderWidth_(itemIndex) + item.frame.width / 2.0
        item.center = CGPoint(x: itemX,
                              y: scrollView.frame.height / 2.0)

    }

    // layout item with its next item
    private func _layout_(_ item: HerizontalTableViewItem, nextItem: HerizontalTableViewItem) {

        assert(item.superview != nil && item.superview == scrollView, "Item must be in the cycle banner")
        assert(nextItem.superview != nil && nextItem.superview == scrollView, "Next item must be in the cycle banner")
        guard let itemIndex = index(of: item) else {

            print("Item is not visible")
            return
        }
        guard let nextIndex = index(of: nextItem) else {
            print("Previous is not visible")
            return
        }

        // update item size
        item.frame.size = _itemSize_(itemIndex)

        // item x is the min x of next item (to), minus next item header, minus item footer, minus item width / 2.0
        let itemCenterX = nextItem.frame.minX - _itemHeaderWidth_(nextIndex) - _itemFooterWidth_(itemIndex) - item.frame.width / 2.0
        item.center = CGPoint(x: itemCenterX,
                              y: scrollView.frame.height / 2.0)
    }

    private func _itemVisible_(_ item: HerizontalTableViewItem) -> Bool {

        if let index = index(of: item) {

            if (item.frame.minX - _itemHeaderWidth_(index) < scrollView.contentOffset.x + scrollView.frame.width)
                && (item.frame.maxX + _itemFooterWidth_(index) > scrollView.contentOffset.x) {

                return true
            }
        }
        return false
    }

    private func _itemSize_(_ index: Int) -> CGSize {

        // 如果delegate实现了herizontalTableView(_:sizeForItemAtIndex:)，则调用此方法获取size
        // 否则，使用self.itemSize
        if let realSize = delegate?.herizontalTableView?(self, sizeForItemAt: index) {

            return realSize
        } else {

            return itemSize
        }
    }

    private func _itemHeaderWidth_(_ index: Int) -> CGFloat {

        if let headerWidth = delegate?.herizontalTableView?(self, widthForHeaderAt: index) {

            return headerWidth
        } else {

            return itemHeaderWidth
        }
    }

    private func _itemFooterWidth_(_ index: Int) -> CGFloat {
        if let footerWidth = delegate?.herizontalTableView?(self, widthForFooterAt: index) {

            return footerWidth
        } else {

            return itemFooterWidth
        }
    }

    // UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if visibleItems.count <= 1 {

            return
        }

        let scrollViewOffset = scrollView.contentOffset
        // 懒加载
        if scrollViewOffset.x < visibleItems[0].frame.maxX
            && scrollViewOffset.x > 0 {

            // 加载前面的
            _addItemAtVisibleStart_()
        } else if (scrollViewOffset.x + scrollView.frame.width) > visibleItems.last!.frame.minX {

            _addItemAtVisibleEnd_()
        }
    }

    private func _addItemAtVisibleStart_() {

        if _visibleItemStartIndex_ == 0 {

            return;
        }
        guard let dataSource = self.dataSource else {

            return
        }

        let index: Int = _visibleItemStartIndex_ - 1
        let item = dataSource.herizontalTableView(self, itemAt: index)
        item.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(item)
        visibleItems.insert(item, at: 0)
        _visibleItemStartIndex_ = index

        _layout_(item, nextItem: visibleItems[1])
        _removeVisibleItemAtEnd_()
    }

    private func _removeVisibleItemAtEnd_() {

        var removeCount = 0
        for item in visibleItems.reversed() {

            if !_itemVisible_(item) {

                item.removeFromSuperview()
                _setItemReuse_(item)
                removeCount += 1
            } else {

                break
            }
        }

        visibleItems.removeLast(removeCount)
    }

    private func _addItemAtVisibleEnd_() {

        let index = _visibleItemStartIndex_ + visibleItems.count
        if index >= numberOfItems {

            return;
        }
        guard let dataSource = self.dataSource else {

            return
        }

        let item = dataSource.herizontalTableView(self, itemAt: index)
        item.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(item)
        visibleItems.append(item)

        _layout_(item, previousItem: visibleItems[index - 1 - _visibleItemStartIndex_])
        _removeVisibleItemFromStart_()
    }

    private func _removeVisibleItemFromStart_() {
        
        var removeCount = 0
        for item in visibleItems {
            
            if !_itemVisible_(item) {
                
                item.removeFromSuperview()
                _setItemReuse_(item)
                removeCount += 1
            } else {
                
                break
            }
        }
        
        visibleItems.removeFirst(removeCount)
        _visibleItemStartIndex_ += removeCount
    }
    
    // event
    @objc private func _itemTapped_(sender: UITapGestureRecognizer?) {
        
        if let item = sender?.view as? HerizontalTableViewItem {
            
            if let index = index(of: item) {
                
                delegate?.herizontalTableView?(self, didSelectItemAt: index)
            }
        }
    }

    // method forwarding
    override public func responds(to aSelector: Selector!) -> Bool {

        if let delegate = self.delegate {
            return (super.responds(to: aSelector) || delegate.responds(to: aSelector))
        }
        return super.responds(to: aSelector)
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {

        if let target = super.forwardingTarget(for: aSelector) {

            return target
        } else if delegate?.responds(to: aSelector) ?? false {

            return delegate
        } else {
            return nil
        }
    }

}
