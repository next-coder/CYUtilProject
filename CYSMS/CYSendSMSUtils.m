//
//  XNSendSMSUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/27/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "CYSendSMSUtils.h"

@interface CYSendSMSUtils () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, weak) MFMessageComposeViewController *messageViewController;

@end

@implementation CYSendSMSUtils

- (void)dealloc {
    
    if (_messageViewController) {
        
        _messageViewController.delegate = nil;
    }
}

- (BOOL)sendTextSMS:(nullable NSString *)text
           toMobile:(nullable NSString *)toMobile
     withCompletion:(nullable CYSendSMSCompletion)completion
        presentFrom:(nonnull UIViewController *)presentViewController {
    
    if (_sending) {
        
        return NO;
    }
    if (![CYSendSMSUtils canSendTextSMS]) {
        
        return NO;
    }
    
    _sendText = text;
    _sendToMobile = toMobile;
    _completion = completion;
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
    message.messageComposeDelegate = self;
    if (_sendToMobile) {
        
        message.recipients = @[ _sendToMobile ];
    }
    message.body = _sendText;
    if (presentViewController) {
        
        _sending = YES;
        [presentViewController presentViewController:message
                                            animated:YES
                                          completion:nil];
    }
    return YES;
}

- (BOOL)sendTextSMS:(nullable NSString *)text
          toMobiles:(nullable NSArray *)toMobiles
     withCompletion:(nullable CYSendSMSCompletion)completion
        presentFrom:(nonnull UIViewController *)presentViewController {
    
    if (_sending) {
        
        return NO;
    }
    if (![CYSendSMSUtils canSendTextSMS]) {
        
        return NO;
    }
    
    _sendText = text;
    _sendToMobiles = toMobiles;
    _completion = completion;
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
    message.messageComposeDelegate = self;
    if (_sendToMobiles) {
        
        message.recipients = _sendToMobiles;
    }
    message.body = _sendText;
    if (presentViewController) {
        
        _sending = YES;
        [presentViewController presentViewController:message
                                            animated:YES
                                          completion:nil];
        return YES;
    }
    return NO;
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    _sending = NO;
    if (_completion) {
        
        _completion((NSInteger)result, self);
        _messageViewController.delegate = nil;
        _messageViewController = nil;
        _sendText = nil;
        _sendToMobile = nil;
        _sendToMobiles = nil;
        _completion = nil;
    }
}

#pragma mark - static
+ (BOOL)canSendTextSMS {
    
    return [MFMessageComposeViewController canSendText];
}

+ (instancetype)defaultInstance {
    
    static CYSendSMSUtils *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultInstance = [[CYSendSMSUtils alloc] init];
    });
    return defaultInstance;
}

@end
