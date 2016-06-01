//
//  NSDate+CYUtils.h
//  CYUtilProject
//
//  Created by xn011644 on 5/25/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CYUtils)

// time interval in mini seconds
- (long)cy_timeIntervalInMilliSecondsSinceDate:(NSDate *)date;
- (long)cy_timeIntervalInMilliSecondsSinceNow;
- (long)cy_timeIntervalInMilliSecondsSince1970;

@end
