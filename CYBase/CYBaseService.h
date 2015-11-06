//
//  CYBaseService.h
//  MoneyJar2
//
//  Created by Charry on 15/6/17.
//  Copyright (c) 2015年 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYResponseStatusModel;
@class CYPageEnabledModel;

typedef void (^CYResponseCompletion)(CYResponseStatusModel *status,
                                     NSError *error);
typedef void (^CYArrayResponseCompletion)(CYResponseStatusModel *status,
                                          NSArray *result,
                                          NSError *error);
typedef void (^CYArrayWithPageResponseCompletion)(CYResponseStatusModel *status,
                                                  CYPageEnabledModel *pageEnabledModel,
                                                  NSArray *result,
                                                  NSError *error);
typedef void (^CYObjectResponseCompletion)(CYResponseStatusModel *status,
                                           id result,
                                           NSError *error);
typedef void (^CYIntegerResponseCompletion)(CYResponseStatusModel *status,
                                            NSInteger result,
                                            NSError *error);
typedef void (^CYDoubleResponseCompletion)(CYResponseStatusModel *status,
                                          double result,
                                          NSError *error);
typedef void (^CYBooleanResponseCompletion)(CYResponseStatusModel *status,
                                            BOOL result,
                                            NSError *error);

@interface CYBaseService : NSObject

+ (NSDictionary *)commonRequestParameters;

/**
 *  解析返回数据的状态信息
 *
 *  @param response 请求收到的返回数据
 *
 *  @return 解析后的状态model
 */
+ (CYResponseStatusModel *)responseStatusWithResponse:(NSDictionary *)response;

@end
