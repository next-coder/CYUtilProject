//
//  CYShare.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYShareCtrlFlag.h"

#if CY_SHARE_WECHAT_ENABLED
#import "CYWechat.h"
#endif

#if CY_SHARE_QQ_ENABLED
#import "CYQQ.h"
#endif

#if CY_SHARE_SINA_WEIBO_ENABLED
#import "CYSinaWeibo.h"
#endif

#if CY_SHARE_APPLE_ACTIVITY_ENABLED
#import "CYAppleActivity.h"
#endif

#if CY_SHARE_SMS_ENABLED
#import "CYSMS.h"
#endif

#import "CYShareModel.h"

@interface CYShare : NSObject

#if CY_SHARE_WECHAT_ENABLED
+ (void)registerWechatAppId:(NSString *)appId;

+ (void)shareToWechat:(CYShareModel *)model
                scene:(CYWechatScene)scene
             callback:(CYShareCallback)callback;

+ (void)shareToWechat:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
             callback:(CYShareCallback)callback;
#endif

#if CY_SHARE_QQ_ENABLED
+ (void)registerQQAppId:(NSString *)appId;

+ (void)shareToQQ:(CYShareModel *)model
         ctrlFlag:(CYQQAPICtrlFlag)flag
         callback:(CYShareCallback)callback;

+ (void)shareToQQ:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
         callback:(CYShareCallback)callback;
#endif

#if CY_SHARE_SINA_WEIBO_ENABLED
+ (void)registerWeiboAppKey:(NSString *)appKey;

+ (void)shareToWeibo:(CYShareModel *)model
            callback:(CYShareCallback)callback;
#endif

#if CY_SHARE_APPLE_ACTIVITY_ENABLED

+ (void)shareByAppleActivity:(CYShareModel *)model
                 presentFrom:(UIViewController *)viewController
                    callback:(CYShareCallback)callback;

#endif

#if CY_SHARE_SMS_ENABLED

/**
 短信分享，可以发送文本和链接，链接会拼接在文本最后面发送

 目前暂不支持图片分享

 */
+ (void)shareBySMS:(CYShareModel *)model
                to:(NSArray *)mobiles
       presentFrom:(UIViewController *)viewController
          callback:(CYShareCallback)callback;

#endif

/**
 * 需要在AppDelegate的- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 方法中调用此方法，来处理结果
 */
+ (BOOL)handleOpenURL:(NSURL *)URL;

@end
