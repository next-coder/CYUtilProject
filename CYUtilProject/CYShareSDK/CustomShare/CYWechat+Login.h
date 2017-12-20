//
//  CYWechat+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYWechat.h"

#if CY_WECHAT_ENABLED && CY_WECHAT_LOGIN_ENABLED

#import "CYBaseShare+Login.h"


/**
 *  在LoginInfo中增加微信登录后的元数据
 */
@interface CYLoginInfo (Wechat)

/*
 获取accesstoken接口，微信返回的原始数据

 成功包含：
     access_token    接口调用凭证
     expires_in    access_token接口调用凭证超时时间，单位（秒）
     refresh_token    用户刷新access_token
     openid    授权用户唯一标识
     scope    用户授权的作用域，使用逗号（,）分隔
     unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段

 失败包含：
    {"errcode":40029,"errmsg":"invalid code"}

 */
@property (nonatomic, strong) NSDictionary *wechatAccessTokenInfo;

@end


/**
 *  userInfo中增加微信接口返回的元数据
 */
@interface CYUserInfo (Wechat)

/*
 微信获取用户信息的元数据，微信接口返回的字典

 成功包含：
     openid    普通用户的标识，对当前开发者帐号唯一
     nickname    普通用户昵称
     sex    普通用户性别，1为男性，2为女性
     province    普通用户个人资料填写的省份
     city    普通用户个人资料填写的城市
     country    国家，如中国为CN
     headimgurl    用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
     privilege    用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
     unionid    用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。

 失败包含：
     {
     "errcode":40003,"errmsg":"invalid openid"
     }
 */
@property (nonatomic, strong) NSDictionary *wechatUserInfo;

@end



#pragma mark - login
@interface CYWechat (Login)

/**
 *  微信权限
 */
// 基础权限，调用/sns/oauth2/access_token、/sns/oauth2/refresh_token和/sns/auth需要此权限
// 属于基础接口，若应用已拥有其它scope权限，则默认拥有CYWechatLoginPermissionSNSApiBase的权限
FOUNDATION_EXTERN NSString *const CYWechatLoginPermissionSNSApiBase;
// 获取用户个人信息权限，调用/sns/userinfo接口需要此权限
FOUNDATION_EXTERN NSString *const CYWechatLoginPermissionSNSApiUserInfo;

/**
 *  微信获取access token
 *
 *  @param code     微信登陆后返回的code
 *  @param callback 获取access token 完成后回调
 */
- (void)getAccessTokenWithCode:(NSString *)code
                      callback:(CYLoginCallback)callback;

/**
 *  微信刷新access token
 *
 *  @param refreshToken 获取AccessToken接口返回的refreshToken
 *  @param callback 获取access token 完成后回调
 */
- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken
                                  callback:(CYLoginCallback)callback;

/**
 *  获取微信用户信息
 *
 *  @param accessToken 获取AccessToken接口返回的accessToken
 *  @param openid 获取AccessToken接口返回的openid
 *  @param callback 获取access token 完成后回调
 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken
                            openid:(NSString *)openid
                          callback:(CYGetUserInfoCallback)callback;

@end

#endif

