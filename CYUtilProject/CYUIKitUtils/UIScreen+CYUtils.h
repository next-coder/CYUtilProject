//
//  UIScreen+CYUtils.h
//  CYUtilProject
//
//  Created by xn011644 on 5/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, CYDeviceScreenType) {

    CYDeviceScreenType_Unknown,                 // 未知
    CYDeviceScreenType_3_5,                     // 3.5寸屏
    CYDeviceScreenType_4_0,                     // 4寸屏
    CYDeviceScreenType_4_7,                     // 4.7寸屏
    CYDeviceScreenType_5_5,                     // 5.5寸屏
    CYDeviceScreenType_iPad                     // ipad屏
};

@interface UIScreen (CYUtils)

// 当前设备屏幕尺寸类型，详见CYDeviceScreenType
- (CYDeviceScreenType)currentDeviceScreenType;

// 屏幕长边的长度
- (CGFloat)screenLongerSideLength;
// 屏幕短边的长度
- (CGFloat)screenShorterSideLength;

// 屏幕宽度
- (CGFloat)screenWidth;

// 屏幕高度
- (CGFloat)screenHeight;

// 屏幕像素(width*height格式)
- (NSString *)screenPixelResolution;

@end
