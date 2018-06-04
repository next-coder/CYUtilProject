//
//  CYBaseShare+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYBaseShare+Login.h"

#import <objc/runtime.h>

@implementation CYBaseShare (Login)

#pragma mark - login properties
static char CYShareSDK_CYBaseShare_loginCallbackKey;
static char CYShareSDK_CYBaseShare_loginInfoKey;
static char CYShareSDK_CYBaseShare_userInfoCallbackKey;
static char CYShareSDK_CYBaseShare_userInfoKey;

@dynamic loginCallback;
@dynamic loginInfo;
@dynamic userInfoCallback;
@dynamic userInfo;

// save and get properties using runtime api
- (void)setLoginCallback:(CYLoginCallback)loginCallback {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYBaseShare_loginCallbackKey,
                             loginCallback,
                             OBJC_ASSOCIATION_COPY);
}

- (CYLoginCallback)loginCallback {
    return objc_getAssociatedObject(self,
                                    &CYShareSDK_CYBaseShare_loginCallbackKey);
}

- (void)setLoginInfo:(CYLoginInfo *)loginInfo {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYBaseShare_loginInfoKey,
                             loginInfo,
                             OBJC_ASSOCIATION_RETAIN);
}

- (CYLoginInfo *)loginInfo {
    return objc_getAssociatedObject(self,
                                    &CYShareSDK_CYBaseShare_loginInfoKey);
}

- (void)setUserInfoCallback:(CYGetUserInfoCallback)userInfoCallback {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYBaseShare_userInfoCallbackKey,
                             userInfoCallback,
                             OBJC_ASSOCIATION_COPY);
}

- (CYGetUserInfoCallback)userInfoCallback {
    return objc_getAssociatedObject(self, &CYShareSDK_CYBaseShare_userInfoCallbackKey);
}

- (void)setUserInfo:(CYUserInfo *)userInfo {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYBaseShare_userInfoKey,
                             userInfo,
                             OBJC_ASSOCIATION_RETAIN);
}

- (CYUserInfo *)userInfo {
    return objc_getAssociatedObject(self, &CYShareSDK_CYBaseShare_userInfoKey);
}

#pragma mark - login action
- (BOOL)loginWithCallback:(CYLoginCallback)callback {
    return NO;
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
                    callback:(CYLoginCallback)callback {
    return NO;
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {
    return NO;
}

@end
