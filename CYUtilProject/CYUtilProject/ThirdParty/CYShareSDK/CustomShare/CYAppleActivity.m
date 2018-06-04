//
//  CYAppleSocial.m
//  CYUtilProject
//
//  Created by xn011644 on 18/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYAppleActivity.h"

#if CY_SHARE_APPLE_ACTIVITY_ENABLED
#import "CYShareModel.h"

#import <UIKit/UIKit.h>

@implementation CYAppleActivity

- (void)share:(CYShareModel *)model callback:(CYShareCallback)callback {
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
        return;
    }

    NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
    if (model.content) {
        [activityItems addObject:model.content];
    }
    switch (model.type) {
        case CYShareContenTypeText: {
            break;
        }

        case CYShareContenTypeURL: {
            NSURL *url = [NSURL URLWithString:model.url];
            if (url) {
                [activityItems addObject:url];
            }
            break;
        }

        case CYShareContenTypeImage: {
            UIImage *image = [UIImage imageWithData:model.data];
            if (image) {
                [activityItems addObject:image];
            }
            break;
        }
    }

    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                  applicationActivities:nil];
    [shareController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (callback) {
            NSError *error = nil;
            if (activityError) {
                error = [NSError errorWithDomain:CYShareErrorDomain
                                            code:CYShareErrorCodeCommon
                                        userInfo:@{ @"msg": NSLocalizedString(@"分享失败", nil), @"sourceError": activityError }];
            }
            callback(error);
        }
    }];
    [viewController presentViewController:shareController animated:YES completion:nil];
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {

    static CYAppleActivity *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        util = [[self alloc] init];
    });
    return util;
}

@end

#endif
