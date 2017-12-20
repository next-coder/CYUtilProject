//
//  QRCodeGenerator.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 19/12/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit
import CoreImage

public class QRCodeGenerator: NSObject {
    
    public static func generate(data: Data) -> CIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        return filter?.outputImage
    }
    
    public static func generate(string: String) -> CIImage? {
        guard let data = string.data(using: String.Encoding.utf8) else {
            return nil
        }
        return self.generate(data: data)
    }
}

public extension CIImage {
    public func scaled(to size: CGSize) -> CIImage {
        let scaleX = size.width / self.extent.width
        let scaleY = size.height / self.extent.height
        
        return self.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
    
    public var uiImage: UIImage {
        return UIImage(ciImage: self)
    }
}

public extension UIImage {
    public func adding(by image: UIImage, in frame: CGRect? = nil) -> UIImage? {
        UIGraphicsBeginImageContext(self.size); defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let addingFrame = frame {
            image.draw(in: addingFrame)
        } else {
            image.draw(at: CGPoint(x: self.size.width / 2.0 - image.size.width / 2.0,
                                   y: self.size.height / 2.0 - image.size.height / 2.0))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
