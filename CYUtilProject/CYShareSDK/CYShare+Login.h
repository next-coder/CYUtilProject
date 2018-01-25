//
//  CYShare+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShare.h"

#if CY_WECHAT_ENABLED && CY_WECHAT_LOGIN_ENABLED
#import "CYWechat+Login.h"
#endif

#if CY_QQ_ENABLED && CY_QQ_LOGIN_ENABLED
#import "CYQQ+Login.h"
#endif

#if CY_SINA_WEIBO_ENABLED && CY_SINA_WEIBO_LOGIN_ENABLED
#import "CYSinaWeibo+Login.h"
#endif

#if CY_FACEBOOK_ENABLED && CY_FACEBOOK_LOGIN_ENABLED
#import "CYFacebook+Login.h"
#endif

@interface CYShare (Login)

#if CY_WECHAT_ENABLED && CY_WECHAT_LOGIN_ENABLED

/**
 * 微信登陆，以snsapi_userinfo权限登录，不获取AccessToken，以登录成功的微信Code返回
 */
+ (BOOL)loginByWechatWithCodeCallback:(CYWechatLoginCodeCallback)codeCallback;

/**
 * 微信登陆，开发者指定登录权限，具体权限请参考微信开放平台文档
 * 可以指定是否获取AccessToken
 */
+ (BOOL)loginByWechatWithPermissions:(NSArray<NSString *> *)permissions
                  fromViewController:(UIViewController *)viewController
                        codeCallback:(CYWechatLoginCodeCallback)codeCallback
                shouldGetAccessToken:(BOOL)shouldGetAccessToken
                 accessTokenCallback:(CYLoginCallback)accessTokenCallback;

/**
 *  微信登陆，以snsapi_userinfo权限登录
 *  获取AccessToken后回调
 */
+ (BOOL)loginByWechat:(CYLoginCallback)callback;
/**
 *  微信登陆，开发者指定登录权限，具体权限请参考微信开放平台文档
 *  获取AccessToken后回调
 */
+ (BOOL)loginByWechat:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback;

#endif

#if CY_QQ_ENABLED && CY_QQ_LOGIN_ENABLED

/**
 *  qq登陆，以kOPEN_PERMISSION_GET_SIMPLE_USER_INFO权限登录
 */
+ (BOOL)loginByQQ:(CYLoginCallback)callback;
/**
 *  qq登陆，具体权限请参考QQSDK中的sdkdef.h
 */
+ (BOOL)loginByQQ:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback;

#endif

#if CY_SINA_WEIBO_ENABLED && CY_SINA_WEIBO_LOGIN_ENABLED

/**
 *  微博登陆，以all权限登录
 */
+ (BOOL)loginBySinaWeibo:(CYLoginCallback)callback;

/**
 *  微博登录，具体权限请参考微博开放平台
 */
+ (BOOL)loginBySinaWeibo:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback;

#endif

#if CY_FACEBOOK_ENABLED && CY_FACEBOOK_LOGIN_ENABLED

/**
 *  facebook登陆，以默认权限登录
 */
+ (BOOL)loginByFacebook:(CYLoginCallback)callback;
/**
 *  facebook登录，可以支持应用内弹窗登录
 */
+ (BOOL)loginByFacebook:(NSArray<NSString *> *)permissions
     fromViewController:(UIViewController *)viewController
               callback:(CYLoginCallback)callback;

#endif


@end
