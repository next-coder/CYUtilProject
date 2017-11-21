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



@implementation CYFacebook (Login)

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions callback:(CYLoginCallback)callback {
    return [self loginWithPermissions:permissions
                   fromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                             callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {

    if (permissions.count == 0) {
        return NO;
    }

    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    [manager logInWithReadPermissions:permissions
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

#warning facebook user info
- (BOOL)getUserInfo:(NSString *)userId callback:(CYGetUserInfoCallback)callback {
    if (!userId
        || userId.length == 0) {
        return NO;
    }
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@", userId] parameters:nil HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        NSLog(result);
    }];
    return YES;
}

@end

#endif
