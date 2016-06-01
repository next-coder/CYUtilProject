//
//  NSDate+CYUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/25/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "NSDate+CYUtils.h"

@implementation NSDate (CYUtils)

- (long)cy_timeIntervalInMilliSecondsSinceDate:(NSDate *)date {

    NSTimeInterval timeInterval = [self timeIntervalSinceDate:date];
    return (long)(timeInterval * 1000);
}

- (long)cy_timeIntervalInMilliSecondsSinceNow {

    NSTimeInterval timeInterval = [self timeIntervalSinceNow];
    return (long)(timeInterval * 1000);
}

- (long)cy_timeIntervalInMilliSecondsSince1970 {

    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    return (long)(timeInterval * 1000);
}

@end
