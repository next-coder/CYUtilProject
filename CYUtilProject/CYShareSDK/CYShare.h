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
/**
 *  微信注册，appId和appKey为微信开放平台注册之后，微信分配给第三方的appId和appKey
 */
+ (void)registerWechatAppId:(NSString *)appId;
+ (void)registerWechatAppKey:(NSString *)appKey;

/**
 *  微信分享，由开发者指定分享给好友或者分享到朋友圈
 */
+ (void)shareToWechat:(CYShareModel *)model
                scene:(CYWechatScene)scene
             callback:(CYShareCallback)callback;

/**
 *  微信分享，弹出ActionSheet，由用户选择分享给好友或者分享到朋友圈
 */
+ (void)shareToWechat:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
             callback:(CYShareCallback)callback;
#endif

#if CY_SHARE_QQ_ENABLED
/**
 *  qq注册，appId和appKey为qq互联平台注册之后，qq分配给第三方的appId和appKey
 */
+ (void)registerQQAppId:(NSString *)appId;
+ (void)registerQQAppKey:(NSString *)appKey;

/**
 *  qq分享，由开发者指定分享给好友或者分享到qq空间
 */
+ (void)shareToQQ:(CYShareModel *)model
         ctrlFlag:(CYQQAPICtrlFlag)flag
         callback:(CYShareCallback)callback;

/**
 *  qq分享，弹出ActionSheet，由用户选择分享给好友或者分享到qq空间
 */
+ (void)shareToQQ:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
         callback:(CYShareCallback)callback;
#endif

#if CY_SHARE_SINA_WEIBO_ENABLED
/**
 *  新浪微博注册，appKey为微博开放平台注册之后，微博分配给第三方的AppKey
 */
+ (void)registerWeiboAppKey:(NSString *)appKey;

/**
 * 分享到微博
 * 分享网页时，建议以文本的形式分享，把网页链接拼接到文本中
 */
+ (void)shareToWeibo:(CYShareModel *)model
            callback:(CYShareCallback)callback;
#endif

#if CY_SHARE_APPLE_ACTIVITY_ENABLED

/**
 通过iOS系统提供的UIActivityViewController来分享

 可以分享文字、链接和图片
 包含文字时，请设置model.content属性

 */
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
