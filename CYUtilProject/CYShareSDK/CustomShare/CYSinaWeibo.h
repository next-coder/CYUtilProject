//
//  CYSinaWeiboShareUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_SINA_WEIBO_ENABLED
#import "CYBaseShare.h"

@class CYShareModel;
@class CYSinaWeiboLoginInfo;

/**
 * 分享到微博
 *
 * 此类采用单例模式，请直接使用sharedInstance，不要创建新实例
 */
@interface CYSinaWeibo : CYBaseShare

/**
 * 分享到微博
 * 分享网页时，建议以文本的形式分享，把网页链接拼接到文本中
 */
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

#pragma mark - handle open
/**
 * 需要在AppDelegate的- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 方法中调用此方法，来处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - static
+ (instancetype)sharedInstance;

@end

#pragma mark - login

typedef void (^CYSinaWeiboLoginCallback)(NSInteger errorCode, NSString *msg, CYSinaWeiboLoginInfo *loginInfo);

@interface CYSinaWeibo (Login)

@property (nonatomic, strong, readonly) CYSinaWeiboLoginInfo *loginInfo;

@end

@interface CYSinaWeiboLoginInfo: NSObject

// 用户ID
@property (nonatomic, copy) NSString *userId;
// 认证口令
@property (nonatomic, copy) NSString *accessToken;
// 认证过期时间
@property (nonatomic, strong) NSDate *expirationDate;
// 当认证口令过期时用于换取认证口令的更新口令
@property (nonatomic, strong) NSString *refreshToken;

@end

#endif
