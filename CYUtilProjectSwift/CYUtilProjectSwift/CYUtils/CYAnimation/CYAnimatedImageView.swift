//
//  CYAnimatedImageView.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 24/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

class CYAnimatedImageView: UIView, CAAnimationDelegate {

    private lazy var imageLayer = CALayer()

    var image: UIImage?
//    {
//
//        didSet {
//            if let img = image {
//                imageLayer.contents = img.cgImage
//                imageLayer.frame = self.bounds
//                self.layer.addSublayer(imageLayer)
//            }
//        }
//    }

    func setImage(_ image: UIImage, animated: Bool) {
        self.image = image
        if animated {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {

                self.addAnimation()
            })
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageLayer.frame = self.bounds
    }

    private func addAnimation() {

        let rect = CGRect(x: 50, y: 100, width: 400, height: 400)

        let path = CGMutablePath()
        stride(from: 0, to: CGFloat.pi * 2, by: .pi / 6).forEach { (angle) in

            var transform = CGAffineTransform(rotationAngle: angle)
            path.addPath(CGPath(ellipseIn: CGRect(x: -20,
                                                  y: 0,
                                                  width: 40,
                                                  height: 100),
                                transform: &transform))
        }

        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = path
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 4
        layer.fillColor = UIColor.yellow.cgColor
        self.layer.addSublayer(layer)
    }

//    // MARK: CAAnimationDelegate
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//
//        animationLayer?.removeFromSuperlayer()
//    }
}
