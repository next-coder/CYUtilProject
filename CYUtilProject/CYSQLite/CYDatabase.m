//
//  CYDBConnection.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <sqlite3.h>


#import "CYSQLite.h"

#import "CYDatabase.h"
#import "CYPrepareStatement.h"
#import "CYResultSet.h"

@interface CYDatabase () {
    
    sqlite3* _sqlite3Database;
}

@end

@implementation CYDatabase

- (void)dealloc {
    
    if (_sqlite3Database) {
        
        sqlite3_close(_sqlite3Database);
        _sqlite3Database = nil;
    }
}

- (instancetype)initWithPath:(NSString *)path {
    
    if (self = [super init]) {
        
        _path = path;
        _status = CYDatabaseStatusNew;
    }
    return self;
}

#pragma mark - getter setter
- (sqlite3 *)sqlite3Database {
    
    return _sqlite3Database;
}

- (NSInteger)lastErrorCode {
    
    return sqlite3_errcode(_sqlite3Database);
}

- (NSString *)lastErrorMessage {
    
    return [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3Database)];
}

- (NSError *)lastError {
    
    NSString *errorMessage = self.lastErrorMessage;
    NSDictionary *userInfo = nil;
    if (errorMessage) {
        userInfo = @{ @"msg": errorMessage };
    }
    return [NSError errorWithDomain:CYSQLITE_ERROR_DOMAIN
                               code:self.lastErrorCode
                           userInfo:userInfo];
}

#pragma mark - open and close
- (NSInteger)open {
    
    if (_sqlite3Database) {
        
        return CYSQLITE_OK;
    }
    if (!_path
        || [@"" isEqualToString:_path]) {
        
        return CYSQLITE_PATH_ERROR;
    }
    int result = sqlite3_open([_path cStringUsingEncoding:NSUTF8StringEncoding], &_sqlite3Database);
    if (result == SQLITE_OK) {
        
        _status = CYDatabaseStatusConnected;
    } else {
        
        sqlite3_close_v2(_sqlite3Database);
        _sqlite3Database = nil;
    }
    return result;
}

- (NSInteger)close {
    
    if (!_sqlite3Database) {
        
        return CYSQLITE_OK;
    }
    int result = sqlite3_close(_sqlite3Database);
    if (result == SQLITE_OK) {
        
        _sqlite3Database = nil;
    }
    return result;
}

#pragma mark - evaluate sql
- (CYResultSet *)evaluateSQL:(NSString *)sql {
    
    return [self evaluateSQL:sql error:nil];
}

- (CYResultSet *)evaluateSQL:(NSString *)sql error:(NSError **)error {
    
    if (!sql
        || [@"" isEqualToString:sql]) {
        
        if (error) {
            
            *error = [NSError errorWithDomain:CYSQLITE_ERROR_DOMAIN
                                         code:CYSQLITE_SQL_ERROR
                                     userInfo:@{ @"msg": @"sql语句不能为空" }];
        }
        return nil;
    }
    if (!_sqlite3Database) {
        
        if (error) {
            
            *error = [NSError errorWithDomain:CYSQLITE_ERROR_DOMAIN
                                         code:CYSQLITE_SQL_ERROR
                                     userInfo:@{ @"msg": @"请先连接数据库" }];
        }
        return nil;
    }
    
    CYPrepareStatement *statement = [CYPrepareStatement prepareStatementWithSQL:sql parentDatabase:self];
    NSInteger result = [statement prepare];
    if (result != SQLITE_OK) {
        
        if (error) {
            
            *error = self.lastError;
        }
        return nil;
    } else {
        
        return [CYResultSet resultSetWithPrepareStatement:statement];
    }
}

#pragma mark - static method
+ (instancetype)databaseWithPath:(NSString *)path {
    
        return [[self alloc] initWithPath:path];
}

@end
