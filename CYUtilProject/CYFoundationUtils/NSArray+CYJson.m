//
//  NSArray+CYJson.m
//  MoneyJar2
//
//  Created by Charry on 7/6/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "NSArray+CYJson.h"

@implementation NSArray (CYJson)

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

        return nil;
    }
}

// create array from json string
+ (NSArray *)cy_arrayFromJsonString:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self cy_arrayFromJsonData:jsonData];
}

// create array from json Data
+ (NSArray *)cy_arrayFromJsonData:(NSData *)jsonData {
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:0
                                                      error:&error];
    if (!error
        && [jsonObject isKindOfClass:[self class]]) {
        
        return jsonObject;
    } else {
        
        return nil;
    }
    
}

#pragma mark - writeToFile
// write to file as json string
- (BOOL)cy_writeToFileAsJson:(NSString *)filePath automically:(BOOL)useAuxiliaryFile {

    return [self cy_writeToFileAsJson:filePath
                           atomically:useAuxiliaryFile
                                error:nil];
}

- (BOOL)cy_writeToFileAsJson:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile error:(NSError **)error {

    if (!filePath) {

        return NO;
    }
    NSString *jsonString = [self cy_jsonString];
    return [jsonString writeToFile:filePath
                        atomically:useAuxiliaryFile
                          encoding:NSUTF8StringEncoding
                             error:error];
}

@end
