//
//  NSArray+CYJson.h
//  MoneyJar2
//
//  Created by Charry on 7/6/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CYJson)

- (NSString *)cy_jsonString;
- (NSData *)cy_jsonData;

+ (NSArray *)cy_arrayFromJsonString:(NSString *)jsonString;
+ (NSArray *)cy_arrayFromJsonData:(NSData *)jsonData;

@end
