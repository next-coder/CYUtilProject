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
- (UIImage *)imageByScaleImageToSize:(CGSize)size;

// 等比缩放到固定宽度或高度
- (UIImage *)imageByScaleImageWidthTo:(CGFloat)width;
- (UIImage *)imageByScaleImageHeightTo:(CGFloat)height;

// get resizable image from file, use imageNamed:
+ (UIImage *)resizableImageWithName:(NSString *)name
                          capInsets:(UIEdgeInsets)capInsets;

// get origin rendering mode image, use imageNamed:
+ (UIImage *)originalRenderingModeImageWithName:(NSString *)name;

@end
