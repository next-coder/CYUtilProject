//
//  CYBaseModel.h
//  MoneyJar2
//
//  Created by Charry on 15/6/17.
//  Copyright (c) 2015年 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+CYSecureValue.h"

@interface CYBaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

+ (instancetype)modelFromDictionary:(NSDictionary *)dic;
+ (NSArray *)modelArrayFromDictionaryArray:(NSArray *)dicArray;

+ (BOOL)dictionaryIsNullOrEmpty:(NSDictionary *)dic;
+ (BOOL)arrayIsNullOrEmpty:(NSArray *)array;

@end
