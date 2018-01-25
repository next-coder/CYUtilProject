//
//  CYFacebook.m
//  CYUtilProject
//
//  Created by xn011644 on 16/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYFacebook.h"

#if CY_FACEBOOK_ENABLED

#import "CYShareModel.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface CYFacebook () <FBSDKSharingDelegate>

@end

@implementation CYFacebook

#pragma mark - share
// Subclass should implements this method to implement the share action
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [self share:model fromViewController:viewController callback:callback];
}

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    if (!model.isValid) {
        if (callback) {
            NSError *error = [NSError errorWithDomain:CYShareErrorDomain
                                                 code:CYShareErrorCodeInvalidParams
                                             userInfo:@{ @"msg": NSLocalizedString(@"参数错误", nil) }];
            callback(error);
        }
        return ;
    } else if (model.type == CYShareContenTypeText) {
        if (callback) {
            NSError *error = [NSError errorWithDomain:CYShareErrorDomain
                                                 code:CYShareErrorCodeInvalidParams
                                             userInfo:@{ @"msg": NSLocalizedString(@"Facebook不支持仅分享文本", nil) }];
            callback(error);
        }
        return ;
    }

    self.shareCallback = callback;

    id<FBSDKSharingContent> content = nil;
    switch (model.type) {
        case CYShareContenTypeURL: {

            FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
            linkContent.contentURL = [NSURL URLWithString:model.url];
            linkContent.quote = model.content;
            content = linkContent;
            break;
        }

        case CYShareContenTypeImage: {
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
            if (model.data) {
                photo.image = [UIImage imageWithData:model.data];
            } else if (model.url) {
                photo.imageURL = [[NSURL alloc] initWithString:model.url];
            }
            photo.userGenerated = YES;

            FBSDKSharePhotoContent *photoContent = [[FBSDKSharePhotoContent alloc] init];
            photoContent.photos = @[ photo ];
            content = photoContent;
            break;
        }

        default:
            break;
    }

    [FBSDKShareDialog showFromViewController:viewController
                                 withContent:content
                                    delegate:self];
}

- (void)shareImages:(NSArray *)models fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    if (models.count == 0) {
        if (callback) {
            NSError *error = [NSError errorWithDomain:CYShareErrorDomain
                                                 code:CYShareErrorCodeInvalidParams
                                             userInfo:@{ @"msg": NSLocalizedString(@"参数为空", nil) }];
            callback(error);
        }
        return;
    }
    self.shareCallback = callback;

    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:models.count];
    for (CYShareModel *model in models) {
        if (model.type != CYShareContenTypeImage) {
            // 跳过非Image类型的model
            continue;
        }
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        if (model.data) {
            photo.image = [UIImage imageWithData:model.data];
        } else if (model.url) {
            photo.imageURL = [[NSURL alloc] initWithString:model.url];
        }
        photo.userGenerated = YES;
        [photos addObject:photo];
    }

    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = photos;
    [FBSDKShareDialog showFromViewController:viewController
                                 withContent:content
                                    delegate:self];
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (self.shareCallback) {
        self.shareCallback(nil);
        self.shareCallback = nil;
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (self.shareCallback) {
        NSError *error1 = [NSError errorWithDomain:CYShareErrorDomain
                                              code:CYShareErrorCodeCommon
                                          userInfo:@{ @"msg": NSLocalizedString(@"分享失败", nil), @"sourceError": error ? : @"" }];
        self.shareCallback(error1);
        self.shareCallback = nil;
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (self.shareCallback) {
        NSError *error = [NSError errorWithDomain:CYShareErrorDomain
                                             code:CYShareErrorCodeUserCancel
                                         userInfo:@{ @"msg": NSLocalizedString(@"用户取消", nil) }];
        self.shareCallback(error);
        self.shareCallback = nil;
    }
}

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
}

#pragma mark - static
+ (instancetype)sharedInstance {

    static CYFacebook *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        util = [[CYFacebook alloc] init];
    });
    return util;
}

+ (BOOL)appInstalled {

    return NO;
}

+ (BOOL)openApp {

    return NO;
}

@end

#endif


