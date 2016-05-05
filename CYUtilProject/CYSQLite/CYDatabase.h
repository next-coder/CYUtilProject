//
//  CYDBConnection.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYResultSet;
@class CYPrepareStatement;

typedef NS_ENUM(NSInteger, CYDatabaseStatus) {
    
    CYDatabaseStatusNew,
    CYDatabaseStatusConnected,
    CYDatabaseStatusClosed
};

@interface CYDatabase : NSObject

@property (nonatomic, assign, readonly) CYDatabaseStatus status;

@property (nonatomic, copy, readonly) NSString *path;

@property (nonatomic, assign, readonly) NSInteger lastErrorCode;
@property (nonatomic, strong, readonly) NSString *lastErrorMessage;
@property (nonatomic, strong, readonly) NSError *lastError;

- (sqlite3 *)sqlite3Database;

#pragma mark - evaluate sql
- (CYResultSet *)evaluateSQL:(NSString *)sql;
- (CYResultSet *)evaluateSQL:(NSString *)sql error:(NSError **)error;

#pragma mark - static method
+ (instancetype)databaseWithPath:(NSString *)path;

@end
