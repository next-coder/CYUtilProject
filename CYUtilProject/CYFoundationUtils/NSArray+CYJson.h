//
//  NSArray+CYJson.h
//  MoneyJar2
//
//  Created by Charry on 7/6/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CYJson)

// to json
- (NSString *)cy_jsonString;
- (NSData *)cy_jsonData;

// create array from json
+ (NSArray *)cy_arrayFromJsonString:(NSString *)jsonString;
+ (NSArray *)cy_arrayFromJsonData:(NSData *)jsonData;

// write to file as json string
- (BOOL)cy_writeToFileAsJson:(NSString *)filePath
                 automically:(BOOL)useAuxiliaryFile;

- (BOOL)cy_writeToFileAsJson:(NSString *)filePath
                  atomically:(BOOL)useAuxiliaryFile
                       error:(NSError **)error;

@end
