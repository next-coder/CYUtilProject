//
//  CYResultSet.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYPrepareStatement;

@interface CYResultSet : NSObject

@property (nonatomic, strong) CYPrepareStatement *prepareStatement;

#pragma mark - init
- (instancetype)initWithPrepareStatement:(CYPrepareStatement *)statement;

#pragma mark - static creator
+ (instancetype)resultSetWithPrepareStatement:(CYPrepareStatement *)statement;

#pragma mark - read row
- (BOOL)next;
- (BOOL)nextWithError:(NSError **)error;

@end
