//
//  CYExceptionUtils.m
//  CYUtilProject
//
//  Created by xn011644 on 5/13/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYExceptionUtils.h"

@interface CYExceptionUtils()

@property (nonatomic, copy) CYUncaughtExceptionsHandler uncaughtExceptionHandler;

@end

@implementation CYExceptionUtils

static NSUncaughtExceptionHandler *_originUncaughtExceptionHandler;

void CYUncaughtExceptionHandler(NSException *exception) {

    CYUncaughtExceptionsHandler handler = [CYExceptionUtils sharedInstance].uncaughtExceptionHandler;
    if (_originUncaughtExceptionHandler) {
        _originUncaughtExceptionHandler(exception);
    }
    if (handler) {

        handler(exception);
    }
}

+ (void)registerUncaughtExceptionsHandler:(CYUncaughtExceptionsHandler)handler {

    [CYExceptionUtils sharedInstance].uncaughtExceptionHandler = handler;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _originUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();

        NSSetUncaughtExceptionHandler(&CYUncaughtExceptionHandler);
    });
}

+ (instancetype)sharedInstance {

    static CYExceptionUtils *utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        utils = [[CYExceptionUtils alloc] init];
    });
    return utils;
}

@end
