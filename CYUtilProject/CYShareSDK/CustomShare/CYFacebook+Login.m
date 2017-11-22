//
//  CYFacebook+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYFacebook+Login.h"

#if CY_FACEBOOK_ENABLED && CY_FACEBOOK_LOGIN_ENABLED

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <objc/runtime.h>

@implementation CYLoginInfo (Facebook)

static char CYShareSDK_CYLoginInfo_fbSDKAccessTokenKey;

@dynamic fbSDKAccessToken;

- (void)setFbSDKAccessToken:(FBSDKAccessToken *)fbSDKAccessToken {
    objc_setAssociatedObject(self, &CYShareSDK_CYLoginInfo_fbSDKAccessTokenKey, fbSDKAccessToken, OBJC_ASSOCIATION_RETAIN);

    self.accessToken = fbSDKAccessToken.tokenString;
    self.expirationDate = fbSDKAccessToken.expirationDate;
    self.userId = fbSDKAccessToken.userID;
}

- (FBSDKAccessToken *)fbSDKAccessToken {
    return objc_getAssociatedObject(self, &CYShareSDK_CYLoginInfo_fbSDKAccessTokenKey);
}

@end


@implementation CYUserInfo (Facebook)

static char CYShareSDK_CYUserInfo_facebookUserInfoKey;

@dynamic facebookUserInfo;

- (void)setFacebookUserInfo:(NSDictionary *)facebookUserInfo {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYUserInfo_facebookUserInfoKey,
                             facebookUserInfo,
                             OBJC_ASSOCIATION_RETAIN);

    self.userId = facebookUserInfo[@"id"];
    self.nickname = facebookUserInfo[@"name"];
    NSString *gender = facebookUserInfo[@"gender"];
    if ([gender isEqualToString:@"male"]) {
        self.gender = 1;
    } else if ([gender isEqualToString:@"female"]) {
        self.gender = 2;
    }
}

- (NSDictionary *)facebookUserInfo {
    return objc_getAssociatedObject(self, &CYShareSDK_CYUserInfo_facebookUserInfoKey);
}

@end


@implementation CYFacebook (Login)

static char CYShareSDK_CYFacebook_facebookLoginManagerKey;

@dynamic loginManager;

- (void)setLoginManager:(FBSDKLoginManager *)loginManager {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYFacebook_facebookLoginManagerKey,
                             loginManager,
                             OBJC_ASSOCIATION_RETAIN);
}

- (FBSDKLoginManager *)loginManager {
    return objc_getAssociatedObject(self,
                                    &CYShareSDK_CYFacebook_facebookLoginManagerKey);
}

- (BOOL)loginWithCallback:(CYLoginCallback)callback {
    return [self loginWithPermissions:nil callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions callback:(CYLoginCallback)callback {
    return [self loginWithPermissions:permissions
                   fromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                             callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {

//    if (permissions.count == 0) {
//        return NO;
//    }

    if (!self.loginManager) {
        self.loginManager = [[FBSDKLoginManager alloc] init];
        self.loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    }
    [self.loginManager logInWithReadPermissions:permissions
                             fromViewController:viewController
                                        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                NSInteger statusCode = 0;
                                                NSString *msg = nil;
                                                CYLoginInfo *loginInfo = nil;
                                                if (error) {
                                                    statusCode = error.code;
                                                    msg = error.localizedDescription;
                                                } else if (result.isCancelled) {
                                                    statusCode = -1;
                                                    msg = NSLocalizedString(@"Cancelled", nil);
                                                } else {
                                                    statusCode = 0;
                                                    msg = NSLocalizedString(@"Success", nil);
                                                    loginInfo = [[CYLoginInfo alloc] init];
                                                    loginInfo.fbSDKAccessToken = result.token;
                                                    self.loginInfo = loginInfo;
                                                }
                                                if (callback) {
                                                    callback(statusCode, msg, loginInfo);
                                                }
                                            });
                                        }];
    return YES;
}

- (BOOL)getUserInfo:(NSString *)userId callback:(CYGetUserInfoCallback)callback {
    if (!userId
        || userId.length == 0) {
        return NO;
    }
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@?fields=id,name,email,first_name,last_name,short_name,gender", userId] parameters:nil HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        NSInteger statusCode = error.code;
        NSString *msg = [error localizedDescription];
        CYUserInfo *userInfo = nil;
        if (result) {
            statusCode = 0;
            userInfo = [[CYUserInfo alloc] init];
            userInfo.facebookUserInfo = result;
            self.userInfo = userInfo;
        }
        if (callback) {
            callback(statusCode, msg, userInfo);
        }
    }];
    return YES;
}

@end

#endif
