//
//  UIImage+CYUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/11/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "UIImage+CYUtils.h"

@implementation UIImage (CYUtils)

- (UIImage *)imageByScaleImageToSize:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByScaleImageWidthTo:(CGFloat)width {
    
    CGSize originSize = self.size;
    
    CGSize newSize = CGSizeMake(width, width * originSize.height / originSize.width);
    
    return [self imageByScaleImageToSize:newSize];
}

- (UIImage *)imageByScaleImageHeightTo:(CGFloat)height {
    
    CGSize originSize = self.size;
    
    CGSize newSize = CGSizeMake(height * originSize.width / originSize.height, height);
    return [self imageByScaleImageToSize:newSize];
}

+ (UIImage *)resizableImageWithName:(NSString *)name
                          capInsets:(UIEdgeInsets)capInsets {
    
    return [[UIImage imageNamed:name] resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)originalRenderingModeImageWithName:(NSString *)name {
    
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
