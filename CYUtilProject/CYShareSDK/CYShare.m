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

#if CY_SHARE_WECHAT_ENABLED
+ (void)registerWechatAppId:(NSString *)appId {
    [[CYWechat sharedInstance] registerWithAppId:appId];
}

+ (void)shareToWechat:(CYShareModel *)model
                scene:(CYWechatScene)scene
             callback:(CYShareCallback)callback {

    [[CYWechat sharedInstance] share:model
                                  to:scene
                            callback:callback];
}

+ (void)shareToWechat:(CYShareModel *)model
 presentActionSheetFrom:(UIViewController *)viewController
             callback:(CYShareCallback)callback {

    [[CYWechat sharedInstance] share:model
              presentActionSheetFrom:viewController
                            callback:callback];
}
#endif

#if CY_SHARE_QQ_ENABLED
+ (void)registerQQAppId:(NSString *)appId {
    [[CYQQ sharedInstance] registerWithAppId:appId];
}

+ (void)shareToQQ:(CYShareModel *)model
         ctrlFlag:(CYQQAPICtrlFlag)flag
         callback:(CYShareCallback)callback {
    [[CYQQ sharedInstance] share:model
                              to:flag
                        callback:callback];
}

+ (void)shareToQQ:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
         callback:(CYShareCallback)callback {

    [[CYQQ sharedInstance] share:model
          presentActionSheetFrom:viewController
                        callback:callback];
}
#endif

#if CY_SHARE_SINA_WEIBO_ENABLED
+ (void)registerWeiboAppKey:(NSString *)appKey {
    [[CYSinaWeibo sharedInstance] registerWithAppId:appKey];
}

+ (void)shareToWeibo:(CYShareModel *)model
            callback:(CYShareCallback)callback {
    [[CYSinaWeibo sharedInstance] share:model
                               callback:callback];
}
#endif

+ (BOOL)handleOpenURL:(NSURL *)URL {
    BOOL result = NO;
#if CY_SHARE_WECHAT_ENABLED
    result = [[CYWechat sharedInstance] handleOpenURL:URL];
#endif
#if CY_SHARE_QQ_ENABLED
    result = (result || [[CYQQ sharedInstance] handleOpenURL:URL]);
#endif
#if CY_SHARE_SINA_WEIBO_ENABLED
    result = (result || [[CYSinaWeibo sharedInstance] handleOpenURL:URL]);
#endif
    return result;
}

@end
