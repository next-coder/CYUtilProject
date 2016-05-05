//
//  CYPrepareStatement.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYDatabase;

typedef NS_ENUM(NSInteger, CYPrepareStatementStatus) {
    
    CYPrepareStatementStatusNew,
    CYPrepareStatementStatusPrepared,
    CYPrepareStatementStatusClosed,
    CYPrepareStatementStatusReset
};

@interface CYPrepareStatement : NSObject

@property (nonatomic, copy, readonly) NSString *sql;
@property (nonatomic, weak, readonly) CYDatabase *parentDatabase;

@property (nonatomic, assign, readonly) CYPrepareStatementStatus status;

#warning 增加参数可变
//@property (nonatomic, copy) NSArray *values;

#pragma mark - getter setter
- (sqlite3_stmt *)sqlite3Statement;

#pragma mark - prepare close
- (NSInteger)prepare;
- (NSInteger)close;
- (NSInteger)reset;

#pragma mark - init
- (instancetype)initWithSQL:(NSString *)sql parentDatabase:(CYDatabase *)parentDatabase;

#pragma mark - static constructor
+ (instancetype)prepareStatementWithSQL:(NSString *)sql
                         parentDatabase:(CYDatabase *)parentDatabase;

@end
