//
//  CYDeviceUtils.m
//  CY
//
//  Created by Charry on 6/3/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYDeviceUtils.h"

@implementation CYDeviceUtils

+ (CYDeviceScreenType)currentDeviceScreenType {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenMaxSide = MAX(screenSize.width, screenSize.height);
    if (screenMaxSide <= 480) {
        
        return CYDeviceScreenType_3_5;
    } else if (screenMaxSide <= 568) {
        
        return CYDeviceScreenType_4_0;
    } else if (screenMaxSide <= 667) {
        
        return CYDeviceScreenType_4_7;
    } else if (screenMaxSide <= 736) {
        
        return CYDeviceScreenType_5_5;
    } else if (screenMaxSide <= 1024) {
        
        return CYDeviceScreenType_iPad;
    } else {
        
        return CYDeviceScreenType_Unknown;
    }
}

+ (CGFloat)screenLongerSideLength {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return MAX(screenSize.width, screenSize.height);
}

+ (CGFloat)screenShorterSideLength {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return MIN(screenSize.width, screenSize.height);
}

+ (CGFloat)screenWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

+ (BOOL)systemIsIos8AndLater {
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return [systemVersion floatValue] >= 8.f;
}

+ (NSString *)currentAppVersion {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
