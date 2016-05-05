//
//  CYIAPUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CYIAPTransaction.h"

#define CY_IAP_COMMON_ERROR_DOMAIN   @"CYIAPCommonError"

typedef void (^CYIAPTransactionStateChangedBlock)(CYIAPTransaction *transaction);

@interface CYIAPUtils : NSObject

#pragma mark - add new pay, auto started
// 增加新支付，会自动开始支付
// 这里IAP支付的顺序执行的，即在上次支付调用finishIAPWithReceipt:之后，或者上次支付在苹果端失败后，才会进行下一次支付
// 采用顺序执行的目的是为了防止多次支付，导致支付混乱，也可防止苹果端支付中的很多问题
+ (void)addNewIAPWithProductID:(NSString *)productID
                      quantity:(NSUInteger)quantity
                additionalInfo:(NSDictionary *)additionalInfo
                  stateChanged:(CYIAPTransactionStateChangedBlock)stateChanged;

#pragma mark - finish IAP
// 票据验证完成后需要调用此方法
// 调用此方法后，会删除本地保存的支付凭据，请确认支付凭据不会再被使用后，调用此方法
// 支付结束后，必须调用此方法，清楚支付保存的中间数据
// 否则，此次支付并未完成，下一个支付请求也不会处理
// 如果支付在苹果端就失败了，即CYIAPTransaction的状态变成CYIAPTransactionStateFailed时，会自动调用此方法，开发者无需再调用此方法
// 总结下来就是，开发者需要在CYIAPTransaction的状态是CYIAPTransactionStateSuccess，且票据验证完成之后，调用此方法。其他情况无需调用
+ (void)finishIAPWithTransaction:(CYIAPTransaction *)transaction;

#pragma mark - unfinished IAP
// 未完成交易的回调，用于没有处理且成功支付的IAP
// 当IAP在苹果端支付成功，但是调用finishIAPWithReceipt:方法之前发生了中断，那么本次支付就算未完成交易。会在下次支付开始之前回调此block
+ (void)setUnfinishedIAPCallback:(CYIAPTransactionStateChangedBlock)callback;

@end
