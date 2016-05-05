//
//  CYShareBySMSUtil.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/25/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "CYShareBySMSUtil.h"

@interface CYShareBySMSUtil () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, copy) CYShareCallback shareCallback;
@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;

@end

@implementation CYShareBySMSUtil

- (void)shareText:(NSString *)text
         toMobile:(NSString *)mobile
      presentFrom:(UIViewController *)presentViewController
         callback:(CYShareCallback)callback {
    
    [self shareText:text
          toMobiles:(mobile ? @[ mobile ] : nil)
        presentFrom:presentViewController
           callback:callback];
}

- (void)shareText:(NSString *)text
        toMobiles:(NSArray *)mobiles
      presentFrom:(UIViewController *)presentViewController
         callback:(CYShareCallback)callback {
    
    if (![CYShareBySMSUtil canSendTextSMS]) {
        
        if (callback) {
            callback(CYShareBySMSResultCodeFailed, NSLocalizedString(@"发送失败", nil));
        }
        return;
    }
    
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
    message.messageComposeDelegate = self;
    if (mobiles) {
        
        message.recipients = mobiles;
    }
    message.body = text;
    if (presentViewController) {
        
        // iOS7，短信页面下有一黑条
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            
            self.navigationBarBackgroundImage = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }
        [presentViewController presentViewController:message
                                            animated:YES
                                          completion:nil];
    }
    
    self.shareCallback = callback;
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    // iOS7，短信页面下有一黑条
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        
        [[UINavigationBar appearance] setBackgroundImage:self.navigationBarBackgroundImage
                                           forBarMetrics:UIBarMetricsDefault];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (self.shareCallback) {
        
        NSString *tips = nil;
        CYShareBySMSResultCode code = 0;
        if (result == MessageComposeResultSent) {
            
            tips = NSLocalizedString(@"发送成功", nil);
            code = CYShareBySMSResultCodeSent;
        } else if (result == MessageComposeResultCancelled) {
            
            tips = NSLocalizedString(@"用户取消", nil);
            code = CYShareBySMSResultCodeCancelled;
        } else if (result == MessageComposeResultFailed) {
            
            tips = NSLocalizedString(@"发送失败", nil);
            code = CYShareBySMSResultCodeFailed;
        }
        self.shareCallback(code, tips);
    }
}

#pragma mark - static
+ (instancetype)sharedInstance {
    
    static CYShareBySMSUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYShareBySMSUtil alloc] init];
    });
    return util;
}

+ (BOOL)canSendTextSMS {
    
    return [MFMessageComposeViewController canSendText];
}

@end
