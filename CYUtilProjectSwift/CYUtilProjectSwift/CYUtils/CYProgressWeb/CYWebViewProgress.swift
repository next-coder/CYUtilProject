//
//  CYWebViewProgress.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 01/03/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class CYWebViewProgress: UIView {

    private(set) var progressBar: UIView!
    var progressColor: UIColor = UIColor.blue {
        didSet {
            progressBar.backgroundColor = progressColor
        }
    }

    private var progressValue: Double = 0.0

    // 当前进度，0-1
    var progress: Double {
        set {
            setProgress(progress: newValue, animationDuration: 2, animationOptions: .curveLinear, completion: nil)
        }
        get {
            return progressValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        configureViews()
    }

    private func configureViews() {

        progressBar = UIView()
        progressBar.backgroundColor = progressColor
        addSubview(progressBar!)
    }

    func setProgress(progress: Double,
                     animationDuration duration: Double,
                     animationOptions: UIViewAnimationOptions,
                     completion:((_ finished: Bool) -> Void)?) {

        // 先检查进度条是否被隐藏
        if self.isHidden
            && progress > 0 {
            showProgressBar(resetProgress: true)
        }

        // 绘制进度
        let originProgress = progressValue
        progressValue = progress
        if (originProgress > progressValue) {

            // 进度回退没有动画
            self.progressBar.frame = CGRect(x: 0,
                                             y: 0,
                                             width: Double(self.frame.size.width) * progressValue,
                                             height: 4)
            completion?(true)
        } else {
            // 动画绘制进度
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationOptions,
                           animations: {

                            self.progressBar.frame = CGRect(x: 0,
                                                             y: 0,
                                                             width: Double(self.frame.size.width) * self.progressValue,
                                                             height: 4)
            },
                           completion: {
                            (finished) in
                            completion?(finished)
            })
        }
    }

    func showProgressBar(resetProgress: Bool) {

        // 重新显示progressBar
        self.isHidden = false
        if resetProgress {
            // 重置进度为0
            progressValue = 0
            progressBar.frame = CGRect(x: 0,
                                        y: 0,
                                        width: Double(self.frame.size.width) * progressValue,
                                        height: 4)
        }
    }

    func dismissProgressBar() {

        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.1
        }) { (finished) in
            self.isHidden = true
            self.alpha = 1
        }
    }
}
