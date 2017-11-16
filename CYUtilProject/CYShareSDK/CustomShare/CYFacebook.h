//
//  CYFacebook.h
//  CYUtilProject
//
//  Created by xn011644 on 16/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYBaseShare.h"

@class UIViewController;
@class UIApplication;

@interface CYFacebook : CYBaseShare


/**
 * 分享到Facebook
 * 弹出Facebook dialog进行分享，仅支持链接和图片分享
 * 链接分享时，model中的content和url有效
 * 图片分享时，model中的url和data有效
 *
 */
- (void)share:(CYShareModel *)model
showFromViewController:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

/**
 * 分享多张图片到Facebook
 * 弹出Facebook dialog进行分享
 * models中类型为CYShareContentImage的model有效，其他忽略
 * model中的url和data有效，其他字段均忽略
 *
 */
- (void)shareImages:(NSArray *)models
showFromViewController:(UIViewController *)viewController
           callback:(CYShareCallback)callback;

#pragma mark - application delegate
/**
 * FacebookSDK application 代理方法，需要在AppDelegate对应的方法中调用
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *  FacebookSDK application 代理方法，需要在AppDelegate对应的方法中调用
 * 如果是iOS10以后的系统，可以采用以下方式来调用
 * [[FBSDKApplicationDelegate sharedInstance] application:application
 openURL:url
 sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
 annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
 ]
 *
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@end

@interface CYFacebook (Login)

- (void)loginWithPermissions:(NSArray *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback;

@end

@class FBSDKAccessToken;
@interface CYLoginInfo (Facebook)

// FacebookSDK中的accessToken结构，包含详细的登录信息
// 如果开发者需要更多登录信息，可以使用此属性来获取，使用时请先#import <FBSDKCoreKit/FBSDKCoreKit.h>
@property (nonatomic, strong) FBSDKAccessToken *fbSDKAccessToken;

@end
