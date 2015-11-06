//
//  NSDictionary+CYSecureValue.m
//  MoneyJar2
//
//  Created by Charry on 6/29/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "NSDictionary+CYSecureValue.h"

@implementation NSDictionary (CYSecureValue)

- (NSArray *)cy_arrayValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        
        return value;
    } else {
        
        return nil;
    }
}

- (NSDictionary *)cy_dictionaryValueForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        
        return value;
    } else {
        
        return nil;
    }
}

- (NSString *)cy_stringValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        
        return [value stringValue];
    } else {
        
        return nil;
    }
}

- (NSNumber *)cy_numberValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        
        return value;
    } else {
        
        return nil;
    }
}

- (NSInteger)cy_integerValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(integerValue)]) {
        
        return [value integerValue];
    } else {
        
        return 0;
    }
}

- (long)cy_longValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(longValue)]) {
        
        return [value longValue];
    } else {
        
        return 0;
    }

}

- (long long)cy_longLongValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(longLongValue)]) {
        
        return [value longLongValue];
    } else {
        
        return 0;
    }
}

- (float)cy_floatValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(floatValue)]) {
        
        return [value floatValue];;
    } else {
        
        return 0;
    }
}

- (double)cy_doubleValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(doubleValue)]) {
        
        return [value doubleValue];
    } else {
        
        return 0;
    }
}

- (BOOL)cy_boolValueForKey:(id)key {
    
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(boolValue)]) {
        
        return [value boolValue];
    } else {
        
        return 0;
    }
}

@end
