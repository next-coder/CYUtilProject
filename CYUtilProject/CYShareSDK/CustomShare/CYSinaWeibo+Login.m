//
//  CYSinaWeibo+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYSinaWeibo+Login.h"

#if CY_SINA_WEIBO_ENABLED && CY_SINA_WEIBO_LOGIN_ENABLED

#import "WeiboSDK.h"
#import "WeiboUser.h"

#import <objc/runtime.h>


@implementation CYLoginInfo (SinaWeibo)

static char CYShareSDK_CYLoginInfo_sinaWeiboAuthorizeResponseKey;

@dynamic sinaWeiboAuthorizeResponse;

- (void)setSinaWeiboAuthorizeResponse:(WBAuthorizeResponse *)sinaWeiboAuthorizeResponse {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYLoginInfo_sinaWeiboAuthorizeResponseKey,
                             sinaWeiboAuthorizeResponse,
                             OBJC_ASSOCIATION_RETAIN);

    self.accessToken = sinaWeiboAuthorizeResponse.accessToken;
    self.expirationDate = sinaWeiboAuthorizeResponse.expirationDate;
    self.userId = sinaWeiboAuthorizeResponse.userID;
    self.refreshToken = sinaWeiboAuthorizeResponse.refreshToken;
}

- (WBAuthorizeResponse *)sinaWeiboAuthorizeResponse {
    return objc_getAssociatedObject(self, &CYShareSDK_CYLoginInfo_sinaWeiboAuthorizeResponseKey);
}

@end


@implementation CYUserInfo (SinaWeibo)

static char CYShareSDK_CYUserInfo_sinaWeiboUserInfoKey;

@dynamic sinaWeiboUserInfo;

- (void)setSinaWeiboUserInfo:(WeiboUser *)sinaWeiboUserInfo {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYUserInfo_sinaWeiboUserInfoKey,
                             sinaWeiboUserInfo,
                             OBJC_ASSOCIATION_RETAIN);

    self.userId = sinaWeiboUserInfo.userID;
    self.headImgUrl = sinaWeiboUserInfo.profileImageUrl;
    self.nickname = sinaWeiboUserInfo.screenName;
    if ([sinaWeiboUserInfo.gender isEqualToString:@"m"]) {
        self.gender = 1;
    } else if ([sinaWeiboUserInfo.gender isEqualToString:@"f"]) {
        self.gender = 2;
    } else {
        self.gender = 0;
    }
}

- (WeiboUser *)sinaWeiboUserInfo {
    return objc_getAssociatedObject(self, &CYShareSDK_CYUserInfo_sinaWeiboUserInfoKey);
}

@end

#pragma mark - login
@implementation CYSinaWeibo (Login)
- (BOOL)loginWithCallback:(CYLoginCallback)callback {
    return [self loginWithPermissions:@[ @"all" ] callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
                    callback:(CYLoginCallback)callback {
//    if (permissions.count == 0) {
//        return NO;
//    }

    WBAuthorizeRequest *request = [[WBAuthorizeRequest alloc] init];
    request.scope = [permissions componentsJoinedByString:@","];
    request.redirectURI = self.redirectURI;
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL result = [WeiboSDK sendRequest:request];

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

- (BOOL)getUserInfoWithAccessToken:(NSString *)accessToken
                            userId:(NSString *)userId
                          callback:(CYGetUserInfoCallback)callback {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    WBHttpRequest *request = [WBHttpRequest requestForUserProfile:userId
                                                  withAccessToken:accessToken
                                               andOtherProperties:nil
                                                            queue:queue
                                            withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{

                                                    NSInteger code = 0;
                                                    NSString *msg = nil;
                                                    CYUserInfo *userInfo = nil;
                                                    if (error) {
                                                        code = error.code;
                                                        msg = error.localizedDescription;
                                                    } else if (result
                                                               && [result isKindOfClass:[WeiboUser class]]) {

                                                        userInfo = [[CYUserInfo alloc] init];
                                                        userInfo.sinaWeiboUserInfo = (WeiboUser *)result;
                                                        self.userInfo = userInfo;
                                                    } else {
                                                        code = -1;
                                                        msg = NSLocalizedString(@"Failed", nil);
                                                    }

                                                    if (callback) {
                                                        callback(code, msg, userInfo);
                                                    }
                                                });
                                                [queue cancelAllOperations];
                                            }];
    if (request) {
        return YES;
    } else {
        return NO;
    }
}

@end

#endif
