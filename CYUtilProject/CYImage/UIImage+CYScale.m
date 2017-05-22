//
//  UIImage+CYScale.m
//  CYUtilProject
//
//  Created by xn011644 on 06/03/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

//#import <CoreGraphics/CoreGraphics.h>

#import "UIImage+CYScale.h"

@implementation UIImage (CYScale)

- (UIImage *)cy_imageByScaleToSize:(CGSize)size {

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cy_imageByScaleToWidth:(CGFloat)width {

    CGSize originSize = self.size;

    CGSize newSize = CGSizeMake(width, width * originSize.height / originSize.width);

    return [self cy_imageByScaleToSize:newSize];
}

- (UIImage *)cy_imageByScaleToHeight:(CGFloat)height {

    CGSize originSize = self.size;

    CGSize newSize = CGSizeMake(height * originSize.width / originSize.height, height);
    return [self cy_imageByScaleToSize:newSize];
}

@end
