//
//  XNSendSMSUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/27/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYSendSMSUtils;

typedef NS_ENUM(NSInteger, CYSendSMSCompletionStatus) {
    
    CYSendSMSCompletionStatusCancelled,
    CYSendSMSCompletionStatusSent,
    CYSendSMSCompletionStatusFailed,
};
typedef void (^CYSendSMSCompletion)(CYSendSMSCompletionStatus status,  CYSendSMSUtils * _Nonnull sendSMSUtils);

@interface CYSendSMSUtils : NSObject

@property (nonatomic, assign, readonly) BOOL sending;
@property (nullable, nonatomic, copy, readonly) CYSendSMSCompletion completion;
@property (nullable, nonatomic, strong, readonly) NSString *sendText;
@property (nullable, nonatomic, strong, readonly) NSString *sendToMobile;
@property (nullable, nonatomic, strong, readonly) NSArray *sendToMobiles;

// 发送短信给单个人
- (BOOL)sendTextSMS:(nullable NSString *)text
           toMobile:(nullable NSString *)toMobile
     withCompletion:(nullable CYSendSMSCompletion)completion
        presentFrom:(nonnull UIViewController *)presentViewController;
// 发送短信给多个人，手机号以NSString数组形式传入
- (BOOL)sendTextSMS:(nullable NSString *)text
          toMobiles:(nullable NSArray *)toMobiles
     withCompletion:(nullable CYSendSMSCompletion)completion
        presentFrom:(nonnull UIViewController *)presentViewController;

// 判断是否支持短信
+ (BOOL)canSendTextSMS;
// 获取默认实例
+ (nonnull instancetype)defaultInstance;

@end
