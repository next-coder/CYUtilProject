//
//  UIImage+CYScale.h
//  CYUtilProject
//
//  Created by xn011644 on 06/03/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CYScale)

// 缩放图片到固定size
- (UIImage *)cy_imageByScaleToSize:(CGSize)size;

// 等比例缩放图片，缩放至固定的宽度或高度
- (UIImage *)cy_imageByScaleToWidth:(CGFloat)width;
- (UIImage *)cy_imageByScaleToHeight:(CGFloat)height;

@end
