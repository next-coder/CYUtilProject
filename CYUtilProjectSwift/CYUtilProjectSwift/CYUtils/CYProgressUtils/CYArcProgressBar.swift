//
//  CYArcProgressBar.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 01/12/2016.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

/**

 圆弧进度条

 默认圆中心为progressBar的中心，半径为min(frame.width, frame.height) / 2.0 - barWidth / 2.0，startAngle为0，endAngle为M_PI * 1.5

 */

class CYArcProgressBar: CYBaseProgressBar {

    private(set) var startAngle: Double
    private(set) var endAngle: Double
    private(set) var arcRadius: Double
    private(set) var arcCenter: CGPoint

    private var totalAngle: Double

    init(startAngle: Double,
         endAngle: Double,
         arcRadius: Double,
         arcCenter: CGPoint,
         barWidth: Double,
         frame: CGRect) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.arcRadius = arcRadius
        self.arcCenter = arcCenter

        // compute total Angle
        totalAngle = endAngle - startAngle
        if totalAngle < 0 {
            totalAngle += 2 * M_PI
        }
        super.init(barWidth: barWidth, frame: frame)
    }

    override convenience init(barWidth: Double, frame: CGRect) {
        self.init(startAngle: 0,
                  endAngle: M_PI * 1.5,
                  arcRadius: Double(min(frame.width, frame.height)) / 2 - barWidth / 2,
                  arcCenter: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0),
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

        let endFactorW = cos(progress * totalAngle + startAngle)
        let endFactorH = sin(progress * totalAngle + startAngle)
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
                                endAngle: CGFloat(progress * totalAngle + startAngle),
                                clockwise: true)
        completionLayer?.path = path.cgPath
//        completedPath = path
    }

    override func addAnimation() {
        super.addAnimation()

//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = completedPath?.cgPath
//        animation.calculationMode = kCAAnimationPaced
//        animation.duration = 2
//        progressHeaderView?.layer.add(animation, forKey: nil)
    }
}










