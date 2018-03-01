//
//  CYAlertViewAction.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 5/11/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit

public class CYAlertAction: UIButton {
    
    private(set) var title: String?
    private(set) var image: UIImage?
    private(set) var handler: ((CYAlertAction) -> Void)?
    
    public init(title: String?, handler: ((CYAlertAction) -> Void)? = nil) {
        self.title = title
        self.handler = handler
        super.init(frame: .zero)
        
        configureAction()
    }
    
    public init(image: UIImage?, handler: ((CYAlertAction) -> Void)? = nil) {
        self.image = image
        self.handler = handler
        super.init(frame: .zero)
        
        configureAction()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureAction() {
        if let title = self.title {
            self.setTitle(title, for: .normal)
        }
        if let image = self.image {
            self.setImage(image, for: .normal)
            self.setImage(image, for: .highlighted)
        }
        self.backgroundColor = UIColor.white
    }
    
    override public var isHighlighted: Bool {
        didSet {
            self.backgroundColor = UIColor.white
        }
    }
}

