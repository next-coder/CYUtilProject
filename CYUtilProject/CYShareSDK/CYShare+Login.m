//
//  CYShare+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShare+Login.h"

@implementation CYShare (Login)

#if CY_WECHAT_ENABLED && CY_WECHAT_LOGIN_ENABLED
+ (BOOL)loginByWechat:(CYLoginCallback)callback {
    return [[CYWechat sharedInstance] loginWithCallback:callback];
}

+ (BOOL)loginByWechat:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback {
    return [[CYWechat sharedInstance] loginWithPermissions:permissions callback:callback];
}

+ (BOOL)loginByWechat:(NSArray<NSString *> *)permissions fromViewController:(UIViewController *)viewController callback:(CYLoginCallback)callback {
    return [[CYWechat sharedInstance] loginWithPermissions:permissions fromViewController:viewController callback:callback];
}

#endif

#if CY_QQ_ENABLED && CY_QQ_LOGIN_ENABLED

+ (BOOL)loginByQQ:(CYLoginCallback)callback {
    return [[CYQQ sharedInstance] loginWithCallback:callback];
}

+ (BOOL)loginByQQ:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback {
    return [[CYQQ sharedInstance] loginWithPermissions:permissions callback:callback];
}

+ (BOOL)loginByQQ:(NSArray<NSString *> *)permissions fromViewController:(UIViewController *)viewController callback:(CYLoginCallback)callback {
    return [[CYQQ sharedInstance] loginWithPermissions:permissions fromViewController:viewController callback:callback];
}

#endif

#if CY_SINA_WEIBO_ENABLED && CY_SINA_WEIBO_LOGIN_ENABLED

+ (BOOL)loginBySinaWeibo:(CYLoginCallback)callback {
    return [[CYSinaWeibo sharedInstance] loginWithCallback:callback];
}

+ (BOOL)loginBySinaWeibo:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback {
    return [[CYSinaWeibo sharedInstance] loginWithPermissions:permissions callback:callback];
}

+ (BOOL)loginBySinaWeibo:(NSArray<NSString *> *)permissions fromViewController:(UIViewController *)viewController callback:(CYLoginCallback)callback {
    return [[CYSinaWeibo sharedInstance] loginWithPermissions:permissions fromViewController:viewController callback:callback];
}

#endif

#if CY_FACEBOOK_ENABLED && CY_FACEBOOK_LOGIN_ENABLED

+ (BOOL)loginByFacebook:(CYLoginCallback)callback {
    return [[CYFacebook sharedInstance] loginWithCallback:callback];
}

+ (BOOL)loginByFacebook:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback {
    return [[CYFacebook sharedInstance] loginWithPermissions:permissions callback:callback];
}

+ (BOOL)loginByFacebook:(NSArray<NSString *> *)permissions fromViewController:(UIViewController *)viewController callback:(CYLoginCallback)callback {
    return [[CYFacebook sharedInstance] loginWithPermissions:permissions fromViewController:viewController callback:callback];
}

#endif

@end
