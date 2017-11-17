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
            callback(-1, @"The share model is invalid!!!");
        }
        return ;
    } else if (model.type == CYShareContenTypeText) {
        if (callback) {
            callback(-2, @"Facebook cannot share text only!!!");
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
            callback(-1, @"The models cannot be empty");
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
        self.shareCallback(0, NSLocalizedString(@"Success", nil));
        self.shareCallback = nil;
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (self.shareCallback) {
        self.shareCallback(error.code, error.localizedDescription);
        self.shareCallback = nil;
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (self.shareCallback) {
        self.shareCallback(-1, NSLocalizedString(@"Cancelled", nil));
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


