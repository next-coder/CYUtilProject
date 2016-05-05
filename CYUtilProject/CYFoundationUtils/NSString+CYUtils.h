//
//  NSString+XNExtension.h
//  MoneyJar2
//
//  Created by Charry on 6/29/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CYUtils)

+ (BOOL)cy_stringIsEmptyOrNull:(NSString *)str;
+ (BOOL)cy_compare:(NSString *)string1 withString:(NSString *)string2;

- (BOOL)cy_containsString:(NSString *)aString;

// 本地化
- (NSString *)cy_localizedStringWithComment:(NSString *)comment;

@end
