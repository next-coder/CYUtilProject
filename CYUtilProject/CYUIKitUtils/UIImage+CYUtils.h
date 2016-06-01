//
//  UIImage+CYUtils.h
//  CYUtilProject
//
//  Created by xn011644 on 5/11/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CYUtils)

// 缩放到固定size，不一定等比
- (UIImage *)cy_imageByScaleImageToSize:(CGSize)size;

// 等比缩放到固定宽度或高度
- (UIImage *)cy_imageByScaleImageWidthTo:(CGFloat)width;
- (UIImage *)cy_imageByScaleImageHeightTo:(CGFloat)height;

// get resizable image from file, use imageNamed:
+ (UIImage *)cy_resizableImageWithName:(NSString *)name
                          capInsets:(UIEdgeInsets)capInsets;

// get origin rendering mode image, use imageNamed:
+ (UIImage *)cy_originalRenderingModeImageWithName:(NSString *)name;

@end
