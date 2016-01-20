//
//  CYResultSet.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "sqlite3.h"

#import "CYSQLite.h"
#import "CYResultSet.h"
#import "CYPrepareStatement.h"
#import "CYDatabase.h"

@interface CYResultSet ()

@end

@implementation CYResultSet

- (void)dealloc {
    
    _prepareStatement = nil;
}

- (instancetype)initWithPrepareStatement:(CYPrepareStatement *)statement {
    
    if (self = [super init]) {
        
        _prepareStatement = statement;
    }
    return self;
}

- (void)close {
    
    [_prepareStatement reset];
    _prepareStatement = nil;
}

#pragma mark - read row
- (BOOL)next {
    
    return [self nextWithError:nil];
}

- (BOOL)nextWithError:(NSError **)error {
    
    if (!_prepareStatement
        || _prepareStatement.status != CYPrepareStatementStatusPrepared) {
        
        if (error) {
            
            *error = [NSError errorWithDomain:CYSQLITE_ERROR_DOMAIN
                                         code:CYSQLITE_STATEMENT_NOT_PREPARED
                                     userInfo:@{ @"msg": @"prepare statement 状态错误" }];
        }
        return NO;
    }
    int result = sqlite3_step([_prepareStatement sqlite3Statement]);
    if (result == SQLITE_ROW) {
        
        return YES;
    } else if (result == SQLITE_DONE) {
        
        [self close];
        return YES;
    }
    if (error) {
        
        *error = _prepareStatement.parentDatabase.lastError;
    }
    [self close];
    return NO;
}

#pragma mark - read column
- (int)totalColumns {
    
    return sqlite3_column_count([_prepareStatement sqlite3Statement]);
}

- (NSString *)columnNameAtIndex:(const int)columnIndex {
    
    if (columnIndex < 0) {
        return nil;
    }
    const char* columnName = sqlite3_column_name([_prepareStatement sqlite3Statement], (int)index);
    return [NSString stringWithUTF8String:columnName];
}

- (int)columnTypeAtIndex:(const int)columnIndex {
    return sqlite3_column_type([_prepareStatement sqlite3Statement], columnIndex);
}

- (BOOL)boolValueAtIndex:(const int)columnIndex {
    
    return ([self integerValueAtIndex:columnIndex] != 0);
}

- (NSInteger)integerValueAtIndex:(const int)columnIndex {
    
    if (columnIndex < 0) {
        
        return 0;
    }
    return sqlite3_column_int([_prepareStatement sqlite3Statement], columnIndex);
}

- (long long)longLongValueAtIndex:(const int)columnIndex {
    
    if (columnIndex < 0) {
        
        return 0;
    }
    return sqlite3_column_int64([_prepareStatement sqlite3Statement], columnIndex);
}

- (double)doubleValueAtIndex:(const int)columnIndex {
    
    if (columnIndex < 0) {
        
        return 0;
    }
    return sqlite3_column_double([_prepareStatement sqlite3Statement], columnIndex);
}

- (NSString *)stringValueAtIndex:(const int)columnIndex {
    
    if (columnIndex < 0) {
        return nil;
    }
    if ([self columnTypeAtIndex:columnIndex] == SQLITE_NULL) {
        
        return nil;
    }
    const char* value = (const char *)sqlite3_column_text([_prepareStatement sqlite3Statement], (int)columnIndex);
    return [NSString stringWithUTF8String:value];
}

- (NSData *)dataValueAtIndex:(const int)columnIndex {
    
    if (columnIndex < 0) {
        return nil;
    }
    if ([self columnTypeAtIndex:columnIndex] == SQLITE_NULL) {
        
        return nil;
    }
    
    const void* value = sqlite3_column_blob([_prepareStatement sqlite3Statement], columnIndex);
    if (!value) {
        
        return nil;
    }
    return [NSData dataWithBytes:value length:sqlite3_column_bytes([_prepareStatement sqlite3Statement], columnIndex)];
}

#pragma mark - static creator
+ (instancetype)resultSetWithPrepareStatement:(CYPrepareStatement *)statement {
    
    return [[self alloc] initWithPrepareStatement:statement];
}

@end
