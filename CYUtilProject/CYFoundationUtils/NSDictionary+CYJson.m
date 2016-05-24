//
//  NSDictionary+CYJson.m
//  MoneyJar2
//
//  Created by Charry on 7/6/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "NSDictionary+CYJson.h"

@implementation NSDictionary (CYJson)

#pragma mark - toJson
// dictionary to json string
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

// dictionary to json data
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

#pragma mark - fromJson
// create dictionary from json string
+ (NSDictionary *)cy_dictionaryFromJsonString:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self cy_dictionaryFromJsonData:jsonData];
}

// create dictionary from json Data
+ (NSDictionary *)cy_dictionaryFromJsonData:(NSData *)jsonData {
    
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
- (BOOL)writeToFileAsJson:(NSString *)filePath automically:(BOOL)useAuxiliaryFile {

    return [self writeToFileAsJson:filePath
                        atomically:useAuxiliaryFile
                             error:nil];
}

- (BOOL)writeToFileAsJson:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile error:(NSError **)error {

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
