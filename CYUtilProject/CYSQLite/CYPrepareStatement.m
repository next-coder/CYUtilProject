//
//  CYPrepareStatement.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "sqlite3.h"

#import "CYSQLite.h"

#import "CYPrepareStatement.h"

@interface CYPrepareStatement () {
    
    sqlite3_stmt *_statement;
}

@end

@implementation CYPrepareStatement

- (void)dealloc {
    
    if (_statement) {
        
        sqlite3_finalize(_statement);
        _status = CYPrepareStatementStatusClosed;
    }
}

#pragma mark - init
- (instancetype)initWithSQL:(NSString *)sql parentDatabase:(CYDatabase *)parentDatabase {
    
    if (self = [super init]) {
        
        _sql = sql;
        _parentDatabase = parentDatabase;
        _status = CYPrepareStatementStatusNew;
    }
    return self;
}

#pragma mark - getter setter
- (sqlite3_stmt *)sqlite3Statement {
    
    return _statement;
}

#pragma mark - prepare close
- (NSInteger)prepare {
    
    if (_status == CYPrepareStatementStatusPrepared) {
        
        return CYSQLITE_OK;
    }
    if (_status == CYPrepareStatementStatusClosed) {
        
        return CYSQLITE_STATEMENT_CLOSED;
    }
    
    int result =  sqlite3_prepare_v2([_parentDatabase sqlite3Database],
                                     [_sql cStringUsingEncoding:NSUTF8StringEncoding],
                                     (int)[_sql lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                                     &_statement,
                                     NULL);
    if (result == SQLITE_OK) {
        
        _status = CYPrepareStatementStatusPrepared;
    } else {
        
        sqlite3_finalize(_statement);
    }
    return result;
}

- (NSInteger)close {
    
    if (!_statement) {
        
        return CYSQLITE_OK;
    }
    int result = sqlite3_finalize(_statement);
    _statement = nil;
    _status = CYPrepareStatementStatusClosed;
    return result;
}

- (NSInteger)reset {
    
    if (_status == CYPrepareStatementStatusClosed) {
        
        return CYSQLITE_STATEMENT_CLOSED;
    }
    if (_status == CYPrepareStatementStatusPrepared) {
        
        NSInteger result = sqlite3_reset(_statement);
        if (result == SQLITE_OK) {
            
            _status = CYPrepareStatementStatusReset;
        }
        return result;
    }
    return CYSQLITE_OK;
}

#pragma mark - static constructor
+ (instancetype)prepareStatementWithSQL:(NSString *)sql
                         parentDatabase:(CYDatabase *)parentDatabase {
    
    return [[self alloc] initWithSQL:sql parentDatabase:parentDatabase];
}

@end
