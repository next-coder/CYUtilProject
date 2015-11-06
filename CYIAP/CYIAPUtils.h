//
//  CYIAPUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CY_IAP_COMMON_ERROR_DOMAIN   @"CYIAPCommonError"

@class CYIAPUtils;

@protocol CYIAPUtilsDelegate <NSObject>

@optional
- (void)IAPPayDidStart:(CYIAPUtils *)utils;
- (void)IAPPayDidFinishedWithReceipt:(NSString *)receipt
                      additionalInfo:(NSString *)additionalInfo;
- (void)IAPPayDidFailedWithError:(NSError *)error;

@end

@interface CYIAPUtils : NSObject

@property (nonatomic, weak) id<CYIAPUtilsDelegate> delegate;

// 额外信息，支付完成后，会通过delegate方法回传
@property (nonatomic, strong, readonly) NSString *additionalInfo;
@property (nonatomic, strong, readonly) NSString *productId;
@property (nonatomic, assign, readonly) NSUInteger amount;

@property (nonatomic, assign, readonly) BOOL haveIncompletePay;
@property (nonatomic, assign, readonly) BOOL havePayWaiting;
@property (nonatomic, assign, readonly) BOOL isPaying;

#pragma mark - pay
// 开始支付，返回结果，0支付中，-1参数错误，1有其他支付正在进行，2在支付等待，3有未完成交易
- (NSInteger)startIAPPayWithProductId:(NSString *)productId
                               amount:(NSUInteger)amount
                       additionalInfo:(NSString *)additionalInfo;

#pragma mark - 未完成交易
- (void)startIAPIncompletePay;

#pragma mark - 支付等待
- (void)startIAPPayWaiting;

#pragma mark - end pay
// 完成支付，调用此方法后，会删除本地保存的支付凭据，请确认支付凭据不会在被使用后，调用此方法
// 支付结束后，必须调用此方法，清楚支付中间数据，才能进行下一次支付
// 否则，此次支付并未完成，无法进行新支付
- (void)finishAllPayingSteps;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end
