//
//  TableViewCellMVVMProtocol.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 14/12/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc public protocol SimpleTableViewCellContentsProtocol {
    var cellClass: Swift.AnyClass? { get }
}

@objc public protocol SimpleTableViewCellProtocol {
    var contents: SimpleTableViewCellContentsProtocol? { get set }
    
    var indexPath: IndexPath? { get set }
    
    @objc static func height(`for` contents: SimpleTableViewCellContentsProtocol?) -> CFloat
}

extension UITableViewCell: SimpleTableViewCellProtocol {
    private static var SimpleTableViewCellProtocol_ContentsKey: UInt8 = 0
    private static var SimpleTableViewCellProtocol_IndexPathKey: UInt8 = 0
    
    public var contents: SimpleTableViewCellContentsProtocol? {
        set {
            objc_setAssociatedObject(self,
                                     &(UITableViewCell.SimpleTableViewCellProtocol_ContentsKey),
                                     contents,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(UITableViewCell.SimpleTableViewCellProtocol_ContentsKey)) as? SimpleTableViewCellContentsProtocol
        }
    }
    
    public var indexPath: IndexPath? {
        set {
            objc_setAssociatedObject(self,
                                     &(UITableViewCell.SimpleTableViewCellProtocol_IndexPathKey),
                                     indexPath,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(UITableViewCell.SimpleTableViewCellProtocol_IndexPathKey)) as? IndexPath
        }
    }
    
    public static func height(`for` contents: SimpleTableViewCellContentsProtocol?) -> CFloat {
        return 0
    }
}
