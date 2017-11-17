//
//  CYBaseShare+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYBaseShare.h"
#import "CYLoginInfo.h"
#import "CYUserInfo.h"

@class UIViewController;

typedef void (^CYLoginCallback)(NSInteger code,
                                NSString *msg,
                                CYLoginInfo *loginInfo);
typedef void (^CYGetUserInfoCallback)(NSInteger code,
                                      NSString *msg,
                                      CYUserInfo *userInfo);

@interface CYBaseShare (Login)

// 登录回调
@property (nonatomic, copy) CYLoginCallback loginCallback;
// 登录成功后的信息，主要包含accessToken等
@property (nonatomic, strong) CYLoginInfo *loginInfo;

// 获取用户信息回调
@property (nonatomic, copy) CYGetUserInfoCallback userInfoCallback;
// 获取用户信息接口返回数据，主要包含用户id昵称头像等
@property (nonatomic, strong) CYUserInfo *userInfo;

/**
 *  登录接口，默认返回NO，标识登录接口调用失败
 *
 *  @param permissions      登录需要获取的权限列表
 *  @param callback         登录回调，当登录接口调用失败时，不会回调
 *
 */
- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
                    callback:(CYLoginCallback)callback;

/**
 *  登录接口，默认返回NO，标识登录接口调用失败
 *
 *  @param permissions      登录需要获取的权限列表
 *  @param fromViewController   当设备未安装第三方app时，如果第三方支持网页登录，则从fromViewController present一个浮层进行网页登录
 *  @param callback         登录回调，当登录接口调用失败时，不会回调
 *
 */
- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback;

@end
