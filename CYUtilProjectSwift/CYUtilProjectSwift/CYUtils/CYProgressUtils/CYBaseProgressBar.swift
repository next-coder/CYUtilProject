//
//  CYProgressBar.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 28/11/2016.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit
import QuartzCore

class CYBaseProgressBar: UIView {

    // private
    private(set) var fullLayer: CAShapeLayer?
    private(set) var completionLayer: CAShapeLayer?

    var completedPath: CGPath?

    // progress, use
    private(set) var progress = 0.0

    // bar config
    // bar 宽度/高度, default 4.0
    private(set) var barWidth: Double
    // 整个进度条的背景色, default lightGray
    var color = UIColor.lightGray {
        didSet {

            fullLayer?.strokeColor = color.cgColor
        }
    }
    // 已完成部分背景色, default blue
    var completionColor = UIColor.blue {
        didSet {

            completionLayer?.strokeColor = completionColor.cgColor
        }
    }
    /* The cap style used when stroking the path. Options are `butt', `round'
     * and `square'. Defaults to `round'. */
    var lineCap = kCALineCapRound {
        didSet {
            fullLayer?.lineCap = lineCap
            completionLayer?.lineCap = lineCap
        }
    }

    // 进度条头部
    var progressHeaderView: UIView? {

        didSet {

            if let oldProgress = oldValue {
                oldProgress.removeFromSuperview()
            }
            if let progressHeaderView = self.progressHeaderView {

                addSubview(progressHeaderView)
            }
        }
    }

    init(barWidth: Double, frame: CGRect) {
        self.barWidth = barWidth

        super.init(frame: frame)

        backgroundColor = UIColor.clear
        createProgressLayers()
    }

    convenience override init(frame: CGRect) {
        self.init(barWidth: 4.0, frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    private func createProgressLayers() {

        if fullLayer == nil {
            fullLayer = CAShapeLayer()
            fullLayer?.frame = bounds
            fullLayer?.backgroundColor = UIColor.clear.cgColor
            fullLayer?.lineCap = lineCap
            fullLayer?.lineWidth = CGFloat(barWidth)
            fullLayer?.strokeColor = color.cgColor
            fullLayer?.fillColor = UIColor.clear.cgColor
            layer.addSublayer(fullLayer!)
        }
        if completionLayer == nil {
            completionLayer = CAShapeLayer()
            completionLayer?.frame = bounds
            completionLayer?.backgroundColor = UIColor.clear.cgColor
            completionLayer?.lineCap = lineCap
            completionLayer?.lineWidth = CGFloat(barWidth)
            completionLayer?.strokeColor = completionColor.cgColor
            completionLayer?.fillColor = UIColor.clear.cgColor
            layer.addSublayer(completionLayer!)
        }

        drawFull()
        drawCompleted()
    }

    func setProgress(progress: Double, animated: Bool) {
        if progress >= 0
        && progress <= 1
        && self.progress != progress {

            self.progress = progress
            if completionLayer != nil {

                drawCompleted()
                if (animated) {
                    addAnimation()
                }
            }
        }
    }

    func drawFull() {
        // do nothing ,for sub bar to draw custom content
    }

    func drawCompleted() {
        // do nothing ,for sub bar to draw custom content
    }

    func addAnimation() {

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.duration = 2.0
        completionLayer?.add(animation, forKey: nil)
    }

}
