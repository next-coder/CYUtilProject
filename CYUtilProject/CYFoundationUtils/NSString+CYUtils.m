//
//  NSString+XNExtension.m
//  MoneyJar2
//
//  Created by Charry on 6/29/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "NSString+CYUtils.h"

@implementation NSString (CYUtils)

+ (BOOL)cy_stringIsEmptyOrNull:(NSString *)str {
    
    if (!str
        || (NSNull *)str == [NSNull null]
        || [str isEqualToString:@""]) {
        
        return YES;
    }
    return NO;
}

+ (BOOL)cy_compare:(NSString *)string1 withString:(NSString *)string2 {
    
    if (!string1
        && !string2) {
        
        return YES;
    }
    if (string1
        && string2
        && [string1 isEqualToString:string2]) {
        
        return YES;
    }
    return NO;
}

- (BOOL)cy_containsString:(NSString *)aString {
    
    NSRange containsRange = [self rangeOfString:aString options:0];
    return (containsRange.location != NSNotFound);
}

- (NSString *)cy_localizedStringWithComment:(NSString *)comment {
    
    return NSLocalizedString(self, comment);
}

@end
