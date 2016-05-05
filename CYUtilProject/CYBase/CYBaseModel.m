//
//  CYBaseModel.m
//  MoneyJar2
//
//  Created by Charry on 15/6/17.
//  Copyright (c) 2015年 Charry. All rights reserved.
//

#import "CYBaseModel.h"

@implementation CYBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [super init]) {
        
        
    }
    return self;
}

+ (instancetype)modelFromDictionary:(NSDictionary *)dic {
    
    return [[self alloc] initWithDictionary:dic];
}

+ (NSArray *)modelArrayFromDictionaryArray:(NSArray *)dicArray {
    
    if (![self arrayIsNullOrEmpty:dicArray]) {
        
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:[dicArray count]];
        for (NSDictionary *dic in dicArray) {
            
            id model = [self modelFromDictionary:dic];
            if (model) {
                
                [modelArray addObject:model];
            }
        }
        return modelArray;
    }
    return nil;
}

+ (BOOL)dictionaryIsNullOrEmpty:(NSDictionary *)dic {
    
    if (!dic
        || ![dic isKindOfClass:[NSDictionary class]]
        || [dic count] == 0) {
        
        return YES;
    }
    return NO;
}

+ (BOOL)arrayIsNullOrEmpty:(NSArray *)array {
    
    if (!array
        || ![array isKindOfClass:[NSArray class]]
        || [array count] == 0) {
        
        return YES;
    }
    return NO;
}

@end
