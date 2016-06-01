//
//  UIDevice+CYUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "UIDevice+CYUtils.h"

@implementation UIDevice (CYUtils)

- (BOOL)cy_systemIsIos8AndLater {

    NSString *systemVersion = [self systemVersion];
    return [systemVersion floatValue] >= 8.f;
}

- (NSString *)cy_currentAppVersion {

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
