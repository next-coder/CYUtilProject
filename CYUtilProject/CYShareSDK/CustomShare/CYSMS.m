//
//  CYSMS.m
//  CYUtilProject
//
//  Created by xn011644 on 18/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYSMS.h"

#if CY_SHARE_SMS_ENABLED

#import <MessageUI/MessageUI.h>
#import "CYShareModel.h"

@interface CYSMS () <MFMessageComposeViewControllerDelegate>

@end

@implementation CYSMS

NSString *const CYSMSToUsersKey = @"CYUtil.CYShareSDK.CYSMSToUsersKey";

- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [self share:model fromViewController:viewController callback:callback];
}

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    id mobiles = [model.userInfo objectForKey:CYSMSToUsersKey];
    if ([mobiles isKindOfClass:[NSString class]]) {
        // 分享给单个手机号
        [self share:model to:mobiles fromViewController:viewController callback:callback];
    } else if ([mobiles isKindOfClass:[NSArray class]]) {
        // 分享给多个手机号
        [self share:model toMobiles:mobiles fromViewController:viewController callback:callback];
    } else {
        // 没有指定分享的手机号码
        [self share:model toMobiles:nil fromViewController:viewController callback:callback];
    }
}

- (void)share:(CYShareModel *)model to:(NSString *)mobile fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    NSArray *users = nil;
    if (mobile) {
        users = @[ mobile ];
    }

    [self share:model toMobiles:users fromViewController:viewController callback:callback];
}

- (void)share:(CYShareModel *)model toMobiles:(NSArray *)mobiles fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    if (!model.isValid) {
        if (callback) {
            callback(-1, NSLocalizedString(@"The share model is invalid!!!", nil));
        }
        return;
    }

    if (![MFMessageComposeViewController canSendText]) {
        if (callback) {
            callback(-1, NSLocalizedString(@"Message is not supported on this device!!!", nil));
        }
        return;
    }

    MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
    messageViewController.messageComposeDelegate = self;
    if (model.type == CYShareContenTypeURL
        && model.url) {

        // 分享url，把url作为信息内容的一部分发送
        if (model.content) {

            messageViewController.body = [NSString stringWithFormat:@"%@   %@", model.content, model.url];
        } else {
            messageViewController.body = model.url;
        }
    } else {

        messageViewController.body = model.content;
    }

    if ([MFMessageComposeViewController canSendAttachments]
       && model.type == CYShareContenTypeImage) {
        // 分享图片，把图片作为信息附件发送
        if (model.data) {

            [messageViewController addAttachmentData:model.data
                                      typeIdentifier:@"public.image"
                                            filename:model.title];
        } else if (model.url) {
            [messageViewController addAttachmentURL:[NSURL URLWithString:model.url]
                              withAlternateFilename:NSLocalizedString(@"Image", nil)];
        }
    }
    if (mobiles) {
        messageViewController.recipients = mobiles;
    }

    [viewController presentViewController:messageViewController
                                 animated:YES
                               completion:nil];
    self.shareCallback = callback;
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (self.shareCallback) {

        self.shareCallback(result == MessageComposeResultSent ? 0 : -1,
                           nil);
    }
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {

    static CYSMS *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        util = [[self alloc] init];
    });
    return util;
}

@end

#endif