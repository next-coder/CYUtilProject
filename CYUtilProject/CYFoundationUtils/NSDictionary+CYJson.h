//
//  NSDictionary+CYJson.h
//  MoneyJar2
//
//  Created by Charry on 7/6/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CYJson)

- (NSString *)cy_jsonString;
- (NSData *)cy_jsonData;

+ (NSDictionary *)cy_dictionaryFromJsonString:(NSString *)jsonString;
+ (NSDictionary *)cy_dictionaryFromJsonData:(NSData *)jsonData;

@end
