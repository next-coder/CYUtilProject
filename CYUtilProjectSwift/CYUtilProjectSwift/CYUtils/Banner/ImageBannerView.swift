//
//  ImageBannerView.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 01/03/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

@objc public protocol ImageBannerViewDelegate: UIScrollViewDelegate {
    @objc optional func imageBannerView(_ imageBannerView: ImageBannerView, didTapItemAt index: Int)
}

open class ImageBannerView: UIView, UIScrollViewDelegate {

    open private(set) var images: [UIImage]?
    open private(set) var cycleScrolling: Bool = false
    open private(set) var autoplayDuration: Double = 0.0
    public private(set) var currentIndex: Int = 0
    
    @IBOutlet open private(set) var scrollView: UIScrollView?
    @IBOutlet open private(set) var pageControl: UIPageControl?
    open private(set) var imageViews: [UIImageView]?
    
    open weak var delegate: ImageBannerViewDelegate?
    
    public init(images: [UIImage], cycleScrolling: Bool, frame: CGRect) {
        self.images = images
        self.cycleScrolling = cycleScrolling
        super.init(frame: frame)
        
        pConfigureView()
        refreshContents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        pConfigureView()
    }
    
    private func pConfigureView() {
        if scrollView == nil {
            scrollView = UIScrollView(frame: self.bounds)
            scrollView?.backgroundColor = UIColor.white
            scrollView?.isPagingEnabled = true
            scrollView?.showsVerticalScrollIndicator = false
            scrollView?.showsHorizontalScrollIndicator = false
            pageControl?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            scrollView?.delegate = self
            self.addSubview(scrollView!)
        }
        
        if pageControl == nil {
            pageControl = UIPageControl()
            pageControl?.backgroundColor = UIColor.clear
            pageControl?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            pageControl?.pageIndicatorTintColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
            pageControl?.currentPageIndicatorTintColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
            self.addSubview(pageControl!)
        }
    }
    
    private func refreshContents() {
        guard let images = self.images else {
            return
        }
        if imageViews == nil {
            imageViews = [UIImageView]()
        }
        
        var imageViewsCount = images.count
        if cycleScrolling {
            imageViewsCount += 2
        }
        if imageViews!.count < imageViewsCount {
            // imageViews过少时，创建响应数量
            for _ in 0..<(imageViewsCount - imageViews!.count) {
                imageViews?.append(createContentImageView())
            }
        } else if imageViews!.count > imageViewsCount {
            // imageViews过多时，删除多余的
            imageViews?.removeLast(imageViews!.count - imageViewsCount)
        }
        
        imageViews?.enumerated().forEach({ (index, imageView) in
            if cycleScrolling {
                if index == 0 {
                    imageView.image = images.last
                } else if index == imageViewsCount - 1 {
                    imageView.image = images.first
                } else {
                    imageView.image = images[index - 1]
                }
            } else {
                imageView.image = images[index]
            }
            scrollView?.addSubview(imageView)
        })
        
        if let pageControl = self.pageControl {
            pageControl.numberOfPages = images.count
            if pageControl.currentPage >= images.count {
                pageControl.currentPage = images.count - 1
            }
        }
    }
    
    private func createContentImageView() -> UIImageView {
        let imageView = UIImageView(frame: self.bounds)
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        imageView.addGestureRecognizer(tap)
        return imageView
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = self.bounds.size
        scrollView?.frame = self.bounds
        scrollView?.contentSize = CGSize(width: CGFloat(images?.count ?? 0) * contentSize.width, height: contentSize.height)
        if cycleScrolling {
            scrollView?.contentInset = UIEdgeInsets(top: 0,
                                                    left: contentSize.width,
                                                    bottom: 0,
                                                    right: contentSize.width)
        } else {
            scrollView?.contentInset = .zero
        }
        pageControl?.frame = CGRect(x: 0,
                                    y: contentSize.height - 30,
                                    width: contentSize.width,
                                    height: 30)
        imageViews?.enumerated().forEach({ (index, imageView) in
            if cycleScrolling {
                imageView.frame = CGRect(x: CGFloat(index-1) * contentSize.width,
                                         y: 0,
                                         width: contentSize.width,
                                         height: contentSize.height)
            } else {
                imageView.frame = CGRect(x: CGFloat(index) * contentSize.width,
                                         y: 0,
                                         width: contentSize.width,
                                         height: contentSize.height)
            }
        })
    }
    
    // MARK: operation
    open func setCurrentIndex(_ currentIndex: Int, animated: Bool) {
        self.currentIndex = currentIndex
        scrollView?.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.bounds.width, y: 0), animated: animated)
    }
    
    open func reload(images: [UIImage], cycleScrolling: Bool) {
        self.images = images
        self.cycleScrolling = cycleScrolling
        refreshContents()
    }
    
    // MARK: auto play
    open func startAutoplay(_ duration: Double) {
        self.autoplayDuration = duration
        resumeAutoplay()
    }
    
    open func stopAutoplay() {
        self.autoplayDuration = 0
        pauseAutoplay()
    }
    
    open func pauseAutoplay() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    open func resumeAutoplay() {
        if self.autoplayDuration <= 0 {
            return
        }
        self.perform(#selector(autoplay),
                     with: nil,
                     afterDelay: self.autoplayDuration)
    }
    
    @objc private func autoplay() {
        if self.autoplayDuration <= 0 {
            return
        }
        guard let scrollView = self.scrollView else {
            return
        }
        
        if cycleScrolling
            || self.currentIndex < (images?.count ?? 0) - 1 {
            scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex + 1) * scrollView.frame.width, y: 0),
                                        animated: true)
            resumeAutoplay()
        }
    }
    
    // MARK: UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging?(scrollView)
        if self.autoplayDuration > 0 {
            pauseAutoplay()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        if !decelerate {
            resumeAutoplay()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
        resumeAutoplay()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll?(scrollView)
        
        guard let images = self.images else {
            return
        }
        
        if cycleScrolling {
            let offsetX = scrollView.contentOffset.x
            if offsetX < -scrollView.bounds.width / 2.0 {
                scrollView.contentOffset.x = scrollView.contentSize.width - scrollView.bounds.width / 2.0
            } else if offsetX > scrollView.contentSize.width - scrollView.bounds.width / 2.0 {
                scrollView.contentOffset.x = -scrollView.bounds.width / 2.0
            }
        }
        
        var index = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2.0) / scrollView.bounds.width)
        if index < 0 {
            index = (cycleScrolling ? images.count - 1 : 0)
        } else if index >= images.count {
            index = (cycleScrolling ? 0 : images.count - 1)
        }
        self.pageControl?.currentPage = index
        self.currentIndex = index
    }
    
    // MARK: event
    @objc func itemTapped(_ sender: Any?) {
        if let imageView = (sender as? UITapGestureRecognizer)?.view as? UIImageView,
            let index = imageViews?.index(of: imageView) {
            self.delegate?.imageBannerView?(self, didTapItemAt: index)
        }
    }
    
    // MARK: message forward
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
