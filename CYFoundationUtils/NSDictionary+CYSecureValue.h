//
//  NSDictionary+CYSecureValue.h
//  MoneyJar2
//
//  Created by Charry on 6/29/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CYSecureValue)

- (NSArray *)cy_arrayValueForKey:(id)key;
- (NSDictionary *)cy_dictionaryValueForKey:(NSString *)key;
- (NSString *)cy_stringValueForKey:(id)key;
- (NSNumber *)cy_numberValueForKey:(id)key;
- (NSInteger)cy_integerValueForKey:(id)key;
- (long)cy_longValueForKey:(id)key;
- (long long)cy_longLongValueForKey:(id)key;
- (float)cy_floatValueForKey:(id)key;
- (double)cy_doubleValueForKey:(id)key;
- (BOOL)cy_boolValueForKey:(id)key;

@end
