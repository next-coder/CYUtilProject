//
//  CYFacebook.m
//  CYUtilProject
//
//  Created by xn011644 on 16/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYFacebook.h"
#import "CYShareModel.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <objc/runtime.h>

@interface CYFacebook () <FBSDKSharingDelegate>


@end

@implementation CYFacebook

#pragma mark - register
- (void)registerAppId:(NSString *)appId {
    [super registerAppId:appId];

//    Faceboo
}

#pragma mark - share
// Subclass should implements this method to implement the share action
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    [self share:model
showFromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
       callback:callback];
}

- (void)share:(CYShareModel *)model
showFromViewController:(UIViewController *)viewController
     callback:(CYShareCallback)callback {
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

- (void)shareImages:(NSArray *)models
showFromViewController:(UIViewController *)viewController
     callback:(CYShareCallback)callback {
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

#pragma mark - application delegate
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

@end

@implementation CYFacebook (Login)

- (void)loginWithPermissions:(NSArray *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    [manager logInWithReadPermissions:permissions
                   fromViewController:viewController
                              handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                  dispatch_async(dispatch_get_main_queue(), ^{

                                      NSInteger statusCode = 0;
                                      NSString *msg = nil;
                                      CYLoginInfo *loginInfo = nil;
                                      if (error) {
                                          statusCode = error.code;
                                          msg = error.localizedDescription;
                                      } else if (result.isCancelled) {
                                          statusCode = -1;
                                          msg = NSLocalizedString(@"Cancelled", nil);
                                      } else {
                                          statusCode = 0;
                                          msg = NSLocalizedString(@"Success", nil);
                                          loginInfo = [[CYLoginInfo alloc] init];
                                          loginInfo.fbSDKAccessToken = result.token;
                                          self.loginInfo = loginInfo;
                                      }
                                      if (callback) {
                                          callback(statusCode, msg, loginInfo);
                                      }
                                  });
                              }];
}

@end

@implementation CYLoginInfo (Facebook)

static char CYShareSDK_CYLoginInfo_fbSDKAccessTokenKey;

@dynamic fbSDKAccessToken;

- (void)setFbSDKAccessToken:(FBSDKAccessToken *)fbSDKAccessToken {
    objc_setAssociatedObject(self, &CYShareSDK_CYLoginInfo_fbSDKAccessTokenKey, fbSDKAccessToken, OBJC_ASSOCIATION_RETAIN);

    self.accessToken = fbSDKAccessToken.tokenString;
    self.expirationDate = fbSDKAccessToken.expirationDate;
    self.userId = fbSDKAccessToken.userID;
}

- (FBSDKAccessToken *)fbSDKAccessToken {
    return objc_getAssociatedObject(self, &CYShareSDK_CYLoginInfo_fbSDKAccessTokenKey);
}

@end


