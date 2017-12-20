//
//  BaseViewModel.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 14/12/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc public protocol ViewModelProtocol {
    var model: Any { get set }
    
    init?(model: Any)
}
