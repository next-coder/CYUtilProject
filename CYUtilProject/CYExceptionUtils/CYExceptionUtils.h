//
//  CYExceptionUtils.h
//  CYUtilProject
//
//  Created by xn011644 on 5/13/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CYUncaughtExceptionsHandler)(NSException *exception);

@interface CYExceptionUtils : NSObject

+ (void)registerUncaughtExceptionsHandler:(CYUncaughtExceptionsHandler)handler;

@end
