//
//  CYQQ+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYQQ+Login.h"

#if CY_QQ_ENABLED && CY_QQ_LOGIN_ENABLED

#import <TencentOpenAPI/TencentOAuth.h>
#import <objc/runtime.h>

//@interface CYQQUserInfo()
//
//- (instancetype)initWithDictionary:(NSDictionary *)dic;
//
//@end

#pragma mark - qq login
@implementation CYLoginInfo (QQ)

static char CYShareSDK_CYLoginInfo_qqOAuthKey;

@dynamic qqOAuth;

- (void)setQqOAuth:(TencentOAuth *)qqOAuth {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYLoginInfo_qqOAuthKey,
                             qqOAuth,
                             OBJC_ASSOCIATION_RETAIN);

    self.accessToken = qqOAuth.accessToken;
    self.expirationDate = qqOAuth.expirationDate;
    self.userId = qqOAuth.openId;
}

- (TencentOAuth *)qqOAuth {
    return objc_getAssociatedObject(self, &CYShareSDK_CYLoginInfo_qqOAuthKey);
}

@end

#pragma mark - userinfo
@implementation CYUserInfo (QQ)

static char CYShareSDK_CYUserInfo_qqUserInfoKey;
@dynamic qqUserInfo;

- (void)setQqUserInfo:(NSDictionary *)qqUserInfo {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYUserInfo_qqUserInfoKey,
                             qqUserInfo,
                             OBJC_ASSOCIATION_RETAIN);

    self.userId = [CYQQ sharedInstance].oauth.openId;
    self.nickname = qqUserInfo[@"nickname"];
    self.headImgUrl = qqUserInfo[@"figureurl_2"];
    self.gender = [qqUserInfo[@"gender"] isEqualToString:@"男"];
}

- (NSDictionary *)qqUserInfo {
    return objc_getAssociatedObject(self, &CYShareSDK_CYUserInfo_qqUserInfoKey);
}

@end

@implementation CYQQ (Login)
#pragma mark - login actions
- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
                    callback:(CYLoginCallback)callback {
    BOOL result = [self.oauth authorize:permissions];
    if (result) {
        self.loginCallback = callback;
    }
    return result;
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {
    return [self loginWithPermissions:permissions
                             callback:callback];
}

- (BOOL)loginWithCallback:(CYLoginCallback)callback {
    return [self loginWithPermissions:@[ kOPEN_PERMISSION_GET_SIMPLE_USER_INFO ]
                             callback:callback];
}

- (BOOL)getUserInfoWithCallback:(CYGetUserInfoCallback)callback {
    BOOL result = [self.oauth getUserInfo];
    if (result) {
        self.userInfoCallback = callback;
    }
    return result;
}

- (void)getUserInfoResponse:(APIResponse *)response {
    NSInteger code = response.retCode;
    NSString *msg = response.errorMsg;
    CYUserInfo *userInfo = nil;
    if (code == URLREQUEST_SUCCEED) {
        userInfo = [[CYUserInfo alloc] init];
        userInfo.qqUserInfo = response.jsonResponse;
        self.userInfo = userInfo;
    }
    if (self.userInfoCallback) {
        self.userInfoCallback(code, msg, userInfo);
        self.userInfoCallback = nil;
    }
}


@end

#endif
