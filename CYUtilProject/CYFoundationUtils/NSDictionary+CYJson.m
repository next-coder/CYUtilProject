//
//  NSDictionary+CYJson.m
//  MoneyJar2
//
//  Created by Charry on 7/6/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "NSDictionary+CYJson.h"

@implementation NSDictionary (CYJson)

- (NSString *)cy_jsonString {
    
    NSData *data = [self cy_jsonData];
    if (data) {
        
        NSString *jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    } else {
        
        return nil;
    }
}

- (NSData *)cy_jsonData {
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    if (!error) {
        
        return data;
    } else {
        
//        CYDLog(@"parse json error : %@", error);
        return nil;
    }
}

+ (NSDictionary *)cy_dictionaryFromJsonString:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self cy_dictionaryFromJsonData:jsonData];
}

+ (NSDictionary *)cy_dictionaryFromJsonData:(NSData *)jsonData {
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:0
                                                      error:&error];
    if (!error
        && [jsonObject isKindOfClass:[self class]]) {
        
        return jsonObject;
    } else {
        
//        CYDLog(@"parse json error : %@", error);
        return nil;
    }

}

@end
