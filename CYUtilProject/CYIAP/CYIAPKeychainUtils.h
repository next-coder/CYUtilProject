//
//  CYIAPKeychainUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYIAPTransaction;

@interface CYIAPKeychainUtils : NSObject

// 保存未完成的transaction
+ (void)saveIAPTransaction:(CYIAPTransaction *)transaction;
+ (CYIAPTransaction *)transactionFromKeychain;
+ (void)removeIAPTransaction;

@end
