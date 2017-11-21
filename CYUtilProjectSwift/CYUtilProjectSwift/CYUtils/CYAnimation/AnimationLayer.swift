//
//  AnimationLayer.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 24/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import Foundation
import QuartzCore

@objc public protocol AnimationLayer {

    @objc optional static func addAnimation(to layer: CALayer)
}
