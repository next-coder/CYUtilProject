//
//  FloatingView.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 02/08/2017.
//  Copyright © 2017 Conner. All rights reserved.
//

import UIKit

public class FloatingView: UIView {

    private(set) var contentView: UIView?
    // 吸附后的margin，default is UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    // 支持吸附的边界，默认为.all，表示四条边都可以自由吸附
    // 如果不想要吸附效果，则设置此属性值为[]
    public var edgesForFloating: UIRectEdge = .all
    // 是否支持移动，默认为true
    public var isMovingEnabled: Bool = true {
        didSet {
            panGesture?.isEnabled = isMovingEnabled
        }
    }

    private var panGesture: UIPanGestureRecognizer?
    private var panStartPoint: CGPoint?

    // MARK: initialize
    // create floating view by a custom content view
    public init(frame: CGRect, contentView: UIView?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        if let content = contentView {
            addSubview(content)
            self.contentView = content
        }

        addPan()
    }

    // create Floating View by an image
    // the target selector would be performed while the image is tapped
    public init(frame: CGRect, contentImage: UIImage, target: Any?, selector: Selector) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        let contentView = UIButton(frame: self.bounds)
        contentView.setImage(contentImage, for: .normal)
        contentView.addTarget(target, action: selector, for: .touchUpInside)
        addSubview(contentView)
        self.contentView = contentView

        addPan()
    }

    public override convenience init(frame: CGRect) {
        self.init(frame: frame, contentView: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addPan() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        addGestureRecognizer(panGesture!)
    }

    // MARK: layout
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView?.frame = self.bounds
    }

    // MARK: pan event
    @objc func pan(_ sender: Any?) {

        guard let panGesture = (sender as? UIPanGestureRecognizer) else {

            return
        }

        switch panGesture.state {
            case .began:
                panStartPoint = self.center
            case .changed:
                // 视图跟随手势移动
                let translation = panGesture.translation(in: self.superview)

                var center = panStartPoint ?? self.center
                center.x = reasonableCenterX(center.x + translation.x)
                center.y = reasonableCenterY(center.y + translation.y)

                self.center = center
            case .ended, .cancelled:
                panStartPoint = self.center
                // 拖动结束后，视图自动吸附
                resetFloatingPosition()
            default:
                break
        }
    }

    // 拖动过程中的CenterX，如果超出边界1/3宽度，则不再往边界外移动
    private func reasonableCenterX(_ centerX: CGFloat) -> CGFloat {
        guard let superview = self.superview else {
            return centerX
        }

        var x = min(centerX, superview.frame.width - frame.width / 6.0)
        x = max(x, frame.width / 6.0)
        return x
    }

    // 拖动过程中的CenterY，如果超出边界1/3宽度，则不再往边界外移动
    private func reasonableCenterY(_ centerY: CGFloat) -> CGFloat {
        guard let superview = self.superview else {
            return centerY
        }

        var y = min(centerY, superview.frame.height - frame.height / 6.0)
        y = max(y, frame.height / 6.0)
        return y
    }

    public func resetFloatingPosition() {
        guard let superview = self.superview else {
            return
        }

        // 不吸附
        if edgesForFloating.isEmpty {
            return
        }

        let center = self.center

        // 计算视图中心距父视图左边的距离
        let leftDistance: CGFloat
        if edgesForFloating.contains(.left) {
            // 如果支持左边吸附，则为实际距离
            leftDistance = center.x
        } else {
            // 不支持左边吸附，则距离为无穷大
            // 由于吸附边是根据最近距离原则确定的，故此情况下，左边距离永远是最大的，不可能吸附到左边
            leftDistance = CGFloat.infinity
        }

        // 右边的距离
        let rightDistance: CGFloat
        if edgesForFloating.contains(.right) {
             rightDistance = superview.bounds.width - center.x
        } else {
            rightDistance = CGFloat.infinity
        }

        // 顶部的距离
        let topDistance: CGFloat
        if edgesForFloating.contains(.top) {
            topDistance = center.y
        } else {
            topDistance = CGFloat.infinity
        }

        // 底部的距离
        let bottomDistance: CGFloat
        if edgesForFloating.contains(.bottom) {
            bottomDistance = superview.bounds.height - center.y
        } else {
            bottomDistance = CGFloat.infinity
        }
        let minDistance = min(leftDistance, rightDistance, topDistance, bottomDistance)

        // 根据最近距离原则确定吸附边，计算视图新中心
        var newCenter: CGPoint
        if leftDistance == minDistance {
            // 向左吸附
            newCenter = CGPoint(x: frame.width / 2.0 + margins.left,
                                y: finalCenterY(center.y))
        } else if rightDistance == minDistance {
            // 向右吸附
            newCenter = CGPoint(x: superview.frame.width - frame.width / 2.0 - margins.right,
                                y: finalCenterY(center.y))
        } else if topDistance == minDistance {
            // 向上吸附
            newCenter = CGPoint(x: finalCenterX(center.x),
                                y: frame.height / 2.0 + margins.top)
        } else {
            // 向下吸附
            newCenter = CGPoint(x: finalCenterX(center.x),
                                y: superview.frame.height - frame.height / 2.0 - margins.bottom)
        }

        UIView.animate(withDuration: 0.2) { 

            self.center = newCenter
        }
    }

    // 吸附后centerX合法值，如果超出边界，则置为边界值
    private func finalCenterX(_ centerX: CGFloat) -> CGFloat {
        guard let superview = self.superview else {
            return centerX
        }

        var x = min(centerX, superview.frame.width - frame.width / 2.0 - margins.right)
        x = max(x, frame.height / 2.0 + margins.left)
        return x
    }

    // 吸附后centerY合法值，如果超出边界，则置为边界值
    private func finalCenterY(_ centerY: CGFloat) -> CGFloat {
        guard let superview = self.superview else {
            return centerY
        }

        var y = min(centerY, superview.frame.height - frame.height / 2.0 - margins.bottom)
        y = max(y, frame.height / 2.0 + margins.top)
        return y
    }

    // MARK: static show floating
    public class func showFloatingView(_ frame: CGRect, contentView: UIView, in view: UIView) -> FloatingView {

        let floatingView = FloatingView(frame: frame, contentView: contentView)
        view.addSubview(floatingView)
        return floatingView
    }
}
