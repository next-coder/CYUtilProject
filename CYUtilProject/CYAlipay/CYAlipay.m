//
//  CYAlipay.m
//  CYUtilProject
//
//  Created by xn011644 on 14/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYAlipay.h"

#import <AlipaySDK/AlipaySDK.h>

@interface CYAlipay()

@property (nonatomic, copy) CYAlipayCallback callback;

@end

@implementation CYAlipay

- (void)payWithOrderString:(NSString *)orderString
                    scheme:(NSString *)scheme
                  callback:(CYAlipayCallback)callback {
    self.callback = callback;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
        [self processPayResult:resultDic];
    }];
}

- (void)processPayResult:(NSDictionary *)resultDic {
    if (self.callback) {
        NSInteger statusCode = [resultDic[@"resultStatus"] integerValue];
        NSString *memo = resultDic[@"memo"];
        NSDictionary *result = resultDic[@"result"];
        self.callback(statusCode, memo, result);
    }
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    if ([URL.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:URL standbyCallback:^(NSDictionary *resultDic) {
            [self processPayResult:resultDic];
        }];
        return YES;
    }
    return NO;
}

#pragma mark - static instance
+ (instancetype)defaultInstance {
    static CYAlipay *alipay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alipay = [[CYAlipay alloc] init];
    });
    return alipay;
}

@end
