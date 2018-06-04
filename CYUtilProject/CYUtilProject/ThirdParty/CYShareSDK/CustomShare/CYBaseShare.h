//
//  CYShareBaseUtil.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYShareModel;
@class UIApplication;
@class UIViewController;

typedef NS_ENUM(NSInteger, CYShareErrorCode) {
    CYShareErrorCodeSuccess     = 0,    // 成功
    CYShareErrorCodeCommon      = -1,   // 普通错误类型
    CYShareErrorCodeUserCancel  = -2,   // 用户取消
    CYShareErrorCodeSentFail    = -3,   // 发送失败
    CYShareErrorCodeAuthDeny    = -4,   // 授权失败
    CYShareErrorCodeUnsupport   = -5,   // 不支持
    CYShareErrorCodeInvalidParams = -6, // 参数错误
    CYShareErrorCodeOpenAppFailed = -7, // 打开第三方app失败
};

extern NSString *CYShareErrorDomain;

typedef void (^CYShareCallback)(NSError *error);

@interface CYBaseShare : NSObject

@property (nonatomic, strong, readonly) NSString *appId;
@property (nonatomic, strong, readonly) NSString *appKey;
@property (nonatomic, strong, readonly) NSString *redirectURI;

@property (nonatomic, copy) CYShareCallback shareCallback;

#pragma mark - share
// Subclass should implements this method to implement the share action
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback;

#pragma mark - register app info
// 注册appid和appKey
// 微信和QQ必须注册Appid，微博必须注册AppKey
- (void)registerAppId:(NSString *)appId;
- (void)registerAppKey:(NSString *)appKey;
- (void)registerRedirectURI:(NSString *)redirectURI;

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary *)options;

#pragma mark - api
/**
 *  打开App
 *
 *  @return YES打开成功，NO打开失败
 */
+ (BOOL)openApp;

/*! @brief 检查App是否已被用户安装
 *
 * @return 已安装返回YES，未安装返回NO。
 */
+ (BOOL)appInstalled;

@end
