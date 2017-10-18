//
//  XNWechatUtil.h
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_WECHAT_ENABLED

#import <UIKit/UIKit.h>
#import "CYBaseShare.h"

@class CYShareModel;

typedef NS_ENUM(int, CYWechatScene) {

    CYWechatSceneSession = 0, // 聊天界面
    CYWechatSceneTimeline = 1, // 朋友圈
    CYWechatSceneFavorite = 2, // 收藏
};

// 此类采用单例模式，请直接使用sharedInstance，不要创建新实例
@interface CYWechat : CYBaseShare <UIActionSheetDelegate>

extern NSString *const CYWechatSceneKey;

///**
// *  微信登陆
// *
// *  @param from     没有安装微信时，用于web登陆present
// *  @param callback 登陆回调
// */
//- (void)loginFrom:(UIViewController *)from
//         callback:(CYThirdPartyLoginCallback)callback;

#pragma mark - share
/**
 *
 * 如果使用此方法分享，model的userInfo属性可以包含key 为CYWechatSceneKey，值为CYWechatScene中的一个，
 * 用于标识分享的目标，如果未包含，则调用share:presentActionSheetFrom:callback:进行分享
 *
 */
- (void)share:(CYShareModel *)model callback:(CYShareCallback)callback;

/**
 *
 * 使用此方法分享，让用户选择分享到朋友圈或者微信好友
 *
 */
- (void)share:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

/**
 * 分享到微信朋友圈
 *
 * @param model  待分享的内容
 * @param callback 分享完成后回调
 *
 */
- (void)shareToTimeline:(CYShareModel *)model
               callback:(CYShareCallback)callback;

/**
 * 分享给微信好友
 *
 * @param model  待分享的内容
 * @param callback 分享完成后回调
 *
 */
- (void)shareToSession:(CYShareModel *)model
              callback:(CYShareCallback)callback;

/**
 * 分享到微信，指定微信的scene
 *
 */
- (void)share:(CYShareModel *)model
           to:(CYWechatScene)scene
     callback:(CYShareCallback)callback;

#pragma mark - handle open url
/**
 * 需要在AppDelegate的- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 方法中调用此方法，来处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - static single
+ (instancetype)sharedInstance;

@end

#endif

