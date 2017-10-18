//
//  CYQQUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_QQ_ENABLED
#import "CYBaseShare.h"

@class CYShareModel;
@class UIViewController;

typedef NS_ENUM(uint64_t, CYQQAPICtrlFlag) {
    CYQQAPICtrlFlagQZoneShareOnStart = 0x01, // QZone
    CYQQAPICtrlFlagQZoneShareForbid = 0x02,
    CYQQAPICtrlFlagQQShare = 0x04,  // qq好友
    CYQQAPICtrlFlagQQShareFavorites = 0x08, //收藏
    CYQQAPICtrlFlagQQShareDataline = 0x10 //数据线
};

// 此类采用单例模式，请直接使用sharedInstance，不要创建新实例
@interface CYQQ : CYBaseShare

extern NSString *const CYQQAPICtrlFlagKey;

#pragma mark - share url
/**
 * 如果使用此方法分享，model的userInfo属性可以包含key 为CYWechatSceneKey，值为CYWechatScene中的一个，
 * 用于标识分享的目标，如果未包含，则调用share:presentActionSheetFrom:callback:进行分享
 */
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

/**
 * 分享到QQ
 * 弹出ActionSheet，让用户选择分享到QQ好友或者QQ空间
 *
 */
- (void)share:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

/**
 * 分享给QQ好友
 *
 */
- (void)shareToQQ:(CYShareModel *)model
         callback:(CYShareCallback)callback;

/**
 * 分享到QQ空间
 *
 */
- (void)shareToQZone:(CYShareModel *)model
            callback:(CYShareCallback)callback;


/**
 * 分享到制定的QQ目标
 *
 */
- (void)share:(CYShareModel *)model
           to:(CYQQAPICtrlFlag)flag
     callback:(CYShareCallback)callback;


#pragma mark - handle open
/**
 * 需要在AppDelegate的- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 方法中调用此方法，来处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end
#endif
