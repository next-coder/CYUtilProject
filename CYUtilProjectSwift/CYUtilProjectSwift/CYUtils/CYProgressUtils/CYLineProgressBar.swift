
//
//  CYLineProgressBar.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 01/12/2016.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

/**
 
 线性的进度条，支持水平线竖直线和斜线
 
 线条默认是水平的，位置是progressBar.frame.y中心位置，宽度为progressBar.frame.width
 但不会随着progressBar.frame的改变而改变

*/
class CYLineProgressBar: CYBaseProgressBar {

    private(set) var startPoint: CGPoint
    private(set) var endPoint: CGPoint

    init(startPoint: CGPoint, endPoint: CGPoint, barWidth: Double, frame: CGRect) {

        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(barWidth: barWidth, frame: frame)
    }

    convenience override init(barWidth: Double, frame: CGRect) {

        self.init(startPoint: CGPoint(x: 0, y: frame.height / 2.0),
                  endPoint: CGPoint(x: frame.width, y: frame.height / 2.0),
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
        progressHeaderView?.center = CGPoint(x: (endPoint.x - startPoint.x) * CGFloat(progress) + startPoint.x,
                                             y: (endPoint.y - startPoint.y) * CGFloat(progress) + startPoint.y)
    }

    override func drawFull() {

        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        fullLayer?.path = path
    }

    override func drawCompleted() {

        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: (endPoint.x - startPoint.x) * CGFloat(progress) + startPoint.x,
                                 y: (endPoint.y - startPoint.y) * CGFloat(progress) + startPoint.y))
        completionLayer?.path = path
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
