//
//  NSDate+CYUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/25/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "NSDate+CYUtils.h"

@implementation NSDate (CYUtils)

- (long)timeIntervalInMiniSecondsSinceDate:(NSDate *)date {

    NSTimeInterval timeInterval = [self timeIntervalSinceDate:date];
    return (long)(timeInterval * 1000);
}

- (long)timeIntervalInMiniSecondsSinceNow {

    NSTimeInterval timeInterval = [self timeIntervalSinceNow];
    return (long)(timeInterval * 1000);
}

- (long)timeIntervalInMiniSecondsSince1970 {

    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    return (long)(timeInterval * 1000);
}

@end
