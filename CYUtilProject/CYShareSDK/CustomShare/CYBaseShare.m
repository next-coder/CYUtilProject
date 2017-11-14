//
//  CYShareBaseUtil.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYBaseShare.h"

@implementation CYBaseShare

#pragma mark - app info
- (void)registerAppId:(NSString *)appId {
    _appId = appId;
}

- (void)registerAppKey:(NSString *)appKey {
    _appKey = appKey;
}

#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    self.shareCallback = callback;
}

#pragma mark - api
+ (BOOL)openApp {
    
    return NO;
}

+ (BOOL)appInstalled {
    
    return NO;
}

@end
