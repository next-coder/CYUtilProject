//
//  SingleImageGalleryView.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 28/02/2018.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

@objc public protocol SingleImageGalleryViewDelegate: UIScrollViewDelegate {
    @objc optional func singleImageGalleryViewDidTapContent(_ singleImageGalleryView: SingleImageGalleryView)
}

open class SingleImageGalleryView: UIView, UIScrollViewDelegate {
    open private(set) var image: UIImage?
    
    open private(set) var scrollView: UIScrollView?
    open private(set) var imageView: UIImageView?
    
    open weak var delegate: SingleImageGalleryViewDelegate?
    
    // zoom
    open var minimumZoomScale: CGFloat = 1 {
        didSet {
            scrollView?.minimumZoomScale = self.minimumZoomScale
        }
    }
    open var maximumZoomScale: CGFloat = 1 {
        didSet {
            scrollView?.maximumZoomScale = self.maximumZoomScale
        }
    }
    
    public init(image: UIImage, frame: CGRect) {
        self.image = image
        super.init(frame: frame)
        
        pConfigureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        pConfigureView()
    }
    
    private func pConfigureView() {
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if scrollView == nil {
            scrollView = UIScrollView(frame: self.bounds)
            scrollView?.backgroundColor = UIColor.black
            scrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            scrollView?.showsVerticalScrollIndicator = false
            scrollView?.showsHorizontalScrollIndicator = false
            scrollView?.delegate = self
            scrollView?.minimumZoomScale = self.minimumZoomScale
            scrollView?.maximumZoomScale = self.maximumZoomScale
            self.addSubview(scrollView!)
            
            // add Tap gesture for ImageView
            let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
            scrollView?.addGestureRecognizer(tap)
        }
        
        if imageView == nil {
            imageView = UIImageView(image: image)
            imageView?.contentMode = .scaleAspectFit
            imageView?.backgroundColor = UIColor.clear
            imageView?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
            imageView?.contentMode = .scaleAspectFit
            scrollView?.addSubview(imageView!)
        }
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.bounds.size
        scrollView?.frame = CGRect(origin: .zero, size: viewSize)
        
        if let image = self.image,
            image.size.width > 0,
            image.size.height > 0 {
            let imageViewHeight = image.size.height * (viewSize.width / image.size.width)
            let imageViewFrame = CGRect(x: 0,
                                        y: (viewSize.height - imageViewHeight) / 2.0,
                                        width: viewSize.width,
                                        height: imageViewHeight)
            imageView?.frame = imageViewFrame
            
            scrollView?.contentSize = CGSize(width: viewSize.width, height: imageViewHeight)
        } else {
            imageView?.frame = CGRect(origin: .zero, size: viewSize)
        }
    }
    
    // MARK: event
    @objc func itemTapped(_ sender: Any?) {
        self.delegate?.singleImageGalleryViewDidTapContent?(self)
    }
    
    // MARK: UIScrollViewDelegate
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
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
