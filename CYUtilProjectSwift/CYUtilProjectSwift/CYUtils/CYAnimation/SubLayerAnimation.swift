//
//  SubLayerAnimation.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 25/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

open class SubLayerAnimation: NSObject {

    private(set) var layer: CALayer?

    init(_ layer: CALayer) {
        self.layer = layer

        super.init()
    }

    override private init() {
        super.init()
    }

}
