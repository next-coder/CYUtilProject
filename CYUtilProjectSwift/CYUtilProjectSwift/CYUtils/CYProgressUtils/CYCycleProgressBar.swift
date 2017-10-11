//
//  CYCycleProgressBar.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 01/12/2016.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit

/**
 
 圆形进度条
 
 默认圆中心为progressBar的中心，半径为min(frame.width, frame.height) / 2.0 - barWidth / 2.0，startAngle为0

 */
class CYCycleProgressBar: CYBaseProgressBar {

    private(set) var startAngle: Double
    private(set) var cycleRadius: Double
    private(set) var cycleCenter: CGPoint

    init(startAngle: Double,
         cycleRadius: Double,
         cycleCenter: CGPoint,
         barWidth: Double,
         frame: CGRect) {

        self.startAngle = startAngle
        self.cycleRadius = cycleRadius
        self.cycleCenter = cycleCenter
        super.init(barWidth: barWidth, frame: frame)

    }

    override convenience init(barWidth: Double,
                              frame: CGRect) {
        self.init(startAngle: 0,
                  cycleRadius: Double(min(frame.width, frame.height)) / 2 - barWidth / 2.0,
                  cycleCenter: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0),
                  barWidth: barWidth,
                  frame: frame)
    }

    convenience init(startAngle: Double,
                     cycleRadius: Double,
                     cycleCenter: CGPoint,
                     frame: CGRect) {

        self.init(startAngle: startAngle,
                  cycleRadius: cycleRadius,
                  cycleCenter: cycleCenter,
                  barWidth: 4.0,
                  frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("not implemented")
    }

    override var progressHeaderView: UIView? {

        didSet {
            refreshHeaderPosition()
        }
    }

    override func setProgress(progress: Double, animated: Bool) {
        super.setProgress(progress: progress, animated: animated)

        refreshHeaderPosition()
    }

    private func refreshHeaderPosition() {

        let endFactorW = cos(progress * 2 * .pi + startAngle)
        let endFactorH = sin(progress * 2 * .pi + startAngle)
        progressHeaderView?.center = CGPoint(x: endFactorW * cycleRadius + Double(cycleCenter.x),
                                             y: endFactorH * cycleRadius + Double(cycleCenter.y))
    }

    override func drawFull() {

        let path = UIBezierPath(ovalIn: CGRect(x: Double(cycleCenter.x) - cycleRadius,
                                               y: Double(cycleCenter.y) - cycleRadius,
                                               width: cycleRadius * 2,
                                               height: cycleRadius * 2))
        fullLayer?.path = path.cgPath
    }

    override func drawCompleted() {

        let path = UIBezierPath(arcCenter: cycleCenter,
                                radius: CGFloat(cycleRadius),
                                startAngle: CGFloat(startAngle),
                                endAngle: CGFloat(progress * 2 * .pi + startAngle),
                                clockwise: true)
        completionLayer?.path = path.cgPath
        completedPath = path.cgPath
    }

    override func addAnimation() {
        super.addAnimation()

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = completedPath
        animation.calculationMode = kCAAnimationPaced
        animation.duration = 2
        progressHeaderView?.layer.add(animation, forKey: nil)
    }
}
