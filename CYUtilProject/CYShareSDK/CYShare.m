//
//  CYShare.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShare.h"

@interface CYShare ()

@end

@implementation CYShare

#if CY_WECHAT_ENABLED
+ (void)registerWechatAppId:(NSString *)appId {
    [[CYWechat sharedInstance] registerAppId:appId];
}

+ (void)registerWechatAppKey:(NSString *)appKey {
    [[CYWechat sharedInstance] registerAppKey:appKey];
}

+ (void)shareToWechat:(CYShareModel *)model scene:(CYWechatScene)scene callback:(CYShareCallback)callback {

    [[CYWechat sharedInstance] share:model
                                  to:scene
                            callback:callback];
}

+ (void)shareToWechat:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    [[CYWechat sharedInstance] share:model fromViewController:viewController callback:callback];
}
#endif

#if CY_QQ_ENABLED
+ (void)registerQQAppId:(NSString *)appId {
    [[CYQQ sharedInstance] registerAppId:appId];
}

+ (void)registerQQAppKey:(NSString *)appKey {
    [[CYQQ sharedInstance] registerAppKey:appKey];
}

+ (void)shareToQQ:(CYShareModel *)model ctrlFlag:(CYQQAPICtrlFlag)flag callback:(CYShareCallback)callback {
    [[CYQQ sharedInstance] share:model to:flag callback:callback];
}

+ (void)shareToQQ:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    [[CYQQ sharedInstance] share:model fromViewController:viewController callback:callback];
}
#endif

#if CY_SINA_WEIBO_ENABLED
+ (void)registerWeiboAppKey:(NSString *)appKey {
    [[CYSinaWeibo sharedInstance] registerAppKey:appKey];
}

+ (void)shareToWeibo:(CYShareModel *)model
            callback:(CYShareCallback)callback {
    [[CYSinaWeibo sharedInstance] share:model
                               callback:callback];
}
#endif

#if CY_SHARE_APPLE_ACTIVITY_ENABLED

+ (void)shareByAppleActivity:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    [[CYAppleActivity sharedInstance] share:model fromViewController:viewController callback:callback];
}

#endif

#if CY_SHARE_SMS_ENABLED

+ (void)shareBySMS:(CYShareModel *)model to:(NSArray *)mobiles fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    [[CYSMS sharedInstance] share:model toMobiles:mobiles fromViewController:viewController callback:callback];
}

#endif

#if CY_FACEBOOK_ENABLED

+ (void)shareToFacebook:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    [[CYFacebook sharedInstance] share:model fromViewController:viewController callback:callback];
}

#endif

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法
+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = NO;
#if CY_WECHAT_ENABLED
    result = [[CYWechat sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif
#if CY_QQ_ENABLED
    result = (result || [[CYQQ sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions]);
#endif
#if CY_SINA_WEIBO_ENABLED
    result = (result || [[CYSinaWeibo sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions]);
#endif
#if CY_FACEBOOK_ENABLED
    result = (result || [[CYFacebook sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions]);
#endif
    return result;
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    BOOL result = NO;
#if CY_WECHAT_ENABLED
    result = [[CYWechat sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
#endif
#if CY_QQ_ENABLED
    result = (result || [[CYQQ sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]);
#endif
#if CY_SINA_WEIBO_ENABLED
    result = (result || [[CYSinaWeibo sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]);
#endif
#if CY_FACEBOOK_ENABLED
    result = (result || [[CYFacebook sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]);
#endif
    return result;
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    BOOL result = NO;
#if CY_WECHAT_ENABLED
    result = [[CYWechat sharedInstance] application:application openURL:url options:options];
#endif
#if CY_QQ_ENABLED
    result = (result || [[CYQQ sharedInstance] application:application openURL:url options:options]);
#endif
#if CY_SINA_WEIBO_ENABLED
    result = (result || [[CYSinaWeibo sharedInstance] application:application openURL:url options:options]);
#endif
#if CY_FACEBOOK_ENABLED
    result = (result || [[CYFacebook sharedInstance] application:application openURL:url options:options]);
#endif
    return result;
}

@end
