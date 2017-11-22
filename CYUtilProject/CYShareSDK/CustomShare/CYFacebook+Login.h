//
//  CYFacebook+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYFacebook.h"

#if CY_FACEBOOK_ENABLED && CY_FACEBOOK_LOGIN_ENABLED

/**
 *  增加facebook 登录详细信息
 */
@class FBSDKAccessToken;
@interface CYLoginInfo (Facebook)

// FacebookSDK中的accessToken结构，包含详细的登录信息
// 如果开发者需要更多登录信息，可以使用此属性来获取，使用时请先#import <FBSDKCoreKit/FBSDKCoreKit.h>
@property (nonatomic, strong) FBSDKAccessToken *fbSDKAccessToken;

@end

/**
 *  增加facebook返回的用户详细信息
 */
@interface CYUserInfo (Facebook)

@property (nonatomic, strong) NSDictionary *facebookUserInfo;

@end

@class FBSDKLoginManager;
@interface CYFacebook (Login)

@property (nonatomic, strong) FBSDKLoginManager *loginManager;

/**
 *  facebook登录
 *  可选的权限：
 *
 *
 */
- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback;

- (BOOL)getUserInfo:(NSString *)userId callback:(CYGetUserInfoCallback)callback;

@end

#endif
