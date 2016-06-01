//
//  UIDevice+CYUtils.h
//  CYUtilProject
//
//  Created by xn011644 on 5/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIDevice (CYUtils)

// 当前设备系统是否为8.0或更新
- (BOOL)cy_systemIsIos8AndLater;

// 当前app版本号
- (NSString *)cy_currentAppVersion;

@end
