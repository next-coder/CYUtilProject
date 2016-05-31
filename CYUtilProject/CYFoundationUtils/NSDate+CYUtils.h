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
- (long)timeIntervalInMiniSecondsSinceDate:(NSDate *)date;
- (long)timeIntervalInMiniSecondsSinceNow;
- (long)timeIntervalInMiniSecondsSince1970;

@end
