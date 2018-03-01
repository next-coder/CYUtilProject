//
//  ImageGalleryView.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 28/02/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

@objc public protocol ImageGalleryViewDelegate: UIScrollViewDelegate {
    @objc optional func imageGalleryView(_ imageGalleryView: ImageGalleryView, didTapItemAt index:Int)
}

open class ImageGalleryView: UIView, UIScrollViewDelegate {
    open private(set) var images: [UIImage]?
    
    // 不要修改scrollView.delegate属性，使用ImageGalleryView.delegate代替
    // 所有的scrollView.delegate事件，都会传递给ImageGalleryView.delegate
    @IBOutlet open private(set) var scrollView: UIScrollView?
    // 为了支持缩放，在套一层专门用于缩放的scrollView
    private var contentScrollViews: [UIScrollView]?
    open private(set) var imageViews: [UIImageView]?
    
    open weak var delegate: ImageGalleryViewDelegate?
    
    // gap between pages
    open var itemGapWidth: CGFloat = 20.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // zoom
    // 当缩放之后的图片，划出屏幕之后，是否需要还原，默认为true，表示还原
    open var recoverAfterScrollOut: Bool = true
    
    open var minimumZoomScale: CGFloat = 1 {
        didSet {
            contentScrollViews?.forEach({ (contentScrollView) in
                contentScrollView.minimumZoomScale = minimumZoomScale
            })
        }
    }
    open var maximumZoomScale: CGFloat = 1 {
        didSet {
            contentScrollViews?.forEach({ (contentScrollView) in
                contentScrollView.maximumZoomScale = maximumZoomScale
            })
        }
    }
    
    // page
    open private(set) var currentIndex: Int = 0
    
    init(images: [UIImage], frame: CGRect) {
        self.images = images
        super.init(frame: frame)
        
        pConfigureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        pConfigureView()
    }
    
    private func pConfigureView() {
        if scrollView == nil {
            scrollView = UIScrollView()
            scrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            scrollView?.backgroundColor = UIColor.black
            scrollView?.isPagingEnabled = true
            scrollView?.showsVerticalScrollIndicator = false
            scrollView?.showsHorizontalScrollIndicator = false
            scrollView?.delegate = self
            self.addSubview(scrollView!)
        }
        
        if let images = self.images,
            images.count > 0 {
            contentScrollViews = [UIScrollView]()
            imageViews = [UIImageView]()
            
            images.forEach({ (image) in
                
                let scrollView = UIScrollView()
                scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                scrollView.backgroundColor = UIColor.clear
                scrollView.delegate = self
                scrollView.minimumZoomScale = self.minimumZoomScale
                scrollView.maximumZoomScale = self.maximumZoomScale
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                
                let imageView = UIImageView(image: image)
                imageView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
                imageView.contentMode = .scaleAspectFit
                imageView.backgroundColor = UIColor.clear
                imageView.isUserInteractionEnabled = true
                imageView.image = image
                scrollView.addSubview(imageView)
                imageViews?.append(imageView)
                
                self.scrollView?.addSubview(scrollView)
                contentScrollViews?.append(scrollView)
                
                // add Tap gesture for ImageView
                let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
                imageView.addGestureRecognizer(tap)
            })
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.bounds.size
        scrollView?.frame = CGRect(origin: .zero, size: CGSize(width: viewSize.width + itemGapWidth, height: viewSize.height))
        scrollView?.contentSize = CGSize(width: CGFloat(images?.count ?? 0) * (viewSize.width + itemGapWidth),
                                         height: 0)
        
        // 布局所有缩放用ScrollView
        contentScrollViews?.enumerated().forEach({ (index, contentScrollView) in
            
            let origin = CGPoint(x: (viewSize.width + itemGapWidth) * CGFloat(index), y: 0)
            contentScrollView.frame = CGRect(origin: origin,
                                             size: viewSize)
        })
        
        imageViews?.enumerated().forEach({ (index, imageView) in
            if let image = images?[index],
                image.size.width > 0,
                image.size.height > 0 {
                let imageViewHeight = image.size.height * (viewSize.width / image.size.width)
                let imageViewFrame = CGRect(x: 0,
                                            y: (viewSize.height - imageViewHeight) / 2.0,
                                            width: viewSize.width,
                                            height: imageViewHeight)
                imageView.frame = imageViewFrame
                
                contentScrollViews?[index].contentSize = CGSize(width: viewSize.width, height: imageViewHeight)
            } else {
                imageView.frame = CGRect(origin: .zero, size: viewSize)
            }
        })
        
        pScrollToCurrentIndex(false)
    }
    
    open func setCurrentIndex(_ currentIndex: Int, animated: Bool) {
        if self.currentIndex == currentIndex {
            return
        }
        
        self.contentScrollViews?[self.currentIndex].zoomScale = 1
        
        self.currentIndex = currentIndex
        pScrollToCurrentIndex(animated)
    }
    
    private func pScrollToCurrentIndex(_ animated: Bool) {
        if let scrollView = self.scrollView {
            var frame = scrollView.bounds
            frame.origin.x = CGFloat(currentIndex) * frame.width
            if scrollView.contentOffset.x != frame.origin.x {
                scrollView.scrollRectToVisible(frame, animated: animated)
            }
        }
    }
    
    // MARK: event
    @objc func itemTapped(_ sender: Any?) {
        if let tap = sender as? UITapGestureRecognizer,
            let imageView = tap.view as? UIImageView,
            let index = imageViews?.index(of: imageView) {
            self.delegate?.imageGalleryView?(self, didTapItemAt: index)
        }
    }
    
    // MARK: UIScrollViewDelegate
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let index = contentScrollViews?.index(of: scrollView) {
            return imageViews?[index]
        } else if scrollView == self.scrollView {
            return self.delegate?.viewForZooming?(in:scrollView)
        } else {
            return nil
        }
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        if scrollView == self.scrollView {
            self.delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
            return
        }
        guard let view1 = view else {
            return
        }
        
        // 缩放完成后，当缩放视图大于scrollView大小，且缩放视图不在scrollView左上角时，重置缩放视图的位置到scrollView左上角
        // 此处不能使用动画，以保证用户视角不变
        if view1.frame.width > scrollView.frame.width
            && view1.frame.minX != 0 {
            scrollView.contentOffset.x += -view1.frame.minX
            view1.frame.origin.x = 0
        }
        if view1.frame.height > scrollView.frame.height
            && view1.frame.minY != 0 {
            scrollView.contentOffset.y += -view1.frame.minY
            view1.frame.origin.y = 0
        }
        
        // 缩放完成后，如果缩放视图大小小于scrollView大小，则重置缩放视图位置到scrollView中心点
        var viewCenter = view1.center
        if view1.frame.width <= scrollView.frame.width {
            viewCenter.x = scrollView.frame.width * 0.5
        }
        if view1.frame.height <= scrollView.frame.height {
            viewCenter.y = scrollView.frame.height * 0.5
        }
        
        if !viewCenter.equalTo(view1.center) {
            
            UIView.animate(withDuration: 0.2) {
                view1.center = viewCenter
            }
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView,
            scrollView.bounds.width > 0 {
            self.delegate?.scrollViewDidScroll?(scrollView)
            
            let index = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2.0) / scrollView.bounds.width)
            self.currentIndex = index
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView
            || !recoverAfterScrollOut {
            return
        }
        // 还原左右两边的缩放
        if self.currentIndex > 0 {
            self.contentScrollViews?[self.currentIndex-1].zoomScale = 1
        }
        if self.currentIndex < (images?.count ?? 0) - 1 {
            self.contentScrollViews?[self.currentIndex+1].zoomScale = 1
        }
    }
    
    // MARK: 方法代理
    override open func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        } else if self.delegate?.responds(to: aSelector) ?? false {
            return true
        } else {
            return false
        }
    }
    
    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let target = super.forwardingTarget(for: aSelector) {
            return target
        } else if self.delegate?.responds(to: aSelector) ?? false {
            return delegate
        } else {
            return nil
        }
    }
}
