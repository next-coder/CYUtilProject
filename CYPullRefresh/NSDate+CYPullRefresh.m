//
//  NSDate+CYPullRefresh.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "NSDate+CYPullRefresh.h"

@implementation NSDate (CYPullRefresh)

- (NSString *)cy_pullRefreshFormattedDate {
    
    static NSString * const timeFormat = @"HH:mm";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                   fromDate:[NSDate date]];
    NSDate *todayStart = [calendar dateFromComponents:dateComponents];
    
    NSString *prefix = nil;
    NSTimeInterval selfTime = self.timeIntervalSince1970;
    NSTimeInterval todayStartTime = todayStart.timeIntervalSince1970;
    if (selfTime - todayStartTime < 24 * 60 * 60.f
        && selfTime - todayStartTime >= 0) {
        
        prefix = @"今天";
    } else if (selfTime - todayStartTime > -24 * 60 * 60.f) {
        
        prefix = @"昨天";
    } else {
        
        static NSString * const dateFormat = @"yyyy-MM-dd";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:dateFormat];
        prefix = [formatter stringFromDate:self];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeFormat];
    NSString *time = [formatter stringFromDate:self];
    
    return [NSString stringWithFormat:@"%@ %@", prefix, time];
}

@end
