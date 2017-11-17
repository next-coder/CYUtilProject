//
//  CYShareBaseUtil.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYBaseShare.h"
#import <UIKit/UIKit.h>

@implementation CYBaseShare

#pragma mark - app info
- (void)registerAppId:(NSString *)appId {
    _appId = appId;
}

- (void)registerAppKey:(NSString *)appKey {
    _appKey = appKey;
}

- (void)registerRedirectURI:(NSString *)redirectURI {
    _redirectURI = redirectURI;
}

#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    self.shareCallback = callback;
}

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    self.shareCallback = callback;
}

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return NO;
}

#pragma mark - api
+ (BOOL)openApp {
    
    return NO;
}

+ (BOOL)appInstalled {
    
    return NO;
}

@end
