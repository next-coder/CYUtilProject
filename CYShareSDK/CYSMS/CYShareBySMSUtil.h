//
//  CYShareBySMSUtil.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/25/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareBaseUtil.h"

typedef NS_ENUM(NSInteger, CYShareBySMSResultCode) {
    
    CYShareBySMSResultCodeSent,
    CYShareBySMSResultCodeCancelled,
    CYShareBySMSResultCodeFailed,
};

@interface CYShareBySMSUtil : CYShareBaseUtil

/**
 *  发送短信给单个用户
 *
 *  @param text         短信内容
 *  @param mobile       接受短信的用户，为空时，则收件人栏为空
 *  @param UIViewController  需要present短信页面的UIViewController
 *
 */
- (void)shareText:(NSString *)text
         toMobile:(NSString *)mobile
      presentFrom:(UIViewController *)presentViewController
         callback:(CYShareCallback)callback;

/**
 *  发送短信给多个用户
 *
 *  @param text         短信内容
 *  @param mobiles      接受短信的用户，手机号的String数组，为空时，则收件人栏为空
 *  @param UIViewController  需要present短信页面的UIViewController
 *
 */
- (void)shareText:(NSString *)text
        toMobiles:(NSArray *)mobiles
      presentFrom:(UIViewController *)presentViewController
         callback:(CYShareCallback)callback;

#pragma mark - static
+ (instancetype)sharedInstance;
+ (BOOL)canSendTextSMS;

@end
