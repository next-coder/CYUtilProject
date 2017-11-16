//
//  CYAlipay.h
//  CYUtilProject
//
//  Created by xn011644 on 14/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  支付完成回调
 *
 *  @param statusCode   支付返回码，9000代表成功，具体请参考 https://docs.open.alipay.com/204/105301
 *  @param msg          返回描述性系，支付宝支付完成后，返回的字典中“memo”的值
 *  @param result       支付返回结果详细信息，支付宝支付完成后，返回的字典中“result”的值
 */

typedef void (^CYAlipayCallback)(NSInteger statusCode, NSString *msg, NSDictionary *result);

@interface CYAlipay : NSObject

/**
 *  支付宝支付
 *  @param orderString  支付宝支付订单相关信息，由服务端生成并返回， 具体格式和含义请参考： https://docs.open.alipay.com/204/105465/
 *  @param scheme       打开支付宝App支付的情况下，支付完成跳转回开发者App的scheme，需要在Info.plist中声明
 *  @param callback     支付完成回调
 */
- (void)payWithOrderString:(NSString *)orderString
                    scheme:(NSString *)scheme
                  callback:(CYAlipayCallback)callback;

/**
 * 需要在AppDelegate的application:openURL:sourceApplication:annotation: 方法中调用此方法，来处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - static instance
+ (instancetype)defaultInstance;

@end

@interface CYAlipayOrder: NSObject

@end
