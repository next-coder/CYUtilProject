//
//  CYArcProgressBar.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 01/12/2016.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit

/**

 圆弧进度条

 默认圆中心为progressBar的中心，半径为min(frame.width, frame.height) / 2.0 - barWidth / 2.0，startAngle为0，endAngle为M_PI * 1.5

 */

class CYArcProgressBar: CYBaseProgressBar {

    // 整个bar的其实角度
    private(set) var startAngle: Double
    // 计算进度的起始角度，在calculateStartAngle和startAngle之间的部分都是已完成状态
    private(set) var calculateStartAngle: Double
    private(set) var endAngle: Double
    private(set) var arcRadius: Double
    private(set) var arcCenter: CGPoint

    private var totalAngle: Double

    init(startAngle: Double,
         calculateStartAngle: Double,
         endAngle: Double,
         arcRadius: Double,
         arcCenter: CGPoint,
         barWidth: Double,
         frame: CGRect) {

        self.startAngle = startAngle
        self.calculateStartAngle = calculateStartAngle
        self.endAngle = endAngle
        self.arcRadius = arcRadius
        self.arcCenter = arcCenter

        // compute total Angle
        totalAngle = endAngle - calculateStartAngle
        if totalAngle < 0 {
            totalAngle += 2 * .pi
        }
        super.init(barWidth: barWidth, frame: frame)
    }

    convenience init(startAngle: Double,
                     calculateStartAngle: Double,
                     endAngle: Double,
                     arcRadius: Double,
                     arcCenter: CGPoint,
                     frame: CGRect) {

        self.init(startAngle: startAngle,
                  calculateStartAngle: calculateStartAngle,
                  endAngle: endAngle,
                  arcRadius: arcRadius,
                  arcCenter: arcCenter,
                  barWidth: 4,
                  frame: frame)
    }

    convenience init(startAngle: Double,
                     endAngle: Double,
                     arcRadius: Double,
                     arcCenter: CGPoint,
                     barWidth: Double,
                     frame: CGRect) {

        self.init(startAngle: startAngle,
                  calculateStartAngle: startAngle,
                  endAngle: endAngle,
                  arcRadius: arcRadius,
                  arcCenter: arcCenter,
                  barWidth: barWidth,
                  frame: frame)
    }

    convenience init(startAngle: Double,
                     endAngle: Double,
                     arcRadius: Double,
                     arcCenter: CGPoint,
                     frame: CGRect) {
        self.init(startAngle: startAngle,
                  endAngle: endAngle,
                  arcRadius: arcRadius,
                  arcCenter: arcCenter,
                  barWidth: 4.0,
                  frame: frame)
    }

    override convenience init(barWidth: Double, frame: CGRect) {
        self.init(startAngle: 0,
                  endAngle: .pi * 1.5,
                  arcRadius: Double(min(frame.width, frame.height)) / 2 - barWidth / 2,
                  arcCenter: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0),
                  barWidth: barWidth,
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

        let endFactorW = cos(progress * totalAngle + calculateStartAngle)
        let endFactorH = sin(progress * totalAngle + calculateStartAngle)
        progressHeaderView?.center = CGPoint(x: endFactorW * arcRadius + Double(arcCenter.x),
                                             y: endFactorH * arcRadius + Double(arcCenter.y))
    }

    override func drawFull() {

        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: CGFloat(arcRadius),
                                startAngle: CGFloat(startAngle),
                                endAngle: CGFloat(endAngle),
                                clockwise: true)
        fullLayer?.path = path.cgPath
    }

    override func drawCompleted() {

        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: CGFloat(arcRadius),
                                startAngle: CGFloat(startAngle),
                                endAngle: CGFloat(progress * totalAngle + calculateStartAngle),
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










